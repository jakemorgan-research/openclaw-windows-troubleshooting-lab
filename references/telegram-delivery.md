# Telegram delivery versus device notification

Keep two paths separate:

```text
OpenClaw -> Telegram Bot API -> accepted message
Telegram service -> APNs -> iPhone lock-screen notification
```

A successful Bot API response does not prove that iOS displayed a notification. Opening Telegram and seeing a queued message proves synchronization, not an earlier APNs delivery.

## OpenClaw-side ladder

1. Check Gateway and Telegram channel status.
2. Inspect a short log window for one send.
3. Distinguish caller timeout from a final delivery error.
4. Check DNS, IPv4/IPv6, proxy routing, and TLS to `api.telegram.org` when network errors appear.
5. Use current official Telegram channel settings; never paste a bot token into a report.

## Device-side isolation

Compare a normal person-to-person Telegram message with the bot message while the app is in the same foreground/background state. If both fail only on the receiving device, stop changing OpenClaw and move the investigation to Telegram/iOS notification state.

## Privacy

Redact bot tokens, numeric chat/user IDs, message contents, proxy endpoints, public IPs, and device names. If a token was exposed, rotate it rather than merely deleting the screenshot.
