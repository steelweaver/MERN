cls
 
start-job -scriptblock { $dest = ($home + '\downloads\PulseSecureAppLauncher.msi') 
                            $url = 'https://acces.mrn.gouv.qc.ca/dana-cached/psal/PulseSecureAppLauncher.msi' 
                            (New-Object System.Net.WebClient).DownloadFile( $url ,$dest) 
                        } 
 
$x86Path = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$installedItemsX86 = Get-ItemProperty -Path $x86Path | Select-Object -Property PSChildName, DisplayName, DisplayVersion
 
$x64Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
$installedItemsX64 = Get-ItemProperty -Path $x64Path | Select-Object -Property PSChildName, DisplayName, DisplayVersion
 
$installedItems = $installedItemsX86 + $installedItemsX64
$installedItems = $installedItems|? { $_.PSChildName -match "{*}" } |? { $_.DisplayName -match "Pulse Application Launcher" }
  
taskkill /im UninstallPulseComponents_V2.exe /f
taskkill /im PulseApplicationLauncher.exe /f
 
$cmd = "$env:APPDATA\Pulse Secure\Pulse Secure Citrix Services Client\uninstall.exe /S"
Start-Process 'cmd' -ArgumentList "/c $cmd" -wait 
$cmd = "$env:APPDATA\Pulse Secure\Pulse Terminal Services Client\uninstall.exe /S"
Start-Process 'cmd' -ArgumentList "/c $cmd" -wait 
$cmd = "$env:APPDATA\Pulse Secure\Host Checker\uninstall.exe  /S"
Start-Process 'cmd' -ArgumentList "/c $cmd" -wait 
$cmd = "$env:APPDATA\Pulse Secure\Setup Client\uninstall.exe  /S"
Start-Process 'cmd' -ArgumentList "/c $cmd" -wait 
 
foreach ($installedItem in $installedItems) {
        write-host ===============================
        write-host Uninstalling $installedItem 
        write-host ===============================
        $thisguid  = $installedItem | select -Expand PSchildname
        write-host installedItem  $thisguid 
 
        $cmd = ('msiexec /x ' + $thisguid  + ' /qn /norestart')  # " ##/qn /norestart"
        Start-Process 'cmd' -ArgumentList "/c $cmd"   -wait 
    }
   
get-job|wait-job 
      write-host ===============================
        write-host Uninstalling PulseSecureAppLauncher
        write-host ===============================

$cmd = ('msiexec /x ' + $home + '\downloads\PulseSecureAppLauncher.msi /qn /norestart')  # " ##/qn /norestart"
Start-Process 'cmd' -ArgumentList "/c $cmd"   -wait 
 
        write-host ===============================
        write-host installing PulseSecureAppLauncher
        write-host ===============================


$cmd = ('msiexec /i ' + $home + '\downloads\PulseSecureAppLauncher.msi /qn /norestart')  # " ##/qn /norestart"
Start-Process 'cmd' -ArgumentList "/c $cmd"   -wait 
 

        write-host ===============================
        write-host Creating Desktop Shortcut
        write-host ===============================

$WshShell = New-Object -comObject WScript.Shell 
$Shortcut = $WshShell.CreateShortcut($home + '\Desktop\1b - Pulse Web Chrome.lnk') 
$Shortcut.TargetPath = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe' 
$shortcut.IconLocation = $env:APPDATA + '\Pulse Secure\PSAL\PulseApplicationLauncher.exe ,0'
$Shortcut.Arguments = '--app=https://acces.mrn.gouv.qc.ca/dana/home/index.cgi' 
$Shortcut.Save() 
 
copy-item ($home + '\Desktop\1b - Pulse Web Chrome.lnk') -Destination ($home +'\OneDrive - BuroVirtuel\Bureau\1b - Pulse Web Chrome.lnk') -Force -verbose -passthru
 
Start-Process -FilePath  ($home + '\Desktop\1b - Pulse Web Chrome.lnk')
 
$x86Path = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$installedItemsX86 = Get-ItemProperty -Path $x86Path | Select-Object -Property PSChildName, DisplayName, DisplayVersion
 
$x64Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
$installedItemsX64 = Get-ItemProperty -Path $x64Path | Select-Object -Property PSChildName, DisplayName, DisplayVersion
 
$installedItems = $installedItemsX86 + $installedItemsX64
$installedItems|? { $_.PSChildName -match "{*}" } |? { $_.DisplayName -match "Pulse " }


 
        write-host ===============================
        write-host Done
        write-host ===============================
