# Windows and WSL network boundary

In WSL2 NAT mode, `localhost` inside Linux is not automatically the Windows host. A proxy that listens only on Windows loopback may therefore be unreachable from WSL.

## Safe checks

1. Identify the active WSL networking mode.
2. Confirm the proxy listener's bind address without exposing it publicly.
3. Test WSL -> proxy TCP reachability.
4. Test a TLS request through the proxy.
5. Compare repeated results before calling the configuration broken.

Use placeholders in reports:

```text
http://<windows-host-address>:<proxy-port>
https://<service-host>/
```

## Interpret the stages

```text
TCP connection failed
  -> listener, address, firewall, or WSL route

HTTP CONNECT succeeded but TLS timed out
  -> proxy upstream, selected route, DNS, IPv4/IPv6, or service path

TLS succeeded but API failed
  -> authentication, API policy, rate limit, or application request
```

Do not publish real proxy addresses, node names, credentials, or screenshots of proxy dashboards. Do not enable unrestricted LAN listening as a generic fix.
