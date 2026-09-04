# Get-LocalAdminAudit.ps1
# Lists members of the local Administrators group on target machines

$Computers = @("localhost", "win11")

foreach ($Computer in $Computers) {
    Write-Host "`n--- $Computer ---"
    try {
        Invoke-Command -ComputerName $Computer -ScriptBlock {
            Get-LocalGroupMember -Group "Administrators" |
                Select-Object Name, PrincipalSource
        } -ErrorAction Stop
    } catch {
        Write-Warning "Could not query $Computer: $_"
    }
}
