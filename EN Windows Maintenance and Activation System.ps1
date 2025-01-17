# Check if the script is being run with administrator privileges
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Create a new process with elevated privileges
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo
    $newProcess.FileName = "powershell.exe"
    $newProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"" + $MyInvocation.MyCommand.Path + "`""
    $newProcess.Verb = "runas"
    [System.Diagnostics.Process]::Start($newProcess)
    Exit
}

Function Menu {
    Clear-Host
    Write-Host "==================================================="
    Write-Host "INTERACTIVE SYSTEM ACTIVATION AND MAINTENANCE MENU"
    Write-Host "MADE BY: OITALAO"
    Write-Host "==================================================="
    Write-Host "0. Hacker Mode"
    Write-Host "1. Cleaning and Maintenance"
    Write-Host "2. Activate Windows"
    Write-Host "3. Activate Office"
    Write-Host "4. Debloat Windows 11"
    Write-Host "5. Basic Programs"
    Write-Host "6. System Performance Optimization"
    Write-Host "7. Exit"
    Write-Host "======================"
    $op = Read-Host "Choose an option"

    Switch ($op) {
        0 { HackerMode }
        1 { CleaningAndMaintenance }
        2 { ActivateWindowsMenu }
        3 { ActivateOfficeMenu }
        4 { DebloatWindows11 }
        5 { BasicPrograms }
        6 { PerformanceOptimization }
        7 { Exit }
        Default { Menu }
    }
}

Function HackerMode {
    Write-Host "Activating Hacker Mode..." -ForegroundColor Green
    # Color settings for hacker mode
    $host.UI.RawUI.BackgroundColor = "Black"
    $host.UI.RawUI.ForegroundColor = "Green"
    Clear-Host
    Write-Host "Hacker Mode Activated" -ForegroundColor Green
    Pause
    Menu
}

Function CleaningAndMaintenance {
    Write-Host "Deleting temporary files..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temporary file cleanup completed!"

    Write-Host "Running Disk Cleanup..."
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait

    Write-Host "Running CHKDSK..."
    Start-Process -FilePath "chkdsk.exe" -ArgumentList "/f /r" -NoNewWindow -Wait

    Write-Host "Resetting IP configuration..."
    Invoke-Expression "netsh int ip reset"

    Write-Host "Clearing DNS..."
    Invoke-Expression "ipconfig /flushdns"

    Write-Host "Running SFC..."
    sfc /scannow

    Write-Host "Running DISM - ScanHealth..."
    dism /online /cleanup-image /scanhealth

    Write-Host "Running DISM - RestoreHealth (if necessary)..."
    dism /online /cleanup-image /restorehealth

    Write-Host "Running Windows Malicious Software Removal Tool..."
    mrt /F /Q

    Write-Host "Checking and installing Windows updates..."
    Install-Module -Name PSWindowsUpdate -Force -SkipPublisherCheck
    Import-Module PSWindowsUpdate
    Get-WindowsUpdate -Install -AcceptAll -AutoReboot

    Write-Host "Updating all Winget packages..."
    winget upgrade --all

    Write-Host "Registering AppX packages for all users..."
    Get-AppxPackage -AllUsers | Where-Object { $_.InstallLocation -like '*SystemApps*' } | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }

    Write-Host "All tasks have been completed!"
    Pause
    Menu
}

Function ActivateWindowsMenu {
    Clear-Host
    Write-Host "======================"
    Write-Host "ACTIVATE WINDOWS"
    Write-Host "======================"
    Write-Host "1. Windows 10"
    Write-Host "2. Windows 11"
    Write-Host "3. Return to menu"
    Write-Host "======================"
    $op2 = Read-Host "Choose an option"

    Switch ($op2) {
        1 { ActivateWindows10 }
        2 { ActivateWindows11 }
        3 { Menu }
        Default { ActivateWindowsMenu }
    }
}

Function ActivateWindows10 {
    Write-Host "Activating Windows 10..."
    slmgr /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
    slmgr /skms kms8.msguides.com
    slmgr /ato
    Write-Host "Windows 10 activated!"
    Pause
    ActivateWindowsMenu
}

Function ActivateWindows11 {
    Write-Host "Activating Windows 11..."
    slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
    slmgr /skms kms8.msguides.com
    slmgr /ato
    Write-Host "Windows 11 activated!"
    Pause
    ActivateWindowsMenu
}

Function ActivateOfficeMenu {
    Clear-Host
    Write-Host "======================"
    Write-Host "ACTIVATE OFFICE"
    Write-Host "======================"
    Write-Host "READ THE WARNINGS CAREFULLY!!!!!!!!!!!!!!!!!!!!"
    Write-Host "The Office Package is an external application to Windows, so it must be installed using the link provided in option 3."
    Write-Host "YOU MUST PERFORM THE INSTALLATION PROCEDURE BEFORE ACTIVATION!"
    Write-Host "IF ONE DOESN'T WORK, TRY THE OTHER! Office tends to have problems activating!"
    Write-Host "1. Method 1"
    Write-Host "2. Method 2"
    Write-Host "3. I don't have Office"
    Write-Host "4. Return to menu"
    Write-Host "======================"
    $op3 = Read-Host "Choose an option"

    Switch ($op3) {
        1 { ActivateOfficeMethod1 }
        2 { ActivateOfficeMethod2 }
        3 { IDontHaveOffice }
        4 { Menu }
        Default { ActivateOfficeMenu }
    }
}

Function ActivateOfficeMethod1 {
    Write-Host "Navigating to the Microsoft Office directory..."
    If (Test-Path "$env:ProgramFiles\Microsoft Office\Office16\ospp.vbs") {
        Set-Location -Path "$env:ProgramFiles\Microsoft Office\Office16"
    } ElseIf (Test-Path "$env:ProgramFiles(x86)\Microsoft Office\Office16\ospp.vbs") {
        Set-Location -Path "$env:ProgramFiles(x86)\Microsoft Office\Office16"
    }

    ForEach ($lic in (Get-ChildItem ..\root\Licenses16\ProPlus2019VL*.xrm-ms)) {
        cscript ospp.vbs /inslic:"$($lic.FullName)" > $null
    }

    Write-Host "Activating your Office..."
    cscript //nologo slmgr.vbs /ckms > $null
    cscript //nologo ospp.vbs /setprt:1688 > $null
    cscript //nologo ospp.vbs /unpkey:6MWKP > $null
    cscript //nologo ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP > $null

    $i = 1
    Do {
        Switch ($i) {
            1 { $KMS_Srv = "kms7.MSGuides.com" }
            2 { $KMS_Srv = "kms8.MSGuides.com" }
            3 { $KMS_Srv = "kms9.MSGuides.com" }
            Default { Write-Host "Sorry! Your version of Office is not supported."; Exit }
        }
        cscript //nologo ospp.vbs /sethst:$KMS_Srv > $null
        If ((cscript //nologo ospp.vbs /act) -match "successful") {
            Write-Host "Office successfully activated!"
            Start-Process "http://MSGuides.com"
            Break
        } Else {
            Write-Host "Failed to connect to KMS server! Trying another one..."
            $i++
        }
    } While ($i -le 3)

    Pause
    Menu
}

Function ActivateOfficeMethod2 {
    Write-Host "Navigating to the Microsoft Office directory (Program Files x86)..."
    Set-Location -Path "$env:ProgramFiles(x86)\Microsoft Office\Office16"
    
    Write-Host "Navigating to the Microsoft Office directory (Program Files)..."
    Set-Location -Path "$env:ProgramFiles\Microsoft Office\Office16"

    Write-Host "Installing KMS licenses..."
    ForEach ($lic in (Get-ChildItem ..\root\Licenses16\ProPlus2021VL_KMS*.xrm-ms)) {
        cscript ospp.vbs /inslic:"$($lic.FullName)"
    }

    Write-Host "Setting the KMS port..."
    cscript ospp.vbs /setprt:1688

    Write-Host "Removing the product key..."
    cscript ospp.vbs /unpkey:6F7TH > $null

    Write-Host "Inserting the new product key..."
    cscript ospp.vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH

    Write-Host "Setting the KMS host..."
    cscript ospp.vbs /sethst:e8.us.to

    Write-Host "Activating Office..."
    cscript ospp.vbs /act

    Write-Host "Process completed."
    Pause
    Menu
}

Function IDontHaveOffice {
    Write-Host "Opening the Office site..."
    Start-Process "https://msguides.com/download-microsoft-office-windows-os"
    Menu
}

Function DebloatWindows11 {
    Set-ExecutionPolicy Unrestricted -Force
    Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/Raphire/Win11Debloat/master/Get.ps1')
    Pause
    Menu
}

Function BasicPrograms {
    Write-Host "Installing Google Chrome..."
    winget install -e --id Google.Chrome

    Write-Host "Installing VLC Media Player..."
    winget install -e --id VideoLAN.VLC

    Write-Host "Installing Java Runtime Environment..."
    winget install -e --id Oracle.JavaRuntimeEnvironment

    Write-Host "Installing aTube Catcher..."
    winget install -e --id DsNET.atube-catcher

    Write-Host "Installing 7-Zip..."
    winget install -e --id 7zip.7zip

    Write-Host "Installing qBittorrent..."
    winget install -e --id qBittorrent.qBittorrent

    Write-Host "Installing Adobe Acrobat Reader DC..."
    winget install -e --id Adobe.Acrobat.Reader.64-bit

    Write-Host "All basic programs have been installed!"
    Pause
    Menu
}

Function PerformanceOptimization {
    Clear-Host
    Write-Host "======================"
    Write-Host "SYSTEM PERFORMANCE OPTIMIZATION"
    Write-Host "======================"
    Write-Host "1. Disable unnecessary services"
    Write-Host "2. Adjust power settings"
    Write-Host "3. Enable maximum performance mode"
    Write-Host "4. Return to menu"
    Write-Host "======================"
    $op4 = Read-Host "Choose an option"

    Switch ($op4) {
        1 { DisableServices }
        2 { AdjustPowerSettings }
        3 { MaximumPerformance }
        4 { Menu }
        Default { PerformanceOptimization }
    }
}

Function DisableServices {
    Write-Host "Disabling unnecessary services..."
    sc config "DiagTrack" start= disabled
    sc config "dmwappushservice" start= disabled
    sc config "TrkWks" start= disabled
    sc config "WMPNetworkSvc" start= disabled
    sc stop "DiagTrack"
    sc stop "dmwappushservice"
    sc stop "TrkWks"
    sc stop "WMPNetworkSvc"
    Write-Host "Services disabled!"
    Pause
    PerformanceOptimization
}

Function AdjustPowerSettings {
    Write-Host "Adjusting power settings for high performance..."
    powercfg /change standby-timeout-ac 0
    powercfg /change hibernate-timeout-ac 0
    powercfg /change monitor-timeout-ac 0
    powercfg /change disk-timeout-ac 0
    powercfg /setactive SCHEME_MIN
    Write-Host "Power settings adjusted!"
    Pause
    PerformanceOptimization
}

Function MaximumPerformance {
    Write-Host "Enabling maximum performance mode..."
    powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    Write-Host "Maximum performance mode enabled!"
    Pause
    PerformanceOptimization
}

Menu
