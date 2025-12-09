# 09 – Third-Party Tools (Firewall, Malware, Packet Filters)

Built-in controls should be your baseline. Third-party tools can provide:

- Better visibility
- More granular control
- Independent detection paths

This is not an endorsement list; it is a starting map.

## 1. Application firewalls

These sit above or alongside the built-in firewall to control outbound traffic, per-app.

### Vallum

- GUI for managing outbound connections.
- Often paired with Murus (packet filter frontend).
- Good visibility into what wants to talk out.

### Little Snitch

- Long-standing, feature-rich outbound firewall.
- Detailed rules, profiles, alerts.
- Good for detecting unexpected beaconing and telemetry.

### Radio Silence

- Minimal, simpler outbound firewall.
- Lower noise if you do not want complex rule sets.

### LuLu (by Objective-See)

- Free, open-source outbound firewall.
- Focused on detecting unknown or suspicious outbound traffic.
- Works well as a lightweight layer on top of built-in controls.

## 2. Malware and persistence tools

### Bitdefender / Malwarebytes

- Traditional AV/endpoint products.
- Signature-based detection plus some heuristic/risk detection.
- Useful for commodity threats and second opinions.

### KnockKnock (Objective-See)

- Enumerates persistent software (launch agents/daemons, cron, login items, etc.).
- Focus on what “will run,” not just what “is running.”

### BlockBlock (Objective-See)

- Monitors persistence mechanisms in real time.
- Alerts when something attempts to register a new persistence point.

Use these to cross-check:

- Launch agents/daemons you already see via `launchctl list`.
- Startup items and login items present in the system.

## 3. Packet filter frontends

### Murus

- GUI frontend for pf (the built-in packet filter).
- Allows building inbound/outbound rules beyond `socketfilterfw`.
- Often used with Vallum to combine packet-level and app-level rules.

Be very deliberate with pf rules; a broken config can cut off network access entirely.

## 4. Prerequisites: Xcode tools and Homebrew

Before installing most of the above:

```bash
xcode-select --install
````

Then:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Homebrew gives you access to:

* dnscrypt-proxy
* dnsmasq
* Command-line utilities for analysis and monitoring

Keep Homebrew itself updated:

```bash
brew update
brew upgrade
```

## 5. Strategy: layer, do not stack blindly

* Start with built-in controls: FileVault, firewall, password policy, Lockdown Mode.
* Add one or two third-party tools where they clearly add value.
* Avoid running three different outbound firewalls simultaneously.
* Regularly review:

  * Which tools have kernel/system extensions
  * What telemetry they send out
  * How they update and how fast they patch

Tools that claim to increase security but expand the attack surface or phone home aggressively are not worth it.
