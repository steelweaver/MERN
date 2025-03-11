#uninstall teams for all users
Get-AppxPackage *Teams* -AllUsers | Remove-AppxPackage -AllUsers

#install teams for all users
Install-Module -Name MicrosoftTeams -Force -AllowClobber
Connect-MicrosoftTeams
