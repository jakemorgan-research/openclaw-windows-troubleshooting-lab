from pathlib import Path
import sys
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from validate_repo import scan_text, scan_metadata


class PrivacyTests(unittest.TestCase):
    def test_github_noreply_id_is_not_a_phone(self):
        account_id = "12345" + "67890"
        email = account_id + "+contributor" + "@" + "users.noreply.github.com"
        self.assertEqual(scan_metadata(email), [])
        self.assertTrue(scan_metadata(account_id))
        self.assertTrue(scan_metadata(account_id + "+contributor" + "@" + "private.invalid"))

    def test_contacts_paths_and_tokens_detected_without_echo(self):
        fixtures = [
            "person" + "@" + "private.invalid",
            "D:\\" + "Users\\" + "fixture-person",
            ".".join(["192", "0", "2", "10"]),
            "12345" + "67890",
            "sk-" + "a" * 28,
            "ghp_" + "b" * 30,
            "api" + "_key=" + "c" * 30,
        ]
        for value in fixtures:
            with self.subTest(kind=len(value)):
                findings = scan_text(value, "synthetic")
                self.assertTrue(findings)
                self.assertNotIn(value, "\n".join(findings))

    def test_safe_example_and_noreply(self):
        for value in ("person" + "@" + "example.com",
                      "contributor" + "@" + "users.noreply.github.com",
                      "Gateway running; version 1.2.3"):
            self.assertEqual(scan_text(value, "synthetic"), [])

    def test_only_explicit_dummy_is_exempt(self):
        self.assertEqual(scan_text("password: FAKE_DEMO_ONLY_NOT_A_CREDENTIAL", "synthetic"), [])
        self.assertTrue(scan_text("password: " + "fake" * 8, "synthetic"))

    def test_svg_text_is_scannable(self):
        text = "<svg><text>" + "person" + "@" + "private.invalid" + "</text></svg>"
        self.assertTrue(scan_text(text, "synthetic.svg"))
