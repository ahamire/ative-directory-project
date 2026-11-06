# Troubleshooting journal

| Observation in screenshot | Meaning / next check | What is not established |
|---|---|---|
| runas error 1326 | Credentials were rejected; check domain, account spelling, keyboard layout and password | The exact cause was not captured |
| runas error 1907 | Windows reports that the user must change the password before signing in; complete the change through a supported interactive sign-in path | The eventual password-change procedure is not shown |
| Later shell runs as CORP\T.user | A subsequent test session used the intended identity | Which earlier credential correction resolved the issue |
| `whoami groups` fails | Correct syntax is `whoami /groups`; subsequent output succeeds | No domain configuration fault is implied by this typo |
| HR receives Access is denied | Negative access test succeeded for that session | Whether share ACL, NTFS ACL, or both caused denial |
| Deleting test.txt again returns Could Not Find | The file was absent at that point, consistent with prior deletion | It is not an authorization failure |
| GPO settings and matching LogonUI text appear | Configuration and display are consistent | Exact target client and effective GPO provenance need RSoP evidence |

If IT access fails, check current identity and token first, then connectivity, share name/path, complete share ACL, NTFS ACL, and inherited entries. Refresh the sign-in token after group changes. If access unexpectedly succeeds for HR, inspect all group memberships and existing SMB sessions before altering permissions.

If the banner does not appear, verify the computer account's OU, GPO link, security filtering, replication, and computer RSoP. The setting belongs to Computer Configuration.
