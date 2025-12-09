# 08 – Finder Visibility, Hidden Files, and FileVault

This section balances usability and visibility. You want enough exposure to see what is going on without making the system unmanageable.

## 1. Finder: show hidden files and Library

Show all hidden files in Finder:

```bash
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder
````

Unhide the user Library folder:

```bash
chflags nohidden ~/Library
```

Be aware: showing everything will clutter Finder but is useful for investigations.

## 2. Show all filename extensions

```bash
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
killall Finder
```

This prevents tricks like `invoice.pdf.app` appearing as `invoice.pdf`.

## 3. Search for hidden files and directories (full system)

For deep hunts from the terminal:

```bash
sudo find / -name ".*" -type f -or -type d 2>/dev/null
```

This will:

* Walk the entire filesystem
* Print files and directories starting with `.`
* Ignore permission errors

Do not blindly delete what you find. Many hidden files are legitimate.

## 4. FileVault (full-disk encryption)

Enable FileVault from Terminal:

```bash
sudo fdesetup enable
```

This will:

* Prompt for a user password
* Generate a recovery key

Ensure:

* You store the recovery key offline and securely.
* You understand that losing both password and recovery key means losing the data.

You can also manage FileVault via System Settings:

* System Settings → Privacy & Security → FileVault

## 5. Lockdown Mode (for high-risk profiles)

macOS includes Lockdown Mode aimed at extremely high-risk users (targeted by advanced threats, exploit chains, etc.).

You enable it via GUI:

* System Settings → Privacy & Security → Lockdown Mode

There is no stable, documented terminal equivalent for all behaviors, and Apple may change internals between releases.

Expect:

* Reduced attack surface in Messages, Safari, and other components
* Tightened rules around attachments, JIT, and remote content

Downside:

* Some sites, apps, and features may break or degrade.

If you suspect targeted exploitation, Lockdown Mode is worth testing on a non-production machine first, then enabling on primary devices with eyes open.
