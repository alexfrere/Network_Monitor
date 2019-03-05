# Helper functions
function Write-LogLine {
    param([string]$logText)
    
    $logsFolderName = "network_logs"
    $logsFolderPath = Join-Path $PSScriptRoot $logsFolderName

    if (-not (Test-Path $logsFolderPath)) {
        New-Item $logsFolderPath -ItemType Directory | Out-Null
    }

    $today = Get-Date
    $logFileName = "$($today.Year)_$($today.Month)_$($today.Day).txt"
    $logFilePath = Join-Path $logsFolderPath $logFileName

    if (-not (Test-Path $logFilePath)) {
        New-Item $logFilePath -ItemType File | Out-Null
    }

    Add-Content $logFilePath $logText
}

# Variables
$failCount = 0
$isNetworkDown = $false
$networkFailDateTime = $null

# Main script execution
while($true)
{
    try {
        Invoke-WebRequest -Uri "https://www.google.com" -TimeoutSec 3 -ErrorAction Stop | Out-Null

        if ($isNetworkDown) {
            $now = Get-Date
            Write-LogLine "$($now) - network came back UP"

            $diff = ($now - $networkFailDateTime)
            Write-LogLine "DOWNTIME: $($diff.Hours)h - $($diff.Minutes)m - $($diff.Seconds)s"
            Write-LogLine "--------------------------------------------------"
        }

        $failCount = 0
        $isNetworkDown = $false
        $networkFailDateTime = $null
    } catch {
        $failCount++
        
        if ($networkFailDateTime -eq $null) {
            $networkFailDateTime = Get-Date
        }

        if (($failCount -ge 3) -and (-not $isNetworkDown)) {
            $isNetworkDown = $true
            Write-LogLine "$($networkFailDateTime) - network went DOWN"
        }
    }

    Start-Sleep -Seconds 5
}