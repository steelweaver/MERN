cls


$RemoteComputer = "225848pp"
$RemoteComputer = "220780PP"



$RemoteComputers = "220780PP" # ,"226829pp" #,"225848pp" , "226126PP" , "227730pp"# , "224997pp" , "224998pp" , "224999pp" , "218100pp" #, "224669pt" #, "211844pp"



foreach ($RemoteComputer in $RemoteComputers)
{



        $SessionArgs = @{
             ComputerName = $RemoteComputer 
             #Credential    = Get-Credential
             SessionOption = New-CimSessionOption -Protocol Dcom
         }

         $MethodArgs = @{
             ClassName     = 'Win32_Process'
             MethodName    = 'Create'
             CimSession    = New-CimSession @SessionArgs
             Arguments     = @{
                 CommandLine = "powershell Start-Process powershell -ArgumentList 'Enable-PSRemoting -Force'"
             }
         }


         Invoke-CimMethod @MethodArgs
 


    Invoke-Command -ComputerName $RemoteComputer -ScriptBlock{

        wmic computersystem get name
        WMIC CSPRODUCT GET NAME
        (Get-WmiObject -Class:Win32_ComputerSystem).name
        (Get-WmiObject -Class:Win32_ComputerSystem).Model

        Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -match "microsoft"} | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |Format-Table –AutoSize
        
        $dldest = ('C:\MrnMicro\EMIMSI\outils\officescrub\')

        if ( -Not (test-path ($dldest))) { New-Item -Path $dldest -ItemType Directory | out-null }
        
        $filename = 'OfficeRemova-OffScrubl.zip'
        $unzipdest = ('C:\MrnMicro\EMIMSI\outils\officescrub')
         write-host $filename unzipping 
         write-host $unzipdest 
            $url = ('http://woshub.com/wp-content/uploads/bin/' + $filename)
            (New-Object System.Net.WebClient).DownloadFile( $url , $dldest+$filename)
            Expand-Archive -Path ($dldest+$filename) -DestinationPath $unzipdest
   write-host unzipped

#https://deploymentmadscientist.com/2016/02/08/deploying-microsoft-office-2016-removing-old-versions/
 
write-host OffScrub10 (get-date) 
    cscript $unzipdest\2010\OffScrub10.vbs ALL /clientall /NoCancel /Force /OSE  /Quiet  /L "C:\MrnMicro\EMIMSI\outils\officescrub\logs"
write-host OffScrub_O15msi (get-date) 
    cscript $unzipdest\2013\OffScrub_O15msi.vbs ALL /clientall /NoCancel /Force /OSE  /Quiet  /L "C:\MrnMicro\EMIMSI\outils\officescrub\logs"
write-host OffScrub_O16msi (get-date) 
    cscript $unzipdest\2016\OffScrub_O16msi.vbs ALL /clientall  /NoCancel /Force /OSE  /Quiet  /L "C:\MrnMicro\EMIMSI\outils\officescrub\logs"
write-host OffScrubC2R (get-date) 
    cscript $unzipdest\O365\OffScrubC2R.vbs ALL /clientall /NoCancel /Force /OSE  /Quiet  /L "C:\MrnMicro\EMIMSI\outils\officescrub\logs"

         write-host Done

        get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -match "microsoft"} | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |Format-Table –AutoSize

        $Computername = $using:RemoteComputer
        $Method = "Install"
        $AppName = "Microsoft Office 365 x64"

        Get-WmiObject -Namespace  ROOT\ccm\ClientSDK -Class CCM_Application -ComputerName $Computername  | Select-Object Fullname ,  InstallState, ResolvedState,AllowedActions

        $Application = (Get-CimInstance -ClassName CCM_Application -Namespace "root\ccm\clientSDK" -ComputerName $Computername | Where-Object {$_.Name -like $AppName})
 
        $Args = @{EnforcePreference = [UINT32] 0
        Id = "$($Application.id)"
        IsMachineTarget = $Application.IsMachineTarget
        IsRebootIfNeeded = $False
        Priority = 'High'
        Revision = "$($Application.Revision)" }

        Invoke-CimMethod -Namespace "root\ccm\clientSDK" -ClassName CCM_Application -ComputerName $Computername -MethodName $Method -Arguments $Args

        #path to install office 365 without SCCM
        #\\intranet\dfs_mrn\EmiMsi\EMI_Source\SourceOff\Office 365.cmd

    }
}
