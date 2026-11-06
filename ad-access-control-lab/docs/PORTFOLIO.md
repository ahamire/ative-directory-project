# Portfolio summary

## Project description

Built an Active Directory home lab around `corp.example.test`, organized department OUs, and tested group-based access to an IT SMB share. Configured Change/Read share permissions and NTFS Modify permissions for the IT group. Validated file creation, reading and deletion using an IT test identity, and captured an HR account being denied directory access. Configured a Group Policy logon notice and documented authentication and command-syntax troubleshooting.

Use this description only if it accurately reflects your own work. The supplied screenshots substantiate the listed operations; the initial forest deployment, full ACL audit and client-specific GPO application are not fully documented.

## Resume bullets

- Configured and tested department-based access to a Windows SMB share using Active Directory security groups and NTFS permissions.
- Validated allowed file operations for an IT user and denied share access for an HR account, documenting identity tokens and troubleshooting results.

## Interview explanation

“The project separates authentication from authorization. I first confirmed the client belonged to the domain and checked the test user's identity and group token. I then tested actual SMB file operations under the IT account and repeated a negative test under HR. The captured result was successful IT file access and denied HR directory access. My next verification steps are to export the complete ACLs, check inheritance, and capture computer RSoP for the logon-banner policy.”

## Extensions (not yet implemented)

- Separate the domain controller and file server if they currently share a VM.
- Introduce domain-local resource groups and separate read-only / modify access groups.
- Add Finance and HR shares with a cross-department test matrix.
- Collect relevant file-access audit events and document their audit-policy prerequisites.
- Capture DNS-based SMB and authentication evidence.
- Automate provisioning only after the final ACL design and VM topology are confirmed.
