$user = "emisupport"
Remove-LocalUser -Name $user

$Password = Read-Host -AsSecureString

New-LocalUser $user -Password $Password -FullName $user -Description "Compte administrateur local pour le dépannage"

Add-LocalGroupMember -Group "Administrators" -Member $user

Add-LocalGroupMember -Group "Administrators" -Member $user
Add-LocalGroupMember -Group "Administrateurs" -Member $user

Set-LocalUser -Name $user -PasswordNeverExpires 1

Get-LocalUser
Get-LocalGroupMember -Group "Administrators"
Get-LocalGroupMember -Group "Administrateurs"

Invoke-WmiMethod -Class win32_process -ComputerName $RemoteComputer -Name create -ArgumentList  "echo %computername%" 
Invoke-WmiMethod -Class win32_process -ComputerName $RemoteComputer -Name create -ArgumentList  "net user UtLocal /Delete"
Invoke-WmiMethod -Class win32_process -ComputerName $RemoteComputer -Name create -ArgumentList  "net user UtLocal Localut$ /ADD /PASSWORDCHG:NO /EXPIRES:never /COMMENT:""Utilisateur Local"""
Invoke-WmiMethod -Class win32_process -ComputerName $RemoteComputer -Name create -ArgumentList  "wmic path Win32_UserAccount WHERE Name='Utlocal' set PasswordExpires=false"
Invoke-WmiMethod -Class win32_process -ComputerName $RemoteComputer -Name create -ArgumentList  "wmic path Win32_UserAccount WHERE Name='Utlocal' set fullname='Utilisateur Local'"
    
$adapters = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement

foreach ($adapter in $adapters)
{
  write-host "found -> " $adapter.AllowComputerToTurnOffDevice 
  $adapter.AllowComputerToTurnOffDevice = 'Disabled'
  write-host "now -> " $adapter.AllowComputerToTurnOffDevice 
  $adapter | Set-NetAdapterPowerManagement
}

Disable-NetAdapterBinding -name "Wi-Fi*" -DisplayName "Juniper Network Service" ; Get-NetAdapterBinding -Name "Wi-Fi*" -DisplayName "Juniper Network Service"
    
