#Script to create a new AD user with the parameters passed in by the user

#Getting parameters for script from user
param (
    [Parameter(Mandatory=$true)]
    [string]$FirstName,

    [Parameter(Mandatory=$true)]
    [string]$LastName,

    [Parameter(Mandatory=$true)]
    [string]$UserName,

    [Parameter(Mandatory=$true)]
    [string]$OU,

    [Parameter(Mandatory=$true)]
    [string]$Domain
)

#Generate Random Password
$Password = -join((0x30..0x39)+(0x41..0x5A)+(0x61..0x7A) | Get-Random -Count 12 | ForEach-Object {[char]$_})
Write-Host "Password generated successfully." -ForegroundColor Green

$SecurePassword = ($Password | ConvertTo-SecureString -AsPlainText -Force)

$DomainParts = $Domain.Split('.');
$DomainDN = ($DomainParts | ForEach-Object { "DC=$_" }) -join ',';
$OUDN = "OU=$OU,$DomainDN"

$Credential = Get-Credential;
#Make a call to New-ADUser to create the AD user
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
