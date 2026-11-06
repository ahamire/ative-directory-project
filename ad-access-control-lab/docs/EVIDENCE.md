# Evidence gallery

Fourteen unique images from sixteen supplied attachments. Duplicate pairs were verified by SHA-256. Images were copied without editing.

## 1. 01-domain-membership.png

Original: QZQlUi8.png

Domain membership query shows PC-01 in corp.example.test; earlier runas attempts show errors 1326 and 1907.

![Domain membership query shows PC-01 in corp.example.test; earlier runas attempts show errors 1326 and 1907.](../evidence/01-domain-membership.png)

## 2. 02-department-ous.png

Original: eSQd1iw.png

ADUC shows Departments with Finance, HR and IT OUs, and HR Test as a user display name.

![ADUC shows Departments with Finance, HR and IT OUs, and HR Test as a user display name.](../evidence/02-department-ous.png)

## 3. 03-it-user-token.png

Original: eamoyZR.png

T.user identity and token show CORP\GG_IT_Users; includes the corrected whoami /groups command.

![T.user identity and token show CORP\GG_IT_Users; includes the corrected whoami /groups command.](../evidence/03-it-user-token.png)

## 4. 04-it-share-permissions.png

Original: VLQBmSE.png

IT group share permissions: Change and Read checked; Full Control unchecked.

![IT group share permissions: Change and Read checked; Full Control unchecked.](../evidence/04-it-share-permissions.png)

## 5. 05-admin-share-permissions.png

Original: KF8yAkD.png

Domain Admins share permissions: Full Control, Change and Read checked.

![Domain Admins share permissions: Full Control, Change and Read checked.](../evidence/05-admin-share-permissions.png)

## 6. 06-it-ntfs-permissions.png

Original: 6ZbsQzU.png

IT group NTFS permissions include Modify; full ACL and scope are not visible.

![IT group NTFS permissions include Modify; full ACL and scope are not visible.](../evidence/06-it-ntfs-permissions.png)

## 7. 07-inherited-ntfs-entries.png

Original: 7hVCKVf.png

Administrators entry shows grey permission checks; Users and vboxuser entries also appear. Inspect inheritance.

![Administrators entry shows grey permission checks; Users and vboxuser entries also appear. Inspect inheritance.](../evidence/07-inherited-ntfs-entries.png)

## 8. 08-empty-share.png

Original: 5wVnkbB.png

IT folder before the test: empty and marked shared.

![IT folder before the test: empty and marked shared.](../evidence/08-empty-share.png)

## 9. 09-it-create-read.png

Original: 5MErBYc.png

IT session lists the share, writes test.txt and reads Access test.

![IT session lists the share, writes test.txt and reads Access test.](../evidence/09-it-create-read.png)

## 10. 10-file-on-server.png

Original: JM9bBbT.png

Server-side view shows test.txt and its Access test content.

![Server-side view shows test.txt and its Access test content.](../evidence/10-file-on-server.png)

## 11. 11-it-delete.png

Original: JT4V2Pa.png

IT session deletes the file and lists an empty directory; a repeated delete reports file not found.

![IT session deletes the file and lists an empty directory; a repeated delete reports file not found.](../evidence/11-it-delete.png)

## 12. 12-hr-denied.png

Original: l2La1Fj.png

CORP\HR identity and Access is denied for the IT UNC listing appear together.

![CORP\HR identity and Access is denied for the IT UNC listing appear together.](../evidence/12-hr-denied.png)

## 13. 13-logon-gpo.png

Original: HeIRBJ6.png

GPMC shows title AD Lab and text Authorized lab users only for the logon notice.

![GPMC shows title AD Lab and text Authorized lab users only for the logon notice.](../evidence/13-logon-gpo.png)

## 14. 14-logon-message.png

Original: cL0ZPEj.png

LogonUI shows matching title and text; host identity and applied GPO are not visible.

![LogonUI shows matching title and text; host identity and applied GPO are not visible.](../evidence/14-logon-message.png)

