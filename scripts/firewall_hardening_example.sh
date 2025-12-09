#!/usr/bin/env bash
#
# Example: conservative firewall hardening for macOS.
# Review every line before running. Run with:
#   sudo ./firewall_hardening_example.sh

set -euo pipefail

echo "[*] Enabling Application Firewall..."
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

echo "[*] Enabling firewall logging..."
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

echo "[*] Enabling stealth mode..."
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

echo "[*] Disabling automatic allow for signed code..."
/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

echo "[*] Reloading socketfilterfw..."
pkill -HUP socketfilterfw || true

echo "[*] Current firewall state:"
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate

echo "[*] Done. Verify behavior and app connectivity manually."
