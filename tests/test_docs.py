from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from check_docs import check


class DocsTests(unittest.TestCase):
    def test_missing_target_fails(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / "README.md").write_text("[broken](missing.md)", encoding="utf-8")
            self.assertTrue(check(root))

    def test_local_and_external_links(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / "README.md").write_text("[ok](guide.md#step) [web](https://example.com)", encoding="utf-8")
            (root / "guide.md").write_text("# Step", encoding="utf-8")
            self.assertEqual(check(root), [])

    def test_invalid_svg_fails(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / "bad.svg").write_text("<svg>", encoding="utf-8")
            self.assertTrue(check(root))
