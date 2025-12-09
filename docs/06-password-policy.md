# 06 – Password Policy and Sudo Timeout

This section aligns roughly with CIS/Wazuh controls for local password policy.

## 1. Sudo timeout set to zero

Goal: no five-minute grace window for sudo.

Edit a dedicated sudoers config (no file extension):

```bash
sudo visudo -f /etc/sudoers.d/10_cis_sudo_timeout
````

Add:

```text
Defaults timestamp_timeout=0
```

Ensure correct ownership if needed:

```bash
sudo chown -R root:wheel /etc/sudoers.d/
```

Verify:

```bash
sudo -V | grep "Authentication timestamp timeout"
```

You want:

```text
Authentication timestamp timeout: 0.0 minutes
```

## 2. Password history (no reuse of last 15)

```bash
sudo pwpolicy -n /Local/Default -setglobalpolicy "usingHistory=15"
```

Check:

```bash
pwpolicy -getaccountpolicies | grep -A1 usingHistory
```

Ensure the numeric value is `>= 15`.

## 3. Password age (maximum lifetime)

Example: 365 days (525600 minutes):

```bash
sudo pwpolicy -n /Local/Default -setglobalpolicy "maxMinutesUntilChangePassword=525600"
```

Check:

```bash
pwpolicy -n /Local/Default -getglobalpolicy | grep maxMinutesUntilChangePassword
```

Ensure the reported number is `<= 525600` per your policy.

## 4. Complexity: symbols, digits, letters

Require at least one special character:

```bash
sudo pwpolicy -n /Local/Default -setglobalpolicy "requiresSymbol=1"
```

Require at least one alphabetic character:

```bash
sudo pwpolicy -n /Local/Default -setglobalpolicy "requiresAlpha=1"
```

Check:

```bash
pwpolicy -getaccountpolicies | grep -A1 requiresSymbol
pwpolicy -getaccountpolicies | grep -A1 minimumLetters
```

You want each numeric value to be `>= 1`.

## 5. Minimum length (example, 15 characters)

```bash
sudo pwpolicy -n /Local/Default -setglobalpolicy "minChars=15"
```

Check:

```bash
pwpolicy -n /Local/Default -getglobalpolicy | grep minChars
```

Value should be `>= 15`.

## 6. Account lockout threshold and reset

Lock account after 5 failed logins and reset after 15 minutes:

```bash
sudo pwpolicy -n /Local/Default -setglobalpolicy "maxFailedLoginAttempts=5"
sudo pwpolicy -n /Local/Default -setglobalpolicy "policyAttributeMinutesUntilFailedAuthenticationReset=15"
```

Check:

```bash
pwpolicy -n /Local/Default -getglobalpolicy | grep maxFailedLoginAttempts
pwpolicy -n /Local/Default -getglobalpolicy | grep policyAttributeMinutesUntilFailedAuthenticationReset
```

You want:

* `maxFailedLoginAttempts <= 5`
* `policyAttributeMinutesUntilFailedAuthenticationReset >= 15`


## 7. Operational hygiene: random password generation

You can generate strong, local passwords offline:

Using OpenSSL:

```bash
openssl rand -base64 30
```

Using GnuPG:

```bash
gpg --gen-random -a 0 90 | fold -w 40
```

Using /dev/urandom and printable characters:

```bash
tr -dc '[:graph:]' < /dev/urandom | fold -w 40 | head -n 5
```

Store passwords in an offline or high-trust password manager. Do not reuse across systems and services.

