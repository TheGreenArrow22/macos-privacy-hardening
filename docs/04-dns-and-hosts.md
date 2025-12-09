# 04 – DNS, Hosts, and MAC Spoofing

DNS is often the first place attackers and trackers touch. This section covers:

- Simple domain blocking via `/etc/hosts`
- DNS privacy (dnscrypt-proxy and dnsmasq with DNSSEC)
- Flushing DNS cache
- MAC address spoofing on untrusted networks

## 1. Editing /etc/hosts

Use `/etc/hosts` for coarse blocking or overrides. Edit as root:

```bash
sudo vi /etc/hosts
````

Add entries like:

```text
0       example.com
0.0.0.0 bad.tracker.com
127.0.0.1 some.internal.override
```

All variants (`0`, `0.0.0.0`, `127.0.0.1`) will work for simple blocking, but be consistent.

After changes, flush DNS cache:

```bash
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

If you rely on `/etc/hosts` heavily, keep it under version control somewhere (not with secrets).

## 2. Homebrew and prerequisites

Several tools here assume:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

and Command Line Tools:

```bash
xcode-select --install
```

Verify:

```bash
brew --version
```

## 3. Encrypting DNS with dnscrypt-proxy

Install:

```bash
brew install dnscrypt-proxy
```

Typical config path:

```bash
/opt/homebrew/etc/dnscrypt-proxy.toml
```

Key steps (high level):

1. Choose resolvers that support DNSCrypt / DoH / DoT and have sane privacy policies.

2. Configure `listen_addresses` locally (e.g. `127.0.0.1:53`).

3. Point your network interface to 127.0.0.1:

   ```bash
   networksetup -setdnsservers Wi-Fi 127.0.0.1
   ```

4. Enable dnscrypt-proxy as a service:

   ```bash
   brew services start dnscrypt-proxy
   ```

Confirm DNS is going through dnscrypt-proxy and not your ISP’s resolver.

## 4. dnsmasq with DNSSEC

Install:

```bash
brew install dnsmasq --with-dnssec
```

Note: on newer Homebrew, `--with-dnssec` may be deprecated; check `brew info dnsmasq`. If so, follow the current documentation for enabling DNSSEC.

Example minimal config (`/opt/homebrew/etc/dnsmasq.conf`):

```text
# Listen locally
listen-address=127.0.0.1
port=53

# Use upstream DNS servers that support DNSSEC
server=1.1.1.1
server=1.0.0.1

# DNSSEC
dnssec
trust-anchor=.,19036,8,2,49AAC11D7B6F6443...
```

This is just a starting point. DNSSEC can be brittle if upstreams or paths are misconfigured.

Point the interface DNS to 127.0.0.1:

```bash
networksetup -setdnsservers Wi-Fi 127.0.0.1
```

or for Ethernet if you are on wired only.

## 5. DNS cache flush (operational)

Whenever you:

* Change `/etc/hosts`
* Change DNS servers
* Rotate VPN DNS settings

flush the cache:

```bash
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

If you are actively hunting, do this between tests to avoid stale answers.

## 6. MAC address spoofing on untrusted Wi-Fi

On a system that still uses Wi-Fi and allows interface changes, you can spoof the MAC address before connecting to a new network.

Example for `en0`:

```bash
sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's%\(..\)%\1:%g; s%$%%')
```

Explanation:

* `openssl rand -hex 6` generates 6 random bytes.
* `sed` formats them as `aa:bb:cc:dd:ee:ff`.
* `ifconfig en0 ether` applies it to interface `en0`.

Check:

```bash
ifconfig en0 | grep ether
```

Be aware:

* Some newer macOS versions and hardware enforce restrictions or do their own MAC randomization.
* Many networks log your MAC; spoofing changes identity but also breaks MAC-based whitelisting.
* Do this **before** joining the network, not mid-session.

Use sparingly and deliberately.

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
