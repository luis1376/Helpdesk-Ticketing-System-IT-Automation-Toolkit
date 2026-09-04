# Get-PasswordExpiryReport.ps1
# Finds users whose passwords expire within the next 7 days

Import-Module ActiveDirectory

$DaysWarning = 7
$Users = Get-ADUser -Filter {Enabled -eq $true} -Properties PasswordLastSet, PasswordNeverExpires

$MaxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days

$Report = foreach ($user in $Users) {
    if (-not $user.PasswordNeverExpires -and $user.PasswordLastSet) {
        $ExpiryDate = $user.PasswordLastSet.AddDays($MaxPasswordAge)
        $DaysLeft = ($ExpiryDate - (Get-Date)).Days

        if ($DaysLeft -le $DaysWarning -and $DaysLeft -ge 0) {
            [PSCustomObject]@{
                User        = $user.SamAccountName
                ExpiresOn   = $ExpiryDate.ToShortDateString()
                DaysLeft    = $DaysLeft
            }
        }
    }
}

if ($Report) {
    Write-Host "Users with passwords expiring soon:"
    $Report | Format-Table -AutoSize
} else {
    Write-Host "No passwords expiring within $DaysWarning days."
}
