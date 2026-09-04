# 🎫 Helpdesk Ticketing System + IT Automation Toolkit

Two connected IT support projects: a working helpdesk ticketing system with
realistic logged and resolved tickets, and a small toolkit of PowerShell
scripts automating common sysadmin tasks against a real Active Directory
environment.

![osTicket](https://img.shields.io/badge/osTicket-Helpdesk-F47421?style=flat-square)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-5391FE?style=flat-square&logo=powershell&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active%20Directory-Windows%20Server-0078D4?style=flat-square&logo=windows&logoColor=white)
![XAMPP](https://img.shields.io/badge/Stack-Apache%20%7C%20MySQL%20%7C%20PHP-FB7A24?style=flat-square)


## Table of Contents

- [Part 1: Helpdesk Ticketing System](#part-1-helpdesk-ticketing-system-osticket)
- [Part 2: IT Automation Toolkit](#part-2-it-automation-toolkit)
- [Skills Demonstrated](#-skills-demonstrated)

---

## Part 1: Helpdesk Ticketing System (osTicket)

<img width="778" height="544" alt="image" src="https://github.com/user-attachments/assets/17ea37fc-c4cf-46e7-9a0b-20dc5c2b6215" />

### 🛠️ What I built

- Installed osTicket on a Windows 11 client using a local Apache/MySQL/PHP
  stack (XAMPP), running entirely on `localhost` with no external
  dependencies.
- Set up a separate **agent account** distinct from the admin account, to
  reflect a realistic support-agent workflow rather than everything running
  under one login.
- Created three help topic categories — **Hardware**, **Software**, and
  **Network/Access** — each with realistic priority levels assigned per
  ticket.
- Logged **8 tickets** through the actual customer-facing portal using
  distinct fake customer identities, covering common real-world IT support
  issues: email sync failures, printer problems, VPN connectivity, an
  account lockout, a slow laptop, a software install request, a missing
  shared drive, and a reported phishing email.
- Resolved each ticket from the agent side with a real acknowledgment,
  documented troubleshooting steps, and a clear resolution summary — not
  just a status change.
- Added a knowledge base article to demonstrate reducing future ticket
  volume through self-service documentation, not just reactive support.

<img width="1021" height="720" alt="image" src="https://github.com/user-attachments/assets/296cd787-0055-4bf0-a5c6-32d744e1c414" />

<img width="779" height="482" alt="image" src="https://github.com/user-attachments/assets/c072eb0b-6f27-4acc-bd79-214f1d0f8aed" />



### 🐛 Troubleshooting log

<details>
<summary><b>Docker wasn't a good fit for this environment</b></summary>
<br>

The client itself is a VM, and running Docker Desktop inside it would need
nested virtualization enabled on the host. Switched to XAMPP (a native
Windows Apache/MySQL/PHP stack) instead, avoiding that complexity entirely.
</details>

<details>
<summary><b>Browser couldn't load anything at all</b></summary>
<br>

Traced to the client's DNS being dependent on the domain controller VM,
which was powered off. Powering the DC back on restored DNS resolution and
downloads — a good reminder that this whole environment depends on the DC
being up.
</details>

<details>
<summary><b>Installer returned a 404 on the first attempt</b></summary>
<br>

</details>

<details>
<summary><b>Installer returned an HTTP 500 error on the database step</b></summary>
<br>

Checked `C:\xampp\apache\logs\error.log` directly and found the real
cause:

```
Access denied for user 'root'@'localhost' (using password: YES)
```

The installer was submitting a password, but XAMPP's default MySQL root
account has none. Re-entering the database step with an empty password
field (matching XAMPP's actual default) resolved it.
</details>

<details>
<summary><b>"Mailer Error" entries appeared in the system logs</b></summary>
<br>

Expected and harmless in this environment — osTicket attempts to send
email notifications, but XAMPP has no configured mail server
(`localhost:25`) to send through. Ticket creation and resolution both
worked correctly regardless; only the notification email itself failed to
send.
</details>

---

## Part 2: IT Automation Toolkit

Four PowerShell scripts addressing common sysadmin tasks, run against the
same Active Directory lab used in the other two projects. Full scripts are
in the [`scripts/`](scripts/) folder.


| Script | Purpose |
|---|---|
| [`Disable-InactiveADAccounts.ps1`](scripts/Disable-InactiveADAccounts.ps1) | Finds and disables AD accounts with no logon activity in 90+ days — closes a real security gap where stale enabled accounts sit unused. |
| [`Get-DiskSpaceReport.ps1`](scripts/Get-DiskSpaceReport.ps1) | Reports free disk space across one or more machines and flags anything critically low. |
| [`Get-PasswordExpiryReport.ps1`](scripts/Get-PasswordExpiryReport.ps1) | Flags users whose passwords will expire within 7 days, to proactively reduce lockout-related support tickets. |
| [`Get-LocalAdminAudit.ps1`](scripts/Get-LocalAdminAudit.ps1) | Lists local Administrators group membership across machines, to catch unexpected privilege escalation. |

---

## ✅ Skills Demonstrated

- Helpdesk ticketing workflow and triage
- Customer-facing support communication
- Active Directory account management
- PowerShell scripting and automation
- Windows / Apache / MySQL stack troubleshooting
- Log-based root cause diagnosis
- Connecting security-monitoring work (AD lockouts, disk health) to
  practical preventive automation
