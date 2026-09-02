"""Check local documentation targets and parse original SVG assets; offline only."""
from pathlib import Path
import re
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]


def check(root):
    errors = []
    for path in root.rglob("*.md"):
        if ".git" in path.parts:
            continue
        content = path.read_text(encoding="utf-8")
        targets = re.findall(r'!?\[[^\]]*\]\(([^\s)]+)\)', content)
        targets += re.findall(r'(?:src|href)="([^"]+)"', content)
        for target in targets:
            if target.startswith(("#", "https://", "http://", "mailto:")):
                continue
            target = target.split("#")[0]
            if target and not (path.parent / target).is_file():
                errors.append(f"{path.relative_to(root)}: missing local link target")
    for path in root.rglob("*.svg"):
        try:
            doc = ET.parse(path).getroot()
            ns = "{http://www.w3.org/2000/svg}"
            if doc.tag != ns + "svg" or doc.find(ns + "title") is None or doc.find(ns + "desc") is None:
                errors.append(f"{path.relative_to(root)}: SVG needs title and description")
        except ET.ParseError:
            errors.append(f"{path.relative_to(root)}: invalid SVG")
    return errors


if __name__ == "__main__":
    failures = check(ROOT)
    print("\n".join(failures) if failures else "PASS: local documentation targets and SVG structure")
    sys.exit(bool(failures))
