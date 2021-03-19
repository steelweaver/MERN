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
else
{
    copy-item ($home + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams.lnk') -Destination ($home +'\Desktop\2a - Microsoft Teams.lnk') -Force -verbose -passthru
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
        start-process "https://tiny.cc/mernps"
    }
}


$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut($home +'\Desktop\1a - Pulse_Secure.lnk') ;  $Shortcut.TargetPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Pulse Secure\Pulse Secure.lnk' ; $Shortcut.Save()

###### teams web ######
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/steelweaver/MERN/main/microsoft_teams_256x256_WYr_icon.ico' , $home +'\Teams.ico') 

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($home + '\Desktop\2b - Teams Web.lnk')
$Shortcut.TargetPath = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
$shortcut.IconLocation = $home +'\Teams.ico, 0'
$Shortcut.Arguments = '--app=https://teams.microsoft.com/go'
$Shortcut.Save()


<#
$rdpContent = "test"
$rdpID = "test"
Set-Content -Path ($home + '\Desktop\3a - ' + $rdpID + '.rdp') -Value $rdpContent
#>

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

        #$filesource = ($home + '\Documents\Default.rdp')
        #copy-item ($home + '\Documents\Default.rdp') -Destination ($home + '\Desktop\3a - ' + $rdpID+ '.rdp') -Force -verbose -passthru
        #Set-ItemProperty -Path ($home + '\Desktop\3a - ' + $rdpID+ '.rdp')  -Name Attributes -Value Normal
    }
}
else {
    new-item ($home + '\Desktop\3a - Connexion_a_distance.rdp')
}

write-host $rdpID 
$guessdomain = (cmdkey.exe /list)|out-string


if( $guessdomain -match "intranet")
{
    $s=(New-Object -COM WScript.Shell).CreateShortcut($home +'\Desktop\1b - Pulse Démarrer Intranet.url');$s.TargetPath='https://acces.mrn.gouv.qc.ca/dana/home/index.cgi';$s.Save()
    $s=(New-Object -COM WScript.Shell).CreateShortcut($home +'\Desktop\3b - ' + $rdpID + ' intranet.url');$s.TargetPath='https://acces.mrn.gouv.qc.ca/dana/home/index.cgi';$s.Save()
}

if( $guessdomain -match "foncierqc")
{
    $s=(New-Object -COM WScript.Shell).CreateShortcut($home +'\Desktop\1b - Pulse Démarrer FoncierQC.url');$s.TargetPath='https://teleacces-st.mern.gouv.qc.ca/';$s.Save()
    $s=(New-Object -COM WScript.Shell).CreateShortcut($home +'\Desktop\3b - ' + $rdpID + ' foncierQC.url');$s.TargetPath='https://teleacces-st.mern.gouv.qc.ca/';$s.Save()
}


##### Network Connect ######



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

$mapdrives = @' 
setlocal EnableExtensions EnableDelayedExpansion
set "LOGTEXTFILE=C:\mrnmicro\usagers\xx%username%.log"
set "INTEXTFILE=C:\Users\%username%\Desktop\input.bat"
set "OUTTEXTFILE=C:\Users\%username%\Desktop\output.bat"
del %OUTTEXTFILE%

set "SEARCHTEXT=OK"
set "REPLACETEXT=net use"

set "SEARCHTEXT1=Microsoft Windows Network"
set "REPLACETEXT1="

findstr "OK.*" C:\mrnmicro\usagers\xx%username%.log>C:\Users\%username%\Desktop\input.bat
for /f "delims=" %%A in ('type "%INTEXTFILE%"') do (
    set "string=%%A"
    
set "modified=!string:%SEARCHTEXT%=%REPLACETEXT%!"
set "string=!modified:%SEARCHTEXT1%=%REPLACETEXT1%!"

	::set "modified=!string:Microsoft Windows Network= !"
	echo !string!>>"%OUTTEXTFILE%"
)

del %INTEXTFILE%
cmd /c %OUTTEXTFILE%
del %OUTTEXTFILE%
'@

#$mapdrives |out-file ($home +'\Desktop\lecteurs reseau.bat')

Set-Content -Path ($home +'\Desktop\lecteurs reseau.bat') -Value $mapdrives

control /name Microsoft.CredentialManager
