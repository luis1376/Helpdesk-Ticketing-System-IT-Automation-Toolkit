# Disable-InactiveADAccounts.ps1
# Finds and disables AD accounts that haven't logged in for 90+ days

Import-Module ActiveDirectory

$DaysInactive = 90
$CutoffDate = (Get-Date).AddDays(-$DaysInactive)

$InactiveUsers = Get-ADUser -Filter {LastLogonTimestamp -lt $CutoffDate -and Enabled -eq $true} `
    -Properties LastLogonTimestamp |
    Select-Object Name, SamAccountName, @{N='LastLogon';E={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}

if ($InactiveUsers.Count -eq 0) {
    Write-Host "No inactive accounts found."
} else {
    Write-Host "Found $($InactiveUsers.Count) inactive account(s):"
    $InactiveUsers | Format-Table -AutoSize

    foreach ($user in $InactiveUsers) {
        Disable-ADAccount -Identity $user.SamAccountName
        Write-Host "Disabled: $($user.SamAccountName)"
    }
}
