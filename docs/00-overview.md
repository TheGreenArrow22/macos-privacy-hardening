# 00 – Overview

This repository documents a hardened macOS workstation baseline focused on:

- Reducing attack surface
- Increasing visibility and auditability
- Tightening authentication and password policy
- Making network behavior transparent and explicit

The sections are structured logically:

1. `01-integrity-and-xprotect.md`
2. `02-users-and-groups.md`
3. `03-firewall-and-networking.md`
4. `04-dns-and-hosts.md`
5. `05-logging-and-auditing.md`
6. `06-password-policy.md`
7. `07-loginwindow-and-banners.md`
8. `08-finder-ui-and-filevault.md`
9. `09-third-party-tools.md`

Each section contains:

- Commands
- Expected outputs / checks
- Rationale

You do **not** need to apply every control. Use your threat model.

Basic assumptions:

- You have admin access (sudo).
- You are comfortable in Terminal.
- You can recover a system from a Time Machine or image backup if needed.
