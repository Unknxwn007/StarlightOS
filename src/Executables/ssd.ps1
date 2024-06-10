if ((Get-Partition | Where-Object { $_.IsBoot } | Get-Disk | Get-PhysicalDisk).MediaType -eq "SSD") {
    
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}"
    $val = (Get-ItemProperty -Path $regPath -Name "LowerFilters")."LowerFilters" | Where-Object { $_ -ne 'rdyboost' }
    Set-ItemProperty -Path $regPath -Name "LowerFilters" -Value $val -Force
    Set-Service -Name rdyboost -StartupType Disabled
    Remove-Item -Path "Registry::HKCR\Drive\shellex\PropertySheetHandlers\{55B3A0BD-4D28-42fe-8CFB-FA3EDFF969B8}" -Force -ErrorAction SilentlyContinue
    Set-Service -Name SysMain -StartupType Disabled
}


$startup = 'Automatic'
try {
    Get-CimInstance -Class WmiMonitorBrightnessMethods -Namespace root/wmi -ErrorAction Stop | Out-Null
} catch {
    if ((Get-ComputerInfo).CsPCSystemType -eq 'Desktop') {
        $startup = 'Disabled'
    }
}
Set-Service -Name DisplayEnhancementService -StartupType $startup