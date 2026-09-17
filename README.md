# Active Directory Home Lab

A hands-on Active Directory home lab built with Windows Server 2022 and Windows 11 Enterprise using VirtualBox.

The project demonstrates the configuration and administration of a small Windows domain environment, including Active Directory, Group Policy, user and group management, shared resources, access control and PowerShell automation.

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
│   └── Users
│
├── IT
│   └── Users
│
├── Management
    └── Users
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

Configured Desktop Wallpaper for the Management OU. The background.jpg file has been added in the `NETLOGON` shared directory.

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

![Enabled Desktop Wallpaper](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/management-desktop-wallpaper.png)

Applied to:
```
Management OU
```

![Prevent Desktop Change](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/prevent-desktop-change-view.png)

Test by logging in as a member of `Management OU` and checking the set desktop background:

![Desktop Wallpaper](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/desktop-wallpaper.png)

## Shared Folder & Permissions

Group:
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

I mapped network disc for easier access in File Explorer:

![Mapped Network Drive](https://github.com/MateuszZalew/active-directory-home-lab/blob/1524f07bbebf31f12082c5735d4541e48235e750/screenshots/map-share-folder-for-easier-access-in-file-explorer.png)


