# Active Directory Home Lab

A hands-on Active Directory home lab built with Windows Server 2022 and Windows 11 Enterprise using VirtualBox.

The project demonstrates the configuration and administration of a small Windows domain environment, including Active Directory, Group Policy, user and group management, shared resources, access control and PowerShell automation.

## Lab Architecture

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

Created a security group ManagementShare containing all Management users and one HR user. The group was used to control access to the Management shared folder.

## Group Policy

### Password Policy
* Minimum password length
* Maximum password age






