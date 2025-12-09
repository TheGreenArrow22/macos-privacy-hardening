#!/usr/bin/env bash
#
# Example: apply a strong local password policy via pwpolicy.
# This can break weak passwords and cause lockouts. Review carefully.

set -euo pipefail

echo "[*] Setting password history to 15..."
pwpolicy -n /Local/Default -setglobalpolicy "usingHistory=15"

echo "[*] Setting max password age to 365 days..."
pwpolicy -n /Local/Default -setglobalpolicy "maxMinutesUntilChangePassword=525600"

echo "[*] Requiring at least one symbol and one alpha character..."
pwpolicy -n /Local/Default -setglobalpolicy "requiresSymbol=1"
pwpolicy -n /Local/Default -setglobalpolicy "requiresAlpha=1"

echo "[*] Setting minimum password length to 15..."
pwpolicy -n /Local/Default -setglobalpolicy "minChars=15"

echo "[*] Setting lockout after 5 failed attempts, reset after 15 minutes..."
pwpolicy -n /Local/Default -setglobalpolicy "maxFailedLoginAttempts=5"
pwpolicy -n /Local/Default -setglobalpolicy "policyAttributeMinutesUntilFailedAuthenticationReset=15"

echo "[*] Current global policy:"
pwpolicy -n /Local/Default -getglobalpolicy
