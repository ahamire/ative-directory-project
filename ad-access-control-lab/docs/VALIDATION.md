# Validation checklist

Observed means visible in supplied screenshots, not independently re-run.

| Check | Existing evidence | Remaining action |
|---|---|---|
| PC-01 is domain joined | Observed | Re-run membership query |
| Department OUs exist | Observed | Record account properties and actual OU placement |
| T.user token includes IT group | Observed | Capture fresh token after membership changes |
| IT share grants Change/Read | Observed | Export complete share ACL |
| IT group has NTFS Modify | Observed | Export full ACL, inheritance and scope |
| IT user creates and reads a file | Observed | Re-run with unique filename |
| IT user deletes the file | Observed | Verify absence of the new test file |
| HR cannot list the IT share | Observed | Repeat in a fresh verified HR session |
| HR cannot create a file | Not shown | Attempt a unique test file; record denial; remove only that file if unexpectedly created |
| Admin can manage permissions | Configuration partly shown | Test with a designated lab admin account |
| Banner settings exist in GPO | Observed | Export GPO report and scope |
| Banner is applied to PC-01 | Matching display only | Capture computer RSoP and identifiable client sign-in screen |
| Kerberos used for SMB | Not shown | Test DNS-based UNC and inspect tickets if required |

## Acceptance criteria

The lab is fully reproduced when the positive file tests succeed for the IT account, the HR listing and write tests fail, complete ACLs match the intended design, and PC-01's computer policy report identifies the applied banner GPO.

## Evidence collector

Run in Windows PowerShell on each relevant machine. Client mode records domain membership, current identity/groups and computer RSoP. FileServer mode adds the share and NTFS ACL. Run FileServer mode locally on the file server with appropriate administrative rights.

```powershell
.\scripts\Collect-LabEvidence.ps1 -Role Client -OutputDirectory .\collected-client
.\scripts\Collect-LabEvidence.ps1 -Role FileServer -OutputDirectory .\collected-server
```

The collector queries configuration and writes new report files only. It does not perform SMB write tests, change permissions, configure AD, or apply policy. Review warnings: a failed query is not proof of a correctly configured control. Reports can contain account names, SIDs and infrastructure details; review them before publishing.
