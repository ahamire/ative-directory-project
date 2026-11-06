# Reproduce the lab

These are proposed reproduction steps, not proof of how the original machines were provisioned. Commands are examples for your lab; nothing here has been run against your domain.

## 1. Prepare the machines

Use an isolated virtual network with a Windows Server domain controller providing AD DS and DNS, a Windows domain-capable client, and a Windows file server. For a small lab the file server may share the DC VM; a separate member file server is a useful extension. Use appropriately licensed or evaluation media.

Choose an unused private subnet containing `172.16.1.1` if retaining the screenshot addressing. Set the server's static IP, subnet mask, and routing to match your virtual network. Configure domain members to use the AD DNS server. Record the actual values rather than assuming a `/24` mask from the screenshots.

Create the forest `corp.example.test` with NetBIOS name `CORP`, using Server Manager's AD DS deployment wizard. Keep recovery credentials outside the repository. Join the client to the domain, rename it `PC-01`, restart, and verify:

```powershell
Get-CimInstance Win32_ComputerSystem | Select-Object Name, Domain, PartOfDomain
```

Expected: PC-01, corp.example.test, True.

## 2. Organize identities

In Active Directory Users and Computers:

1. Create `Departments` with child OUs `Finance`, `HR`, and `IT`.
2. Create a global security group `GG_IT_Users` and an IT user with logon name `T.user`.
3. Add `T.user` to `GG_IT_Users`.
4. Create an HR test user with logon name `HR`, outside `GG_IT_Users`. Record its display name to resolve the `HR Test` / `HR` evidence gap.
5. Give each test user its own password. Complete any required first-logon password change interactively.
6. Create `LabComputers` and move PC-01 there if targeting the banner GPO to that OU. Keep domain controllers in their appropriate OU.

Use ordinary test users for access checks; do not add them to administrator groups. Sign in again after changing group memberships so the test token is refreshed.

## 3. Configure the IT share

On the file server, create `C:\shares\IT`. Share it as `IT` through Advanced Sharing.

Set share permissions to `CORP\GG_IT_Users`: Change and Read, and `CORP\Domain Admins`: Full Control. Review any other share entries.

On the Security tab, grant `GG_IT_Users` Modify for this folder, subfolders, and files. Preserve the required SYSTEM and administrative management access. Inspect Advanced Security for inherited entries, their scope, and broad groups before changing anything. If inheritance needs adjustment, review the resulting ACL before applying it; the supplied screenshots do not establish a clean final baseline.

Do not add an explicit Deny for HR merely to make the negative test pass. Configure the intended allow permissions, inspect other group memberships, and validate effective access.

Capture complete configuration:

```powershell
Get-SmbShare -Name IT | Select-Object Name, Path
Get-SmbShareAccess -Name IT
(Get-Acl -LiteralPath C:\shares\IT).Access |
    Format-Table IdentityReference, FileSystemRights, AccessControlType, IsInherited, InheritanceFlags, PropagationFlags -AutoSize
```

## 4. Test both identities

From PC-01, open a fresh shell:

```cmd
runas /user:CORP\T.user cmd
```

In the NEW window, verify `whoami` and `whoami /groups`. Use the exact slash in `/groups`. Confirm the expected group before testing access. For reproducible tests, use a unique filename and PowerShell's `New-Item` without `-Force` to avoid replacing a file:

```powershell
$testPath = '\\172.16.1.1\IT\lab-check-' + [guid]::NewGuid().ToString('N') + '.txt'
Get-ChildItem -LiteralPath '\\172.16.1.1\IT' -ErrorAction Stop
New-Item -Path $testPath -ItemType File -Value 'Access test' -ErrorAction Stop
Get-Content -LiteralPath $testPath -ErrorAction Stop
Remove-Item -LiteralPath $testPath -ErrorAction Stop
Test-Path -LiteralPath $testPath
```

Expected: file creation and read succeed; final result is False after deletion. Delete only the uniquely named file created by this test.

Close that session. Open `runas /user:CORP\HR cmd`, verify `whoami`, then run:

```cmd
dir \\172.16.1.1\IT
```

Expected: Access is denied. Record the identity and result together. Use separate sign-in sessions if existing SMB credentials interfere. The IP-based UNC matches the original test, but does not demonstrate Kerberos. Repeat using the verified file-server DNS name if testing name resolution and Kerberos is part of your extension.

## 5. Configure the banner

In Group Policy Management, create `Lab - LogOn message` and link it to the OU containing the target computer accounts. Edit:

`Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Security Options`

Set:

- Interactive logon: Message title for users attempting to log on: `AD Lab`
- Interactive logon: Message text for users attempting to log on: `Authorized lab users only`

On PC-01, run `gpupdate /force`, then capture an elevated `gpresult /scope computer /r` and optionally `gpresult /h .\gpresult.html`. Confirm the GPO appears as applied. Sign out and capture the message before sign-in. A banner communicates a notice; it does not enforce share authorization.
