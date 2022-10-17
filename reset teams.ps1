cls
    $teamsexe = ($home + '\downloads\Teams_windows_x64.1.4.00.1973.exe')

    start-job -Name dlteams -ScriptBlock { 
        if ( -Not (test-path ($using:teamsexe)))
        {
            write-host start dl teams

            #$url = 'https://go.microsoft.com/fwlink/p/?LinkID=869426&clcid=0x1009&culture=en-ca&country=CA&lm=deeplink&lmsrc=groupChatMarketingPageWeb&cmpid=directDownloadWin64'

            $url = 'https://statics.teams.cdn.office.net/production-windows-x64/1.4.00.1973/Teams_windows_x64.exe'

            (New-Object System.Net.WebClient).DownloadFile($url  , $using:teamsexe )
        }
    }


    if (test-path C:\Users\*\AppData\Local\Microsoft\Teams\current\Teams.exe)
    {
        kill -name teams -force

        write-host ===========================
        write-host uninstall teams
        write-host ===========================

        (Get-ItemProperty C:\Users\*\AppData\Local\Microsoft\Teams\Current).PSParentPath | foreach-object {Start-Process $_\Update.exe -ArgumentList "--uninstall /s" -Wait}
    }

    Remove-Item -Recurse -force C:\Users\garjo3\AppData\Local\Microsoft\Teams
    Remove-Item -Recurse -force C:\Users\garjo3\AppData\Roaming\Microsoft\Teams
    Remove-Item -Recurse -force C:\Users\garjo3\AppData\Roaming\Teams
    Remove-Item -Recurse -force C:\windows\Prefetch\TEAMS*.*
    Remove-Item -Recurse -force $env:LOCALAPPDATA\Microsoft\Teams\

    write-host ===========================
    write-host uninstalled teams
    write-host ===========================

    write-host ===========================
    write-host wait for download to finish
    write-host ===========================

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

    Get-Job  -Name dlteams | Wait-Job
    remove-Job -Name dlteams


    write-host ===========================
    write-host Starting teams install
    write-host ===========================

    Start-Sleep -s 1


    $teamsexe = ($home + '\downloads\Teams_windows_x64.1.4.00.1973.exe')
    Start-Process $teamsexe

    $isVPN = ipconfig /all

    if ($isVPN -match "Juniper Networks Virtual Adapter")
    {

    
    }
    else
    {
        TASKKILL /F /IM pulse.exe
        Write-Host Not Connected : Juniper Networks Virtual Adapter 
        #start-process "C:\Program Files (x86)\Common Files\Pulse Secure\JamUI\Pulse.exe" -show
        Start-Process "C:\Program Files (x86)\Common Files\Pulse Secure\JamUI\Pulse.exe" -ArgumentList "-show"
    }

