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
$isNetworkDown = $false
$networkFailDateTime = $null

# Main script execution
while($true)
{
    try {
        Write-Host $PSScriptRoot

        Invoke-WebRequest -Uri "https://www.google.com" -TimeoutSec 5 -ErrorAction Stop | Out-Null

        if ($isNetworkDown) {
            $now = Get-Date
            Write-LogLine "Network went back UP at: $($now)"

            $diff = ($now - $networkFailDateTime)
            Write-LogLine "Network was DOWN for: $($diff.Minutes) minutes, $($diff.Seconds) seconds"
            Write-LogLine "--------------------------------------------------"

            $isNetworkDown = $false
            $networkFailDateTime = $null
        }
    } catch {
        $isNetworkDown = $true
        if ($networkFailDateTime -eq $null) {
            $networkFailDateTime = Get-Date
            Write-LogLine "Network went DOWN at: $($networkFailDateTime)"
        }
    }

    Start-Sleep -Seconds 10
}


