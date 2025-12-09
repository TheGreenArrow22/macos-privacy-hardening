# 03 – Firewall and Networking

## 1. Application Firewall (socketfilterfw)

Enable the firewall:

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
````

Enable logging:

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
```

Enable stealth mode (ignore unsolicited probes like ICMP ping):

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
```

By default, macOS tends to auto-whitelist signed binaries. You can tighten this.

### 1.1 Disable automatic whitelisting of signed code

Prevent built-in software and code-signed apps from being auto-allowed:

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off
```

Now, you control what gets network access.

### 1.2 Manage specific applications

Add an app:

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /path/to/app
```

Block an app explicitly:

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --blockapp /path/to/app
```

List firewall-registered apps:

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --listapps
```

Whenever you change firewall configuration, reload the daemon:

```bash
sudo pkill -HUP socketfilterfw
```

### 1.3 Check firewall status via defaults

Alternative check (used by CIS/Wazuh checks):

```bash
defaults read /Library/Preferences/com.apple.alf globalstate
```

Values:

* `0` – disabled
* `1` – enabled for specific services
* `2` – enabled for essential services only

Or:

```bash
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
```

You want it to report “Firewall is enabled”.

## 2. Remote access and unused protocols

Disable remote login (SSH):

```bash
sudo systemsetup -setremotelogin off
```

Disable wake on modem (legacy, but still worth setting off):

```bash
sudo systemsetup -setwakeonmodem off
```

Disable IPv6 on Wi-Fi (example interface):

```bash
sudo networksetup -setv6off Wi-Fi
```

Adjust the interface name (`Wi-Fi`, `Ethernet`, etc.) to match `networksetup -listallhardwareports`.

## 3. Inspecting network-related activity

### 3.1 List running processes

```bash
ps -ef
```

Baseline which processes normally exist on your system.

### 3.2 Open network files and sockets

```bash
sudo lsof -Pni
```

This gives you:

* Process name and PID
* Protocol
* Local and remote address
* State

Combine this with firewall rules and your own expectations. Unexpected listeners are a red flag.

### 3.3 Network statistics

```bash
sudo netstat -atln
```

This shows listening TCP ports and current connections. Focus on `LISTEN` entries that should not be present, and high-volume connections to unexpected remote IPs.

## 4. Network-related logging

Streaming logs live:

```bash
sudo log stream
```

24-hour security-related log view:

```bash
sudo log show --last 24h --predicate 'eventMessage contains "security"' --info
```

Network change logs (SSID, lease, network reconfiguration):

```bash
log show --info --predicate 'senderImagePath contains "IPConfiguration" and (eventMessage contains "SSID" or eventMessage contains "Lease" or eventMessage contains "network changed")'
```

Tune the time range with `--last 1h`, `--last 7d`.

