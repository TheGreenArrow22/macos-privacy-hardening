# 10 – Browsers and VPNs

Built-in OS hardening is only half the story. Your browser and VPN choices directly affect:

- How much your traffic can be profiled
- How much metadata you leak
- How painful it is for an attacker or data broker to track you over time

This section is opinionated. Tools listed here are not magic shields; they are components in a broader security posture.

---

## 1. Browsers

### 1.1 Brave

Chromium-based browser with a privacy-focused default stance.

Key points:

- Built-in ad and tracker blocking.
- Fingerprinting protections and script blocking.
- Tor integration for private windows (but not a full Tor Browser replacement).

Considerations:

- Still based on the Chromium ecosystem (feature churn, large codebase).
- Sync, rewards, and other “extras” should be reviewed and disabled if you do not need them.
- You should periodically review `brave://settings/security` and `brave://settings/shields` instead of assuming defaults are optimal.

Use Brave when:

- You want a hardened daily driver with strong tracker blocking.
- You are okay with Chromium as a base and will routinely audit settings and extensions.

---

### 1.2 Safari

Apple’s native browser on macOS.

Key points:

- Deep OS integration, good power and memory characteristics on macOS.
- Intelligent Tracking Prevention (ITP) to reduce cross-site tracking.
- Benefits from Apple’s platform-level sandboxing and security updates.

Considerations:

- Limited extension ecosystem compared to Chromium/Firefox.
- iCloud integration and cross-device sync are powerful but come with data aggregation implications.
- Heavily tied to Apple’s privacy and security decisions; you gain simplicity but lose flexibility.

Use Safari when:

- You want something stable, well-integrated with macOS, and you are already invested in Apple’s ecosystem.
- You pair it with hardened system-level controls (firewall, DNS, VPN) and keep WebKit patched.

---

### 1.3 Tor Browser

Firefox ESR-based browser routed over the Tor network.

Key points:

- Best-in-class for resisting network-level tracking and correlation when used properly.
- Standardized browser fingerprint among other Tor Browser users, if you respect defaults.
- Multi-hop design (guard → middle → exit) makes targeted correlation harder, but not impossible for a well-resourced adversary.

Considerations:

- High latency and bandwidth constraints.
- Some sites will break or block Tor traffic entirely.
- Misconfiguring Tor Browser (changing fonts, installing extensions, resizing window arbitrarily) erodes fingerprinting protections.
- Tor hides your IP from the destination but does not magically clean your operational security. Anything you voluntarily log into identifies you.

Use Tor Browser when:

- You need strong network-level anonymity for specific tasks.
- You are willing to accept degraded UX in exchange for more resistance to tracking and correlation.
- You keep high-risk activities logically and operationally separate from your real identity.

---

### 1.4 Mullvad Browser

A privacy-focused browser developed with the Tor Project, but designed to be used with or without Mullvad VPN.

Key points:

- Uses Tor Browser’s hardening approach, but without routing traffic over the Tor network by default.
- Aims to normalize fingerprinting among its user base (similar concept to Tor Browser).
- Pairs well with a VPN to reduce network-level exposure while still having strong anti-fingerprinting behavior.

Considerations:

- If you deviate heavily from the defaults, you lose the “blend into the crowd” aspect.
- Smaller user base than mainstream browsers, so anonymity set is smaller.
- Works best when you commit to using it for specific high-risk activities, rather than mixing everything into one profile.

Use Mullvad Browser when:

- You want Tor-style browser hardening without using the Tor network.
- You typically run traffic through a VPN and want to reduce fingerprint uniqueness at the browser layer.

---

## 2. VPNs

A VPN does not make you anonymous. It simply moves trust from your ISP and local network to the VPN provider and potentially changes legal jurisdiction. That trade-off needs to be explicit, not assumed.

### 2.1 Proton VPN

Operated by the Proton team (Proton Mail, etc.), based in Switzerland.

Key points:

- Strong focus on privacy, with a history of targeting high-risk users.
- Supports Secure Core (multi-hop through hardened Proton-controlled servers) on some plans.
- OpenVPN and WireGuard support, with open-source clients on major platforms.
- Based in a jurisdiction with relatively strong privacy protections.

Considerations:

- You are still trusting Proton’s infrastructure, policies, and logging practices.
- Secure Core introduces extra latency; use it only when it matches your threat model.
- Free tier exists but with limited locations and performance.

Use Proton VPN when:

- You want a balance of usability, performance, and privacy.
- You are already using other Proton services and are comfortable with that trust relationship.

---

### 2.2 NordVPN

Large commercial VPN provider with a broad server network.

Key points:

- Wide location coverage and generally high speeds.
- Supports modern protocols (WireGuard-based NordLynx).
- RAM-only server claims and independent audits in recent years.

Considerations:

- Marketing-heavy ecosystem; ignore the hype and read the actual audit reports and policies.
- Large user base and heavy brand presence make it a bigger target for potential attempts at compromise.
- You should explicitly review their privacy policy and logging claims on a regular basis, not assume they never change.

Use NordVPN when:

- You need a wide geographic footprint and speed.
- You are comfortable with a mainstream provider and rely on its audits and legal posture as part of your risk calculation.

---

### 2.3 Mullvad VPN

Flat-fee VPN with a strong emphasis on minimal data retention.

Key points:

- Account system is token-based (numeric account ID), without requiring email by default.
- Encourages anonymous payment options.
- Publicly documented no-logs posture and open-source apps.
- Based in Sweden, with publicly discussed considerations around legal requests.

Considerations:

- Fewer marketing bells and whistles; you are expected to understand what you’re doing.
- Server network is smaller than some competitors, but generally good coverage for privacy-focused use.
- You should still treat the provider as a potential observation point and behave accordingly.

Use Mullvad VPN when:

- You care more about minimizing identifiable data than having a giant server list.
- You are comfortable with a more technical, less “consumerized” experience.

---

## 3. How to actually combine these on macOS

Some practical, opinionated patterns:

- Daily-driver hardened profile:
  - Browser: Brave or Safari with strict settings.
  - VPN: Proton or Mullvad, always on.
  - Extra: DNS encrypted (dnscrypt-proxy or similar) and filtered by your rules, not just the VPN.

- High-risk / investigative profile:
  - Browser: Tor Browser or Mullvad Browser.
  - Network: Mullvad or Proton VPN as base layer, or Tor alone if you know what you’re doing.
  - Extra: Dedicated macOS user profile or VM, separate from your identity-linked workflows.

- Corporate / mixed-use profile:
  - Browser: Safari or Brave with clearly separated profiles (work vs personal).
  - VPN: Depends on corporate requirements; you may be forced onto an enterprise VPN. Use a personal VPN only when it does not violate policy and does not conflict with split tunneling rules.

Non-negotiables regardless of stack:

- Assume your VPN provider **can** see metadata at minimum.
- Never use the same browser profile for sensitive research and real-identity logins.
- Regularly verify:
  - What IP the world sees.
  - Which DNS resolvers you are actually using.
  - That your VPN and browser are updated.

The goal is not to find the “perfect” browser or VPN. The goal is to ensure your tooling and configuration match your threat model, and you understand exactly what problem each component is solving – and what it is **not** solving.
