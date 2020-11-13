cls


##### DL tools #####
start-job -scriptblock { $dest = ($home + '\downloads\SetDefaultBrowser.exe')
                                if ( -Not (test-path ($dest))) { $url = 'https://raw.githubusercontent.com/steelweaver/MERN/main/SetDefaultBrowser.exe'
                                (New-Object System.Net.WebClient).DownloadFile( $url ,$dest)}
                        }

start-job -scriptblock { $dest = ($home + '\downloads\wifiinfoview.zip')
                                if ( -Not (test-path ($dest))) { $url = 'https://www.nirsoft.net/utils/wifiinfoview.zip'
                                (New-Object System.Net.WebClient).DownloadFile( $url ,$dest)}
                        }

start-job -scriptblock { $dest = ($home + '\downloads\AnyDesk.exe')
                                if ( -Not (test-path ($dest))) { $url = 'https://download.anydesk.com/AnyDesk.exe'
                                (New-Object System.Net.WebClient).DownloadFile( $url ,$dest)}
                        }
##### Create Chrome application Teams web shortcut #####
if ( -Not (test-path ($home + '\AppData\Local\Microsoft\Teams\Update.exe')))
{
    write-host "<<<<<<<<<<<<<<<<< Teams application not installed >>>>>>>>>>>>>>>>>>>>>"

    start-job -scriptblock { 
                            $dest = ($home + '\Desktop\Teams_windows_x64.exe')
                            if ( -Not (test-path ($dest)))
                            {$url = 'https://go.microsoft.com/fwlink/p/?LinkID=869426&clcid=0x1009&culture=en-ca&country=CA&lm=deeplink&lmsrc=groupChatMarketingPageWeb&cmpid=directDownloadWin64'
                            (New-Object System.Net.WebClient).DownloadFile($url  , $dest ) }
                            }
}

if  (-not (Test-Path ($home + '\Documents\Default.rdp') -PathType leaf) )
{ 
    start-job -scriptblock { "mstsc.exe" }
}

##### pulse secure #####
if ( -Not (test-path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pulse Secure\Pulse Secure.lnk' ))
{
write-host "<<<<<<<<<<<<<<<<< pulse secure not found >>>>>>>>>>>>>>>>>>>>>"
    start-process "https://transfert.mern.gouv.qc.ca/?ShareToken=9EAE9D3F2FE8FB3C6CD469E6B63D91D50438AF34"
}
else
{
    #$pattern = "76088BB30763421896DD3EDCB8C641DC"
    $pattern = "641DC"
    #$pattern = "B610"
    if (Select-String -Path "C:\ProgramData\Pulse Secure\ConnectionStore\connstore.dat" -Pattern $pattern -SimpleMatch -Quiet)
    {
        write-host "<<<<<<<<<<<<<<<<< pulse secure 641DC >>>>>>>>>>>>>>>>>>>>>"
        new-item ($home + '\Desktop\$pattern.txt')
        start-process "https://transfert.mern.gouv.qc.ca/?ShareToken=9EAE9D3F2FE8FB3C6CD469E6B63D91D50438AF34"
    }
}

$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut($home +'\Desktop\Pulse_Secure.lnk') ;  $Shortcut.TargetPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pulse Secure\Pulse Secure.lnk' ; $Shortcut.Save()

###### teams web ######
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/steelweaver/MERN/main/microsoft_teams_256x256_WYr_icon.ico' , $home +'\Teams.ico') 

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($home + '\Desktop\Teams Web.lnk')
$Shortcut.TargetPath = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
$shortcut.IconLocation = $home +'\Teams.ico, 0'
$Shortcut.Arguments = '--app=https://teams.microsoft.com/go'
$Shortcut.Save()

##### Network Connect ######
$s=(New-Object -COM WScript.Shell).CreateShortcut($home +'\Desktop\Network Connect.url');$s.TargetPath='https://acces.mrn.gouv.qc.ca/dana/home/index.cgi';$s.Save()

##### RDP web #####
$rdpID = "Connexion_a_distance"

if (  (test-path ($home + '\AppData\Local\Microsoft\Teams\Update.exe')))
{
    Get-Content  ($home + '\Documents\Default.rdp') | Where-Object {$_ -match 'full address:'} | ForEach-Object { $rdpID = $_ } 
    if ($rdpID.length -ge 6) 
    {
        $rdpID = ($rdpID -replace '.*:','').ToUpper()
        $filesource = ($home + '\Documents\Default.rdp')
        copy-item ($home + '\Documents\Default.rdp') -Destination ($home + '\Desktop\' + $rdpID+ '.rdp') -Force -verbose -passthru
        Set-ItemProperty -Path ($home + '\Desktop\' + $rdpID+ '.rdp')  -Name Attributes -Value Normal
    }
}
else {
    new-item ($home + '\Desktop\Connexion_a_distance.rdp')
}

write-host $rdpID 
$s=(New-Object -COM WScript.Shell).CreateShortcut($home +'\Desktop\' + $rdpID+ '.url');$s.TargetPath='https://acces.mrn.gouv.qc.ca/dana/home/index.cgi';$s.Save()

ie4uinit.exe -show

Write-Host 'Computername ' + $env:COMPUTERNAME
Write-Host 'Username ' + $env:USERNAME
wmic bios get serialnumber,manufacturer
wmic os get BuildNumber

(New-Object System.Net.WebClient).DownloadFile('https://acces.mrn.gouv.qc.ca/dana-cached/psal/PulseSecureAppLauncher.msi' , $home +'\downloads\PulseSecureAppLauncher.msi') 
$cmd = ($home + '\downloads\SetDefaultBrowser.exe chrome')
Start-Process 'cmd' -ArgumentList "/c $cmd"

$cred = Get-Credential -UserName 'EMISUPPORT' -Message ' '

$scriptblock = {     
        Get-NetAdapterBinding -Name 'Wi-Fi*' -DisplayName 'Juniper Network Service' 
        Disable-NetAdapterBinding -name 'Wi-Fi*' -DisplayName 'Juniper Network Service' 
        Get-NetAdapterBinding -Name 'Wi-Fi*' -DisplayName 'Juniper Network Service'
        whoami
        }

$encoded = [convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptblock))

Start-Process 'cmd' -Credential $cred -ArgumentList "/k powershell.exe -NoProfile -EncodedCommand $encoded"

msiexec.exe  /i  ($home +'\downloads\PulseSecureAppLauncher.msi') /qn
