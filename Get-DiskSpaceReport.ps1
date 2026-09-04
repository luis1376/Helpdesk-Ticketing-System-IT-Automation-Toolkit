# Get-DiskSpaceReport.ps1
# Reports disk usage for one or more computers

$Computers = @("localhost", "win11")  # add more hostnames as needed

$Report = foreach ($Computer in $Computers) {
    Get-CimInstance -ComputerName $Computer -ClassName Win32_LogicalDisk -Filter "DriveType=3" |
        Select-Object @{N='Computer';E={$Computer}},
                      DeviceID,
                      @{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}},
                      @{N='FreeGB';E={[math]::Round($_.FreeSpace/1GB,2)}},
                      @{N='PercentFree';E={[math]::Round(($_.FreeSpace/$_.Size)*100,1)}}
}

$Report | Format-Table -AutoSize

$Report | Where-Object { $_.PercentFree -lt 15 } | ForEach-Object {
    Write-Warning "$($_.Computer) drive $($_.DeviceID) is critically low: $($_.PercentFree)% free"
}
