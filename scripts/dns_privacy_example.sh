#!/usr/bin/env bash
#
# Example: dnscrypt-proxy install and basic wiring for Wi-Fi.
# This is a skeleton. You MUST review and adapt for your environment.

set -euo pipefail

INTERFACE="Wi-Fi"

echo "[*] Installing dnscrypt-proxy via Homebrew (requires brew)..."
brew install dnscrypt-proxy

CONF="/opt/homebrew/etc/dnscrypt-proxy.toml"

if [ ! -f "$CONF" ]; then
  echo "[!] Expected config at $CONF not found. Check brew info dnscrypt-proxy."
  exit 1
fi

echo "[*] Ensure dnscrypt-proxy is configured to listen on 127.0.0.1:53 in $CONF."
echo "    Press Enter to continue once you have reviewed/edited the config."
read -r _

echo "[*] Starting dnscrypt-proxy as a service..."
brew services start dnscrypt-proxy

echo "[*] Pointing $INTERFACE DNS to 127.0.0.1..."
networksetup -setdnsservers "$INTERFACE" 127.0.0.1

echo "[*] Flushing DNS cache..."
dscacheutil -flushcache
killall -HUP mDNSResponder || true

echo "[*] Done. Verify DNS with:"
echo "    scutil --dns"
echo "    dig example.com"
