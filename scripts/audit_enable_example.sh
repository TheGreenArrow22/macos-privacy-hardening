#!/usr/bin/env bash
#
# Example: enable auditd on systems that still support it.
# Deprecated on recent macOS; use only if you understand the cost.

set -euo pipefail

echo "[*] Loading auditd LaunchDaemon..."
launchctl load -w /System/Library/LaunchDaemons/com.apple.auditd.plist || true

if [ ! -f /etc/security/audit_control ]; then
  echo "[*] Creating /etc/security/audit_control from example..."
  cp /etc/security/audit_control.example /etc/security/audit_control
fi

echo "[*] Reloading audit configuration..."
audit -s

echo "[*] Checking auditd in launchctl list..."
launchctl list | grep com.apple.auditd || echo "[!] auditd not found in launchctl list."

echo "[*] Audit logs should appear under /var/audit"
ls -la /var/audit || true
