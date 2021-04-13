cls

do{
$Process = Get-Process teams -ErrorAction SilentlyContinue 
 if ($Process) { 
 write-host killing $process
  Sleep 1
    if (!$Process.HasExited) { 
         $Process | Stop-Process -Force 
         TASKKILL /F /IM teams.exe
         Sleep 1
                  }
                   } 
                    Remove-Variable Process 
}while( $Process)

write-host killed $process

stop-job -Name dlteams
remove-job -Name dlteams
$teamsexe = ($home + '\downloads\Teams_windows_x64.exe')

<# 
    Try {
        write-host Uninstall Microsoft Teams for all users
        if (Test-Path “$ENV:SystemDrive\Users\$ENV:username\AppData\Local\Microsoft\Teams\Update.exe”) {
            Start-Process -FilePath “$ENV:SystemDrive\Users\$ENV:username\AppData\Local\Microsoft\Teams\Update.exe” -Arg “-uninstall -s” -Wait
        }
    } Catch {
        Out-Null
    }
#>

    Try {
        write-host  Remove Microsoft Teams desktop icon
        if (Test-Path “$ENV:SystemDrive\Users\$ENV:username\Desktop\Microsoft Teams.lnk”) {
            Remove-Item –Path “$ENV:SystemDrive\Users\$ENV:username\Desktop\Microsoft Teams.lnk” -Force -ErrorAction Ignore
        }
    } Catch {
        Out-Null
    }

    Try {
        write-host  Remove Microsoft Teams from Start Menu
        if (Test-Path “$ENV:SystemDrive\Users\$ENV:username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Corporation\Microsoft Teams.lnk”) {
            Remove-Item –Path “$ENV:SystemDrive\Users\$ENV:username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Corporation\Microsoft Teams.lnk” -Force -ErrorAction Ignore
        }
    } Catch {
        Out-Null
    }

    Try {
        write-host  Remove Teams folder from %localappdata% folder for all users
        if (Test-Path “$ENV:SystemDrive\Users\$ENV:username\AppData\Local\Microsoft\Teams\”) {
            Remove-Item –Path “$ENV:SystemDrive\Users\$ENV:username\AppData\Local\Microsoft\Teams\” -Recurse -Force -ErrorAction Ignore
        }
    } Catch {
        Out-Null
    }

Remove-Item –path $env:APPDATA”\Microsoft\teams\application cache\cache\*” -recurse -force
Remove-Item –path $env:APPDATA”\Microsoft\teams\blob_storage\*” -recurse -force
Remove-Item –path $env:APPDATA”\Microsoft\teams\databases\*” -recurse -force
Remove-Item –path $env:APPDATA”\Microsoft\teams\GPUcache\*” -recurse -force
Remove-Item –path $env:APPDATA”\Microsoft\teams\IndexedDB\*” -recurse -force
Remove-Item –path $env:APPDATA”\Microsoft\teams\Local Storage\*” -recurse -force
Remove-Item –path $env:APPDATA”\Microsoft\teams\tmp\*” -recurse -force
Remove-Item –path $env:APPDATA”\Microsoft\teams\Cache\*” -recurse -force
Remove-Item –path $env:APPDATA”\Microsoft\teams\backgrounds\*” -recurse -force
remove-item -path $env:APPDATA”\Microsoft\teams\backgrounds\*” -recurse -force

start-job -Name dlteams -ScriptBlock { 
    $teamsexe = ($home + '\downloads\Teams_windows_x64.exe')

    if ( -Not (test-path ($teamsexe)))
    {
        write-host dl teams
        $url = 'https://go.microsoft.com/fwlink/p/?LinkID=869426&clcid=0x1009&culture=en-ca&country=CA&lm=deeplink&lmsrc=groupChatMarketingPageWeb&cmpid=directDownloadWin64'
        (New-Object System.Net.WebClient).DownloadFile($url  , $teamsexe )
    }
}

<#
$dldest = ($home + '\downloads\myuninst.zip')
$unzipdest = ($home + '\downloads\myuninst\')

if ( -Not (test-path ($unzipdest)))
{
    $url = 'https://www.nirsoft.net/utils/myuninst.zip'
    (New-Object System.Net.WebClient).DownloadFile( $url ,$dldest)
    Expand-Archive -Path $dldest -DestinationPath $unzipdest
}
Start-Process ($unzipdest + 'myuninst.exe') -ArgumentList '/uninstall "Microsoft Teams"'
#>


$time = 0
do{
    Write-Host wait for $teamsexe to exist $time sec elapsed
                $time++
                sleep -Seconds 1
}while( -Not (test-path ($teamsexe)))

do{
            Write-Host((Get-Item $teamsexe).length/1MB) MB
            $time++
            sleep -Seconds 1
            write-host wait for dlteams to finish $time sec elapsed               
}while((Get-job -Name dlteams | where state -eq Running) -and ($Time -lt 120))

(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/steelweaver/MERN/main/microsoft_teams_256x256_WYr_icon.ico' , $home +'\Teams.ico') 

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($home + '\Desktop\2b - Teams Web.lnk')
$Shortcut.TargetPath = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
$shortcut.IconLocation = $home +'\Teams.ico, 0'
$Shortcut.Arguments = '--app=https://teams.microsoft.com/go'
$Shortcut.Save()

(New-Object System.Net.WebClient).DownloadFile('https://github.com/steelweaver/MERN/raw/main/teams_utiliser_autre_compte.jpg' , $home + '\downloads\teams_utiliser_autre_compte.jpg') 
Start-Process ($home + '\downloads\teams_utiliser_autre_compte.jpg')


write-host wait for DL to finish
Get-Job  -Name dlteams | Wait-Job


Start-Process ($home + '\downloads\Teams_windows_x64.exe')
write-host Starting teams install

$currentdomain = (Get-DnsClientGlobalSetting).SuffixSearchList|Out-String


if (  $currentdomain -notmatch "mrn.gouv" -and $currentdomain -notmatch "foncierqc")
{
    write-host VPN not connected $currentdomain

    if (test-path "C:\Program Files (x86)\Common Files\Pulse Secure\JamUI\Pulse.exe")
    {
        Start-Process "C:\Program Files (x86)\Common Files\Pulse Secure\JamUI\Pulse.exe" -ArgumentList '-show'
    }
    else
    {
        start-process "https://acces.mrn.gouv.qc.ca/dana/home/index.cgi"
    }
}
