from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
TEXT_EXTENSIONS = {".md", ".txt", ".py", ".ps1", ".yml", ".yaml", ".json"}
IGNORED = {".git", "__pycache__"}

PATTERNS = {
    "non-example email": re.compile(r"\b[A-Z0-9._%+-]+@(?!example\.(?:com|org|net)\b)[A-Z0-9.-]+\.[A-Z]{2,}\b", re.I),
    "Windows user path": re.compile(r"(?i)\b[A-Z]:\\Users\\(?!<user>)[^\\\s]+"),
    "Linux home path": re.compile(r"(?i)/home/(?!<user>)[A-Za-z0-9._-]+"),
    "IPv4 address": re.compile(r"\b(?:\d{1,3}\.){3}\d{1,3}\b"),
    "long numeric identifier": re.compile(r"(?<!\d)\d{8,}(?!\d)"),
    "Telegram bot token shape": re.compile(r"\b\d{6,}:[A-Za-z0-9_-]{20,}\b"),
}


def iter_text_files():
    for path in ROOT.rglob("*"):
        if not path.is_file() or path.suffix.lower() not in TEXT_EXTENSIONS:
            continue
        if any(part in IGNORED for part in path.parts):
            continue
        yield path


def main() -> int:
    failures: list[str] = []
    for path in iter_text_files():
        text = path.read_text(encoding="utf-8")
        for label, pattern in PATTERNS.items():
            for match in pattern.finditer(text):
                line = text.count("\n", 0, match.start()) + 1
                failures.append(f"{path.relative_to(ROOT)}:{line}: {label}")

    required = [
        ROOT / "README.md",
        ROOT / "LICENSE",
        ROOT / "SECURITY.md",
        ROOT / "skills" / "openclaw-windows-troubleshooter" / "SKILL.md",
    ]
    for path in required:
        if not path.exists():
            failures.append(f"missing required file: {path.relative_to(ROOT)}")

    if failures:
        print("Repository validation failed:")
        print("\n".join(f"- {item}" for item in failures))
        return 1

    print("Repository validation passed: structure and baseline privacy patterns are clean.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

