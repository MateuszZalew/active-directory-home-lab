# Active Directory Home Lab

A hands-on Active Directory home lab built with Windows Server 2022 and Windows 11 Enterprise using VirtualBox.

The project demonstrates the configuration and administration of a small Windows domain environment, including Active Directory, Group Policy, user and group management, shared resources, access control and PowerShell automation.

## Table of Contents

- [Technologies](#technologies)
- [Lab Architecture](#lab-architecture)
- [Active Directory Configuration](#active-directory-configuration)
- [Group Policy](#group-policy)
- [Shared Folder and Permissions](#shared-folder-and-permissions)
- [PowerShell Automation](#powershell-automation)
- [Testing and Troubleshooting](#testing-and-troubleshooting)

## Technologies

- Windows Server 2022
- Windows 11 Enterprise
- Active Directory Domain Services
- Group Policy
- DNS
- PowerShell
- RSAT
- SMB / Windows File Sharing
- VirtualBox

## Lab Architecture

![Lab Architecture](https://github.com/MateuszZalew/active-directory-home-lab/blob/a5fb1d8f2cbe28d86918f36015c677e2cd5ef00c/images/ad-home-lab-architecture.png)

| VM | OS | Hostname | IP | Role |
| --- | --- | --- | --- | --- |
| Server | Windows Server 2022 | PL-DC-01 | 10.0.2.3 | Domain Controller |
| Client | Windows 11 Enterprise | WS01 | 10.0.2.4 | Domain Client |

## Active Directory Configuration

### Domain Controller
* Installed Windows Server 2022
* Installed Active Directory Domain Services
* Promoted server to Domain Controller
* Created `matzal.com` domain
* Configured hostname `PL-DC-01`

### Users & OUs

```
matzal.com
│
├── HR
│   └── Tomasz
│   └── Weronika
│
├── IT
│   └── Mateusz
│   └── Robert
│
├── Management
│   └── Dariusz
│   └── Dominik
```

### Groups

Created a security group `ManagementShare` containing all Management users and one HR user. The group was used to control access to the Management shared folder.

![ManagementShare Group](https://github.com/MateuszZalew/active-directory-home-lab/blob/2cb1d43cdbdc42549702b1abe433ff504647f70d/screenshots/management-share-group.png)

## Group Policy

### Password Policy
* Minimum password length
* Maximum password age

![Default Domain Policy - Password Policy](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/default-domain-policy-password-policies.png)

### Account Lockout Policy
* Account lockout threshold

![Account Lockout Policy](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/account-lockout-threshold-policy.png)

Tested the account lockout policy by intentionally entering an incorrect password three times and verifying that the account was locked.

![Locked account](https://github.com/MateuszZalew/active-directory-home-lab/blob/2cb1d43cdbdc42549702b1abe433ff504647f70d/screenshots/locked_account_3_invalid_logons.png)

### Desktop Background Policy

Configured a desktop wallpaper GPO and linked it to the Management OU. The `management_wallpaper.jpg` file has been added in the `NETLOGON` shared directory.

File:
```
management_wallpaper.jpg
```

![Desktop File](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/management-wallpaper-file.png)

GPOs:
```
SetManagementBackground
PreventChangeBackground
```

![PreventChangeBackground GPO](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/management-prevent-background-change.png)

Wallpaper stored in:
```
\\matzal.com\NETLOGON\management_wallpaper.jpg
```

![Enabled Desktop Wallpaper](https://github.com/MateuszZalew/active-directory-home-lab/blob/3a59b36e44b21d20957ea1c5012d955abc4001d4/screenshots/set-management-background-policy.png)

GPO linked to:
```
Management OU
```

Tested by logging in as a user from the `Management OU` and trying to personalize desktop background, every option is disabled:

![Prevent Desktop Change](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/prevent-desktop-change-view.png)

Tested by logging in as a user from the `Management OU` and checking the desktop background:

![Desktop Wallpaper](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/desktop-wallpaper.png)

## Shared Folder and Permissions

Group with permissions to the shared folder called `ManagementShare`:
```
ManagementShare
```

| User | Group Membership | Access |
| --- | --- | --- |
| Management user | ManagementShare | Allowed |
| HR user | ManagementShare | Allowed |
| Other user | No membership | Denied |

![Shared Folder Permissions](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/shared-folder-permissions.png)

Allowed user:

![Shared Folder View on Domain Client](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/access-shared-folder.png)

Denied user:

![Denied access to shared folder](https://github.com/MateuszZalew/active-directory-home-lab/blob/2cb1d43cdbdc42549702b1abe433ff504647f70d/screenshots/shared_folder_denied_access.png)

I mapped the network drive for easier access in File Explorer:

![Mapped Network Drive](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/map-share-folder-for-easier-access-in-file-explorer.png)

## Remote Server Administration Tools (RSAT)

Installed RSAT Active Directory Domain Services and Lightweight Directory Services Tools on the Windows 11 client. Used PowerShell Active Directory cmdlets from the Windows 11 client to query and manage domain objects.

![RSAT installed on client VM](https://github.com/MateuszZalew/active-directory-home-lab/blob/382f3c25e32c2df82d18217e22f66418a22cd50e/screenshots/rsat-installed-on-client-vm.png)

## PowerShell Automation

Created a PowerShell script to automate the creation of Active Directory users.

The script accepts the following parameters:
```
FirstName
LastName
UserName
OU
Domain
```

It then automatically:
1. Generates a random password
2. Converts it to a secure string
3. Creates the AD user
4. Enables the account
5. Requires password change at first logon

![PowerShell Create AD User Script](https://github.com/MateuszZalew/active-directory-home-lab/blob/8af8ab91b2016f2b9f0ecc9731f72e55cfb179cb/screenshots/power-shell-create-ad-user-script.png)

![Successful user creation](https://github.com/MateuszZalew/active-directory-home-lab/blob/912b1de01b48c574300a3024c7f9b722f2d7083b/screenshots/power-shell-script-success-create-user.png)

Full script is in the repo files, part of the script:

```
New-ADUser `
    -SamAccountName $UserName `
    -UserPrincipalName "$Username@$Domain" `
    -Name "$FirstName $LastName" `
    -GivenName $FirstName `
    -Surname $LastName `
    -AccountPassword $SecurePassword `
    -Enabled $true `
    -Path $OUDN `
    -PasswordNeverExpires $false `
    -ChangePasswordAtLogon $true `
    -Credential $Credential `
    -Server "PL-DC-01.matzal.com"
```

## Testing and Troubleshooting

### Network connectivity
```
ping matzal.com
```

### Domain connectivity
```
nltest /dsgetdc:matzal.com
```

### AD PowerShell
```
whoami
hostname
Get-ADComputer WS01 -Server "PL-DC-01.matzal.com"
Get-ADDomain -Server "PL-DC-01.matzal.com"
Get-ADUser <username> -Properties * | Select-Object Name, SamAccountName, Enabled
```

Testing covered DNS resolution, domain controller discovery, Active Directory PowerShell queries, domain authentication, Group Policy application, account lockout and shared folder access.
