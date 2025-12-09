# 02 – System Identity, Users, and Groups

This section covers:

- System identity (hostnames)
- Enumerating users and groups
- Demoting users from admin

You should know exactly who has elevated access and what the system calls itself on the network.

## 1. System identity (ComputerName, LocalHostName)

Set the “pretty” computer name (what you see in the UI and AirDrop-style dialogs):

```bash
sudo scutil --set ComputerName "My-Hardened-Mac"
````

Set the local hostname (used for Bonjour / .local):

```bash
sudo scutil --set LocalHostName "my-hardened-mac"
```

You can verify:

```bash
scutil --get ComputerName
scutil --get LocalHostName
hostname
```

Use names that do not leak personal info (no real names, company names, or roles).

## 2. Listing groups and users

List local groups:

```bash
sudo dscl . list /Groups
```

List local users:

```bash
sudo dscl . list /Users
```

Many system accounts will exist. Focus on:

* Local human accounts (what you log in as)
* Membership in `admin` and other privileged groups

Get details for a specific user:

```bash
dscl . -read /Users/<username>
```

## 3. GeneratedUID (mapping to group membership)

Each local user has a `GeneratedUID` that may be referenced in group membership.

Get it:

```bash
dscl . -read /Users/<username> GeneratedUID
```

You will see something like:

```text
GeneratedUID: 12345678-ABCD-1234-ABCD-1234567890AB
```

This can appear in group `GroupMembers` attributes.

## 4. Demoting an admin user

If a user should no longer have admin rights, you must remove them from the `admin` group.

There are two ways group membership is expressed:

* `GroupMembership` – by short username
* `GroupMembers` – by `GeneratedUID`

Remove a user by short name:

```bash
sudo dscl . -delete /Groups/admin GroupMembership <username>
```

Remove by `GeneratedUID`:

```bash
sudo dscl . -delete /Groups/admin GroupMembers <GeneratedUID>
```

Always confirm after changes:

```bash
dscl . -read /Groups/admin
id <username>
```

You should **never** demote the last known-good admin account without:

* Having another admin account ready
* Having a tested recovery path (FileVault recovery, external admin, MDM, etc.)

Breaking all admin access will force you into recovery mode or reinstall territory.

## 5. Inventory: who can hurt you

For a hardened system, aim for:

* Exactly one or two admin users you control
* No “mystery” accounts with admin rights
* No lingering test/demo accounts

Document your expected:

* Local users
* Admin users
* Service accounts (if any)

Then treat any deviation as an incident.
