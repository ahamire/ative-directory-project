# Active Directory Lab: Department Access Control

A Windows home lab demonstrating domain membership, department-based access to an SMB share, and a Group Policy logon message.

**Scenario:** IT staff need to create, read, and delete files in a shared IT folder. An HR test account must be unable to access that share. Administrators retain management access.

**Status:** Portfolio documentation based on supplied screenshots. The lab has not been deployed or independently tested as part of preparing this repository. Setup instructions describe how to reproduce the scenario; they are not a record of every original installation step.

## Environment

| Component | Value visible in evidence |
|---|---|
| AD DNS domain | `corp.example.test` |
| NetBIOS domain | `CORP` |
| Domain member | `PC-01` (`PartOfDomain = True`) |
| Server OS | Windows Server 2025 Standard Evaluation |
| SMB endpoint used in tests | `172.16.1.1` |
| Shared folder / UNC | `C:\shares\IT` / `\\172.16.1.1\IT` |
| IT test identity / group | `CORP\T.user` / `CORP\GG_IT_Users` |
| Negative test identity | `CORP\HR` |
| Department OUs | Finance, HR, IT under Departments |
| GPO | `Lab - LogOn message` |

The screenshots do not establish the complete VM inventory, network mask, DNS configuration, file server hostname, or whether AD DS and file services share one VM. The ADUC display name `HR Test` and the tested logon name `HR` are not independently linked by an account-properties screenshot.

## Architecture

```text
corp.example.test (CORP)
  Departments
    Finance
    HR       -> HR test identity
    IT       -> T.user -> GG_IT_Users
  LabComputers (visible in GPMC; verify PC-01 placement)

PC-01 (domain joined) -- SMB --> 172.16.1.1 / IT
                                  C:\shares\IT
                         IT: Change + NTFS Modify
                         HR: access denied in captured test
```

This lab assigns a global group directly to the resource ACLs. A future extension can introduce domain-local resource groups using an accounts → global groups → domain-local groups → permissions pattern.

## Access design

| Principal | SMB share permissions shown | NTFS permissions shown | Interpretation |
|---|---|---|---|
| `GG_IT_Users` | Change, Read | Modify, Read & execute, List, Read, Write | Supports routine file operations without granting Full Control |
| `Domain Admins` | Full Control, Change, Read | Not directly shown for this specific principal | Share-level administrative permission is demonstrated |
| `Administrators` | Not shown as a separate share entry | Full Control (grey checks) | Inherited-looking entry; inspect the full ACL |
| `HR` | No direct allow entry visible | Complete effective rights not captured | Directory listing denied in the test |

Additional NTFS entries include SYSTEM, CREATOR OWNER, vboxuser, and Users. The screenshots show only portions of the ACL. Do not claim that all broad permissions were removed or that HR is blocked by a specific layer without inspecting both complete ACLs. SMB and NTFS permissions both participate in network access authorization; see the [Microsoft access-control overview](https://learn.microsoft.com/windows/security/identity-protection/access-control/access-control).

## Demonstrated results

- PC-01 reports membership in `corp.example.test`.
- The IT user's token contains `CORP\GG_IT_Users`.
- The IT user lists the share, creates `test.txt`, reads `Access test`, and deletes the test file.
- The server-side view shows the same filename and content, corroborating the write.
- `CORP\HR` receives `Access is denied` when listing the IT share.
- GPMC shows the logon-message title and body; a separate LogonUI capture displays matching text. An RSoP report is still needed to connect the display to the intended client and GPO.

## Project contents

- [Build walkthrough](docs/BUILD.md)
- [Evidence gallery and limitations](docs/EVIDENCE.md)
- [Validation checklist](docs/VALIDATION.md)
- [Troubleshooting journal](docs/TROUBLESHOOTING.md)
- [Read-only evidence collector](scripts/Collect-LabEvidence.ps1)
- [Portfolio and interview summary](docs/PORTFOLIO.md)

## Quick start

1. Follow the build walkthrough in an isolated VM lab, or compare it with your existing environment.
2. Inspect the full share and NTFS ACLs on the file server.
3. Re-run the positive and negative tests in fresh sessions for each identity.
4. Capture GPO application on PC-01 and complete the validation checklist.

## References

- [Microsoft: share and NTFS permissions](https://learn.microsoft.com/iis/web-hosting/configuring-servers-in-the-windows-web-platform/configuring-share-and-ntfs-permissions)
- [Microsoft: Get-SmbShareAccess](https://learn.microsoft.com/powershell/module/smbshare/get-smbshareaccess)
- [Microsoft: Get-Acl](https://learn.microsoft.com/powershell/module/microsoft.powershell.security/get-acl)
- [Microsoft: interactive logon message text](https://learn.microsoft.com/previous-versions/windows/it-pro/windows-10/security/threat-protection/security-policy-settings/interactive-logon-message-text-for-users-attempting-to-log-on)
- [Microsoft: gpresult](https://learn.microsoft.com/windows-server/administration/windows-commands/gpresult)

Screenshots are user-supplied lab evidence. Duplicate attachments were omitted; original filenames are mapped in the evidence gallery. No passwords are included.
