# 07 – Login Window, Full Credentials, and Banner

## 1. Require both username and password at login

Force the login window to show “Name and password”:

```bash
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true
````

Check via JavaScript bridge:

```bash
osascript -l JavaScript -e '$.NSUserDefaults.alloc.initWithSuiteName("com.apple.loginwindow").objectForKey("SHOWFULLNAME")'
```

Return value should be `1` or `true`.

## 2. Login window banner (PolicyBanner)

Create a text or RTF banner file:

```bash
sudo nano /Library/Security/PolicyBanner.txt
```

Put whatever legal / warning text you want, for example:

> Authorized use only. Activity may be monitored and logged. By proceeding, you consent to monitoring.

Then set permissions so it is world-readable:

```bash
sudo chown root:wheel /Library/Security/PolicyBanner.txt
sudo chmod o+r /Library/Security/PolicyBanner.txt
```

Checks (from Wazuh/CIS logic):

* `stat -f %A /Library/Security/PolicyBanner.*` should show a mode ending in `4` (world-readable).
* Directory `/Library/Security` should contain a `PolicyBanner.*` file.

On next login, users must acknowledge the banner before proceeding.

## 3. Custom login message (optional separate approach)

If you prefer a lighter message, you can use:

```bash
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "For Personal Use Only"
```

This is not as strong as a banner with legal language, but still a useful signal.
