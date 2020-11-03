###### Create Chrome application Teams web shortcut #####

(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/steelweaver/teams/main/microsoft_teams_256x256_WYr_icon.ico' , $home +'\Teams.ico') 

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($home + '\Desktop\Teams Web.lnk')
$Shortcut.TargetPath = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
$shortcut.IconLocation = $home +'\Teams.ico, 0'
$Shortcut.Arguments = '--app=https://teams.microsoft.com/go'
$Shortcut.Save()
