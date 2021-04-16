
$scriptblock = {  
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

 
    Try {
        write-host Uninstall Microsoft Teams for $ENV:username
        if (Test-Path “$ENV:SystemDrive\Users\$ENV:username\AppData\Local\Microsoft\Teams\Update.exe”) {
            Start-Process -FilePath “$ENV:SystemDrive\Users\$ENV:username\AppData\Local\Microsoft\Teams\Update.exe” -Arg “-uninstall -s” -Wait
        }
    } Catch {
        Out-Null
    }


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


    whoami
      if (-not (Get-AppxPackage Microsoft.AAD.BrokerPlugin)) { Add-AppxPackage -Register "$env:windir\SystemApps\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\Appxmanifest.xml" -DisableDevelopmentMode -ForceApplicationShutdown } Get-AppxPackage Microsoft.AAD.BrokerPlugin

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

}


$encoded = [convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptblock))
$batfile = ($home + '\Desktop\reinstall_teams.bat')
remove-item $batfile

$cmdcode = ('powershell.exe -NoProfile -EncodedCommand '+$encoded)
$cmdcode | Out-File -encoding "ASCII" -filePath $batfile
#Start-Process 'cmd' -ArgumentList "/k powershell.exe -NoProfile -EncodedCommand $encoded"
Start-Process 'cmd' -ArgumentList "/k $batfile"


#powershell.exe -NoProfile -EncodedCommand IAAgAA0ACgBzAHQAbwBwAC0AagBvAGIAIAAtAE4AYQBtAGUAIABkAGwAdABlAGEAbQBzAA0ACgByAGUAbQBvAHYAZQAtAGoAbwBiACAALQBOAGEAbQBlACAAZABsAHQAZQBhAG0AcwANAAoAcwB0AGEAcgB0AC0AagBvAGIAIAAtAE4AYQBtAGUAIABkAGwAdABlAGEAbQBzACAALQBTAGMAcgBpAHAAdABCAGwAbwBjAGsAIAB7ACAADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACQAdABlAGEAbQBzAGUAeABlACAAPQAgACgAJABoAG8AbQBlACAAKwAgACcAXABkAG8AdwBuAGwAbwBhAGQAcwBcAFQAZQBhAG0AcwBfAHcAaQBuAGQAbwB3AHMAXwB4ADYANAAuAGUAeABlACcAKQANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAcgBlAG0AbwB2AGUALQBpAHQAZQBtACAAJAB0AGUAYQBtAHMAZQB4AGUADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAGkAZgAgACgAIAAtAE4AbwB0ACAAKAB0AGUAcwB0AC0AcABhAHQAaAAgACgAJAB0AGUAYQBtAHMAZQB4AGUAKQApACkADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAHsADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAdwByAGkAdABlAC0AaABvAHMAdAAgAGQAbAAgAHQAZQBhAG0AcwANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAkAHUAcgBsACAAPQAgACcAaAB0AHQAcABzADoALwAvAGcAbwAuAG0AaQBjAHIAbwBzAG8AZgB0AC4AYwBvAG0ALwBmAHcAbABpAG4AawAvAHAALwA/AEwAaQBuAGsASQBEAD0AOAA2ADkANAAyADYAJgBjAGwAYwBpAGQAPQAwAHgAMQAwADAAOQAmAGMAdQBsAHQAdQByAGUAPQBlAG4ALQBjAGEAJgBjAG8AdQBuAHQAcgB5AD0AQwBBACYAbABtAD0AZABlAGUAcABsAGkAbgBrACYAbABtAHMAcgBjAD0AZwByAG8AdQBwAEMAaABhAHQATQBhAHIAawBlAHQAaQBuAGcAUABhAGcAZQBXAGUAYgAmAGMAbQBwAGkAZAA9AGQAaQByAGUAYwB0AEQAbwB3AG4AbABvAGEAZABXAGkAbgA2ADQAJwANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAjACgATgBlAHcALQBPAGIAagBlAGMAdAAgAFMAeQBzAHQAZQBtAC4ATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdAApAC4ARABvAHcAbgBsAG8AYQBkAEYAaQBsAGUAKAAkAHUAcgBsACAAIAAsACAAJAB0AGUAYQBtAHMAZQB4AGUAIAApAA0ACgANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAkAHcAYwAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0ACAAIAANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAjAFIAZQBnAGkAcwB0AGUAcgAtAE8AYgBqAGUAYwB0AEUAdgBlAG4AdAAgAC0ASQBuAHAAdQB0AE8AYgBqAGUAYwB0ACAAJAB3AGMAIAAtAEUAdgBlAG4AdABOAGEAbQBlACAARABvAHcAbgBsAG8AYQBkAFAAcgBvAGcAcgBlAHMAcwBDAGgAYQBuAGcAZQBkACAALQBTAG8AdQByAGMAZQBJAGQAZQBuAHQAaQBmAGkAZQByACAAVwBlAGIAQwBsAGkAZQBuAHQALgBEAG8AdwBuAGwAbwBhAGQAUAByAG8AZwByAGUAcwBzAEMAaABhAG4AZwBlAGQAIAAtAEEAYwB0AGkAbwBuACAAewAgAFcAcgBpAHQAZQAtAFAAcgBvAGcAcgBlAHMAcwAgAC0AQQBjAHQAaQB2AGkAdAB5ACAAIgBEAG8AdwBuAGwAbwBhAGQAaQBuAGcAOgAgACQAKAAkAEUAdgBlAG4AdABBAHIAZwBzAC4AUAByAG8AZwByAGUAcwBzAFAAZQByAGMAZQBuAHQAYQBnAGUAKQAlACAAQwBvAG0AcABsAGUAdABlAGQAIgAgAC0AUwB0AGEAdAB1AHMAIAAkAHUAcgBsACAALQBQAGUAcgBjAGUAbgB0AEMAbwBtAHAAbABlAHQAZQAgACQARQB2AGUAbgB0AEEAcgBnAHMALgBQAHIAbwBnAHIAZQBzAHMAUABlAHIAYwBlAG4AdABhAGcAZQA7ACAAfQAgACAAIAAgAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACMAUgBlAGcAaQBzAHQAZQByAC0ATwBiAGoAZQBjAHQARQB2AGUAbgB0ACAALQBJAG4AcAB1AHQATwBiAGoAZQBjAHQAIAAkAHcAYwAgAC0ARQB2AGUAbgB0AE4AYQBtAGUAIABEAG8AdwBuAGwAbwBhAGQARgBpAGwAZQBDAG8AbQBwAGwAZQB0AGUAZAAgAC0AUwBvAHUAcgBjAGUASQBkAGUAbgB0AGkAZgBpAGUAcgAgAFcAZQBiAEMAbABpAGUAbgB0AC4ARABvAHcAbgBsAG8AYQBkAEYAaQBsAGUAQwBvAG0AcABsAGUAdABlACAALQBBAGMAdABpAG8AbgAgAHsAIABXAHIAaQB0AGUALQBIAG8AcwB0ACAAIgBEAG8AdwBuAGwAbwBhAGQAIABDAG8AbQBwAGwAZQB0AGUAIAAtACAAJABmAGkAbABlAG4AYQBtAGUAIgA7ACAAVQBuAHIAZQBnAGkAcwB0AGUAcgAtAEUAdgBlAG4AdAAgAC0AUwBvAHUAcgBjAGUASQBkAGUAbgB0AGkAZgBpAGUAcgAgAFcAZQBiAEMAbABpAGUAbgB0AC4ARABvAHcAbgBsAG8AYQBkAFAAcgBvAGcAcgBlAHMAcwBDAGgAYQBuAGcAZQBkADsAIABVAG4AcgBlAGcAaQBzAHQAZQByAC0ARQB2AGUAbgB0ACAALQBTAG8AdQByAGMAZQBJAGQAZQBuAHQAaQBmAGkAZQByACAAVwBlAGIAQwBsAGkAZQBuAHQALgBEAG8AdwBuAGwAbwBhAGQARgBpAGwAZQBDAG8AbQBwAGwAZQB0AGUAOwAgAH0AIAAgAA0ACgANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAjACQAdwBjAC4ARABvAHcAbgBsAG8AYQBkAEYAaQBsAGUAQQBzAHkAbgBjACgAJAB1AHIAbAAsACAAJAB0AGUAYQBtAHMAZQB4AGUAKQANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAkAHcAYwAuAEQAbwB3AG4AbABvAGEAZABGAGkAbABlACgAJAB1AHIAbAAsACAAJAB0AGUAYQBtAHMAZQB4AGUAKQANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAfQANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAH0ADQAKAA0ACgAkAGQAbABkAGUAcwB0ACAAPQAgACgAJABoAG8AbQBlACAAKwAgACcAXABkAG8AdwBuAGwAbwBhAGQAcwBcAG0AeQB1AG4AaQBuAHMAdAAuAHoAaQBwACcAKQANAAoAJAB1AG4AegBpAHAAZABlAHMAdAAgAD0AIAAoACQAaABvAG0AZQAgACsAIAAnAFwAZABvAHcAbgBsAG8AYQBkAHMAXABtAHkAdQBuAGkAbgBzAHQAXAAnACkADQAKAA0ACgBpAGYAIAAoACAALQBOAG8AdAAgACgAdABlAHMAdAAtAHAAYQB0AGgAIAAoACQAdQBuAHoAaQBwAGQAZQBzAHQAKQApACkADQAKAHsADQAKACAAIAAgACAAJAB1AHIAbAAgAD0AIAAnAGgAdAB0AHAAcwA6AC8ALwB3AHcAdwAuAG4AaQByAHMAbwBmAHQALgBuAGUAdAAvAHUAdABpAGwAcwAvAG0AeQB1AG4AaQBuAHMAdAAuAHoAaQBwACcADQAKACAAIAAgACAAKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0ACkALgBEAG8AdwBuAGwAbwBhAGQARgBpAGwAZQAoACAAJAB1AHIAbAAgACwAJABkAGwAZABlAHMAdAApAA0ACgAgACAAIAAgAEUAeABwAGEAbgBkAC0AQQByAGMAaABpAHYAZQAgAC0AUABhAHQAaAAgACQAZABsAGQAZQBzAHQAIAAtAEQAZQBzAHQAaQBuAGEAdABpAG8AbgBQAGEAdABoACAAJAB1AG4AegBpAHAAZABlAHMAdAANAAoAfQANAAoADQAKACMAUwB0AGEAcgB0AC0AUAByAG8AYwBlAHMAcwAgACQAdQBuAHoAaQBwAGQAZQBzAHQADQAKAA0ACgAkAGMAbQBkACAAPQAgACgAJAB1AG4AegBpAHAAZABlAHMAdAAgACsAIAAnAG0AeQB1AG4AaQBuAHMAdAAuAGUAeABlACAALwB1AG4AaQBuAHMAdABhAGwAbAAgACIATQBpAGMAcgBvAHMAbwBmAHQAIABUAGUAYQBtAHMAIgAnACkADQAKACMAUwB0AGEAcgB0AC0AUAByAG8AYwBlAHMAcwAgACcAYwBtAGQAJwAgAC0AQQByAGcAdQBtAGUAbgB0AEwAaQBzAHQAIAAiAC8AYwAgACQAYwBtAGQAIgANAAoAUwB0AGEAcgB0AC0AUAByAG8AYwBlAHMAcwAgACgAJAB1AG4AegBpAHAAZABlAHMAdAAgACsAIAAnAG0AeQB1AG4AaQBuAHMAdAAuAGUAeABlACcAKQAgAC0AQQByAGcAdQBtAGUAbgB0AEwAaQBzAHQAIAAnAC8AdQBuAGkAbgBzAHQAYQBsAGwAIAAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVABlAGEAbQBzACIAJwANAAoADQAKACQAdABpAG0AZQAgAD0AIAAwAA0ACgBkAG8AewANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAjACQAUgBlAHMAdQBsAHQAIAA9ACAAZwBlAHQALQBqAG8AYgAgAC0ATgBhAG0AZQAgAGQAbAB0AGUAYQBtAHMAIAAgACAAIwB8ACAAdwBoAGUAcgBlACAAcwB0AGEAdABlACAALQBlAHEAIABDAG8AbQBwAGwAZQB0AGUAZAAgAHwAIABSAGUAYwBlAGkAdgBlAC0AagBvAGIADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACMAJABSAGUAcwB1AGwAdAAgACMALgBPAG4AbABpAG4AZQANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAVwByAGkAdABlAC0ASABvAHMAdAAoACgARwBlAHQALQBJAHQAZQBtACAAJAB0AGUAYQBtAHMAZQB4AGUAKQAuAGwAZQBuAGcAdABoAC8AMQBNAEIAKQAgAE0AQgANAAoADQAKAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAkAHQAaQBtAGUAKwArAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIABzAGwAZQBlAHAAIAAtAFMAZQBjAG8AbgBkAHMAIAAxAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAB3AHIAaQB0AGUALQBoAG8AcwB0ACAAdwBhAGkAdAAgAGYAbwByACAAZABsAHQAZQBhAG0AcwAgAHQAbwAgAGYAaQBuAGkAcwBoACAAJAB0AGkAbQBlACAAcwBlAGMAIABlAGwAYQBwAHMAZQBkACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAA0ACgAgAH0ADQAKACAAdwBoAGkAbABlACgAKABHAGUAdAAtAGoAbwBiACAALQBOAGEAbQBlACAAZABsAHQAZQBhAG0AcwAgAHwAIAB3AGgAZQByAGUAIABzAHQAYQB0AGUAIAAtAGUAcQAgAFIAdQBuAG4AaQBuAGcAKQAgAC0AYQBuAGQAIAAoACQAVABpAG0AZQAgAC0AbAB0ACAAMQAyADAAKQApAA0ACgANAAoAdwByAGkAdABlAC0AaABvAHMAdAAgAHcAYQBpAHQAIABmAG8AcgAgAEQATAAgAHQAbwAgAGYAaQBuAGkAcwBoAA0ACgBHAGUAdAAtAEoAbwBiACAAIAAtAE4AYQBtAGUAIABkAGwAdABlAGEAbQBzACAAfAAgAFcAYQBpAHQALQBKAG8AYgANAAoADQAKAA0ACgAkAGMAbQBkACAAPQAgACgAJABoAG8AbQBlACAAKwAgACcAXABkAG8AdwBuAGwAbwBhAGQAcwBcAFQAZQBhAG0AcwBfAHcAaQBuAGQAbwB3AHMAXwB4ADYANAAuAGUAeABlACcAKQANAAoAIwBTAHQAYQByAHQALQBQAHIAbwBjAGUAcwBzACAAJwBjAG0AZAAnACAALQBBAHIAZwB1AG0AZQBuAHQATABpAHMAdAAgACIALwBjACAAJABjAG0AZAAiAA0ACgBTAHQAYQByAHQALQBQAHIAbwBjAGUAcwBzACAAKAAkAGgAbwBtAGUAIAArACAAJwBcAGQAbwB3AG4AbABvAGEAZABzAFwAVABlAGEAbQBzAF8AdwBpAG4AZABvAHcAcwBfAHgANgA0AC4AZQB4AGUAJwApAA0ACgANAAoA
