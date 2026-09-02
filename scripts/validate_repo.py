"""Read-only privacy baseline for text, paths, metadata, and reachable Git blobs.

Findings contain location/category only. This is not a complete PII or secret detector.
"""
from pathlib import Path
import argparse
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
EXTENSIONS = {".md", ".txt", ".py", ".ps1", ".json", ".jsonl", ".yaml", ".yml", ".svg", ".html"}
IGNORED = {".git", "__pycache__", ".venv", "node_modules", ".tmp_validate_deps"}
PATTERNS = {
    "contact email": re.compile(r"\b[A-Z0-9._%+-]+@(?!example\.(?:com|org|net)\b|(?:[A-Z0-9.-]+\.)?users\.noreply\.github\.com\b)[A-Z0-9.-]+\.[A-Z]{2,}\b", re.I),
    "user directory": re.compile(r"(?:[A-Z]:\\Users\\(?!<user>)|/(?:home|Users)/)[A-Z0-9._-]+", re.I),
    "IPv4 address": re.compile(r"\b(?:\d{1,3}\.){3}\d{1,3}\b"),
    "long numeric identifier": re.compile(r"(?<!\d)\d{8,}(?!\d)"),
    "credential-shaped value": re.compile(r"\b(?:sk-[A-Za-z0-9_-]{16,}|gh[pousr]_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]{20,}|\d{6,}:[A-Za-z0-9_-]{20,})\b"),
    "private key": re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
    "secret assignment": re.compile(r"""(?i)\b(?:api[_-]?key|token|secret|password)\b["']?\s*[:=]\s*["']?([A-Za-z0-9_-]{20,})"""),
}
DEMO_VALUES = {"FAKE_DEMO_ONLY_NOT_A_CREDENTIAL"}
REQUIRED = {"README.md", "SKILL.md", "LICENSE", "SECURITY.md", "CONTRIBUTING.md",
            "agents/openai.yaml", "docs/GETTING_STARTED.zh-CN.md", "docs/VERIFICATION.md",
            "docs/media/hero.svg", ".github/ISSUE_TEMPLATE/bug_report.yml"}


def scan_text(text, location):
    errors = []
    for label, pattern in PATTERNS.items():
        for match in pattern.finditer(text):
            if label == "secret assignment" and match.group(1) in DEMO_VALUES:
                continue
            line = text.count("\n", 0, match.start()) + 1
            errors.append(f"{location}:{line}: possible {label} (value withheld)")
    return errors


def git(root, *args):
    return subprocess.check_output(["git", "-C", str(root), *args],
                                   stderr=subprocess.DEVNULL)


def scan_history(root):
    errors = []
    # Scan every reachable blob once, including deleted text and earlier versions.
    objects = git(root, "rev-list", "--objects", "--all").decode("utf-8", "replace").splitlines()
    for item in objects:
        sha = item.split(" ", 1)[0]
        kind = git(root, "cat-file", "-t", sha).strip()
        if kind != b"blob":
            continue
        raw = git(root, "cat-file", "blob", sha)
        try:
            text = raw.decode("utf-8")
        except UnicodeError:
            errors.append(f"history:{sha[:8]}: binary blob requires manual privacy review")
            continue
        errors.extend(scan_text(text, "history:" + sha[:8]))
    metadata = git(root, "log", "--all", "--format=%an%n%ae%n%cn%n%ce%n%B").decode("utf-8", "replace")
    errors.extend(scan_text(metadata, "commit-metadata"))
    return errors


def scan_repository(root):
    errors = []
    for required in sorted(REQUIRED):
        if not (root / required).is_file():
            errors.append(f"missing required file: {required}")
    for path in root.rglob("*"):
        if not path.is_file() or any(part in IGNORED for part in path.relative_to(root).parts):
            continue
        relative = path.relative_to(root).as_posix()
        errors.extend(scan_text(relative, "filename"))
        if path.suffix.lower() not in EXTENSIONS and path.name not in {"LICENSE", ".gitignore"}:
            errors.append(f"{relative}: unreviewed file type")
            continue
        try:
            content = path.read_text(encoding="utf-8-sig")
        except UnicodeError:
            errors.append(f"{relative}: not UTF-8 text")
            continue
        errors.extend(scan_text(content, relative))
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--history", action="store_true", help="also scan reachable Git blobs and commit metadata")
    args = parser.parse_args()
    try:
        errors = scan_repository(ROOT)
        if args.history:
            errors.extend(scan_history(ROOT))
    except (OSError, subprocess.SubprocessError):
        print("FAIL: a required read or history check could not complete; details withheld")
        return 2
    if errors:
        print("FAIL\n" + "\n".join(sorted(set(errors))))
        return 1
    print("PASS: no configured privacy pattern matched; manual review remains required")
    return 0


if __name__ == "__main__":
    sys.exit(main())
