cls


##### DL tools #####
start-job -Name SetDefaultBrowser -scriptblock { $dest = ($home + '\downloads\SetDefaultBrowser.exe')
                                if ( -Not (test-path ($dest))) { $url = 'https://raw.githubusercontent.com/steelweaver/MERN/main/SetDefaultBrowser.exe'
                                (New-Object System.Net.WebClient).DownloadFile( $url ,$dest)}
                        }
start-job -Name RevoUninstallerPortable -scriptblock { $dest = ($home + '\downloads\RevoUninstallerPortable_2.3.5.paf.exe')
                                if ( -Not (test-path ($dest))) { $url = 'https://portableapps.com/redirect/?a=RevoUninstallerPortable&s=s&d=pa&f=RevoUninstallerPortable_2.3.5.paf.exe'
                                (New-Object System.Net.WebClient).DownloadFile( $url ,$dest)}
                        }
			
start-job -Name wifiinfoview -scriptblock { $dest = ($home + '\downloads\wifiinfoview.zip')
                                if ( -Not (test-path ($dest))) { $url = 'https://www.nirsoft.net/utils/wifiinfoview.zip'
                                (New-Object System.Net.WebClient).DownloadFile( $url ,$dest)}
                        }

start-job -Name AnyDesk -scriptblock { $dest = ($home + '\downloads\AnyDesk.exe')
                                if ( -Not (test-path ($dest))) { $url = 'https://download.anydesk.com/AnyDesk.exe'
                                (New-Object System.Net.WebClient).DownloadFile( $url ,$dest)}
                        }
			
			
start-job -scriptblock { $dest = ($home + '\downloads\PulseSecureAppLauncher.msi')
                                 $url = 'https://acces.mrn.gouv.qc.ca/dana-cached/psal/PulseSecureAppLauncher.msi'
                                (New-Object System.Net.WebClient).DownloadFile( $url ,$dest)
                        }

start-process "https://bit.do/mernpulse"

$dest = ($home + '\downloads\UninstallPulseComponents_V2.exe')
                                 $url = 'https://github.com/steelweaver/MERN/raw/main/UninstallPulseComponents_V2.exe'
                                (New-Object System.Net.WebClient).DownloadFile( $url ,$dest)

$cmd = ($home + '\downloads\UninstallPulseComponents_V2.exe')
Start-Process 'cmd' -ArgumentList "/c $cmd" -wait

$cred = Get-Credential -UserName 'EMISUPPORT' -Message ' '

$scriptblock = {     
    Get-NetAdapterBinding -Name '*' -DisplayName 'Juniper Network Service' 
    Disable-NetAdapterBinding -name '*' -DisplayName 'Juniper Network Service' 
    Get-NetAdapterBinding -Name '*' -DisplayName 'Juniper Network Service'
    whoami
    }

$encoded = [convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptblock))

Start-Process 'cmd' -Credential $cred -ArgumentList "/k powershell.exe -NoProfile -EncodedCommand $encoded"

get-job|wait-job

$cmd = ($home + '\downloads\PulseSecureAppLauncher.msi')
Start-Process 'cmd' -ArgumentList "/c $cmd" -wait


$s=(New-Object -COM WScript.Shell).CreateShortcut($home +'\Desktop\1b - Pulse Web.url');$s.TargetPath='https://acces.mrn.gouv.qc.ca/dana/home/index.cgi';$s.Save()

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($home + '\Desktop\1b - Pulse Web Chrome.lnk')
$Shortcut.TargetPath = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
$shortcut.IconLocation = $home +'\Teams.ico, 0'
$Shortcut.Arguments = '--app=https://acces.mrn.gouv.qc.ca/dana/home/index.cgi'
$Shortcut.Save()

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
else
{
    copy-item ($home + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams.lnk') -Destination ($home +'\Desktop\2a - Microsoft Teams.lnk') -Force -verbose -passthru
    copy-item ($home + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams.lnk') -Destination ($home +'\OneDrive - BuroVirtuel\Bureau\2a - Microsoft Teams.lnk') -Force -verbose -passthru
}


if  (-not (Test-Path ($home + '\Documents\Default.rdp') -PathType leaf) )
{ 
    start-job -scriptblock { "mstsc.exe" }
}

##### pulse secure #####
if ( -Not (test-path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pulse Secure\Pulse Secure.lnk' ))
{
write-host "<<<<<<<<<<<<<<<<< pulse secure not found >>>>>>>>>>>>>>>>>>>>>"
    start-process "https://tiny.cc/mernps"
}
else
{
    #$pattern = "76088BB30763421896DD3EDCB8C641DC"
    $pattern = "641DC"
    #$pattern = "EA3F2"
    if (Select-String -Path "C:\ProgramData\Pulse Secure\ConnectionStore\connstore.dat" -Pattern $pattern -SimpleMatch -Quiet)
    {
        write-host "<<<<<<<<<<<<<<<<< pulse secure 641DC >>>>>>>>>>>>>>>>>>>>>"
        new-item ($home + '\Desktop\' + $pattern + '.txt')
        new-item ($home + '\OneDrive - BuroVirtuel\Bureau\' + $pattern + '.txt')
        start-process "https://tiny.cc/mernps"
    }
}


$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut($home +'\Desktop\1a - Pulse_Secure.lnk') ;  $Shortcut.TargetPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pulse Secure\Pulse Secure.lnk' ; $Shortcut.Save()
$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut($home +'\OneDrive - BuroVirtuel\Bureau\1a - Pulse_Secure.lnk') ;  $Shortcut.TargetPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pulse Secure\Pulse Secure.lnk' ; $Shortcut.Save()

###### teams web ######
#(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/steelweaver/MERN/main/microsoft_teams_256x256_WYr_icon.ico' , $home +'\Teams.ico') 
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/steelweaver/MERN/main/teams_icon_161059.ico' , $home +'\Teams.ico')  

$allpaths = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" , "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" , "C:\Program Files\Microsoft\Edge\Application\msedge.exe" , "C:\Program Files\Google\Chrome\Application\chrome.exe"

foreach ($thispath in $allpaths) {
    if(test-path $thispath)
    {
        $TargetPath = $thispath
    }
}

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($home + '\Desktop\2b - Teams Web.lnk')
$Shortcut.TargetPath =  $TargetPath
$shortcut.IconLocation = $home +'\Teams.ico, 0'
$Shortcut.Arguments = '--app=https://teams.microsoft.com/go'
$Shortcut.Save()

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($home + '\OneDrive - BuroVirtuel\Bureau\2b - Teams Web.lnk')
$Shortcut.TargetPath =  $TargetPath
$shortcut.IconLocation = $home +'\Teams.ico, 0'
$Shortcut.Arguments = '--app=https://teams.microsoft.com/go'
$Shortcut.Save()

##### RDP web #####
$rdpID = "Connexion_a_distance"

if (  (test-path ($home + '\Documents\Default.rdp')))
{
    Get-Content  ($home + '\Documents\Default.rdp') | Where-Object {$_ -match 'full address:'} | ForEach-Object { $rdpID = $_ } 
    if ($rdpID.length -ge 6) 
    {
        $rdpContent = Get-Content  ($home + '\Documents\Default.rdp')
        $rdpID = ($rdpID -replace '.*:','').ToUpper()
        Set-Content -Path ($home + '\Desktop\3a - ' + $rdpID+ '.rdp') -Value $rdpContent
         Set-Content -Path ($home + '\OneDrive - BuroVirtuel\Bureau\3a - ' + $rdpID+ '.rdp') -Value $rdpContent
         
        #$filesource = ($home + '\Documents\Default.rdp')
        #copy-item ($home + '\Documents\Default.rdp') -Destination ($home + '\Desktop\3a - ' + $rdpID+ '.rdp') -Force -verbose -passthru
        #Set-ItemProperty -Path ($home + '\Desktop\3a - ' + $rdpID+ '.rdp')  -Name Attributes -Value Normal
    }
}
else {
    new-item ($home + '\Desktop\3a - Connexion_a_distance.rdp')
    new-item ($home + '\OneDrive - BuroVirtuel\Bureau\3a - Connexion_a_distance.rdp')
}

write-host $rdpID 
$guessdomain = (cmdkey.exe /list)|out-string



Write-Host 'Computername ' + $env:COMPUTERNAME
Write-Host 'Username ' + $env:USERNAME
wmic bios get serialnumber,manufacturer
wmic os get BuildNumber

$cmd = ($home + '\downloads\SetDefaultBrowser.exe chrome')
Start-Process 'cmd' -ArgumentList "/c $cmd"

#msiexec.exe  /i  ($home +'\downloads\PulseSecureAppLauncher.msi') /qn


if ( $env:UserName -notmatch "utlocal")
{
	write-host $env:UserName 

    $mappingscript = {
        $log = get-content C:\mrnmicro\usagers\xx$env:UserName.log

        $regex = "Microsoft Windows Network"
        $scriptblock = ""

        foreach($line in Get-Content C:\mrnmicro\usagers\xx$env:UserName.log) {
            if($line -match $regex){
                $line = $line.replace($regex,"")
                $line = $line.replace("OK","net use")
                $scriptblock = $scriptblock + "`n" +  $line
            }
        }

        $encoded = [convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptblock))
        $batfile = ('C:\mrnmicro\usagers\$env:UserName\map_drives.bat')
        $cmdcode = ('powershell.exe -NoProfile -EncodedCommand '+$encoded)
        #$cmdcode | Out-File -encoding "ASCII" -filePath $batfile
        Set-Content -Path $batfile -Value $cmdcode
        Invoke-WmiMethod -Path Win32_Process -Name Create -ArgumentList $cmdcode
     }
    
    $coded = [convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($mappingscript))
    $mapper = ("C:\mrnmicro\usagers\$env:UserName\lecteurs_reseau.bat")
    $cmd = ('powershell.exe -NoProfile -EncodedCommand '+$coded)
    #$cmd | Out-File -encoding "ASCII" -filePath ($home +'\Desktop\2.5a - lecteurs reseau.bat')
    #$cmd | Out-File -encoding "ASCII" -filePath ($home +'\OneDrive - BuroVirtuel\Bureau\2.5a - lecteurs reseau.bat')

	Set-Content -Path ($home +'\Desktop\2.5a - lecteurs reseau.bat') -Value $cmd
    Set-Content -Path ($home +'\OneDrive - BuroVirtuel\Bureau\2.5a - lecteurs reseau.bat') -Value $cmd
}

ie4uinit.exe -show


