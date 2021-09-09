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
