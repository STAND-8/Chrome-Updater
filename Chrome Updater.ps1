# Created by Bryant Wiggins 9/26/24
# Define a log file path
$logFilePath = "$env:TEMP\browser_update_log.txt"

# Function to log messages
# To find the log file go to powershell and run: $env:TEMP then search for the file "browser_update_log.txt".
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logFilePath -Value $logMessage
}

# Start logging
Log-Message "Starting browser update script."

try{
    # Chrome installer path. Placed in a variable because this script is intended to run without user intervention.
    $chromeInstallerUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
    $chromeInstallerPath = "$env:TEMP\chrome_installer.exe"
    Log-Message "Downloading Chrome installer from $chromeInstallerUrl"
    Invoke-WebRequest -Uri $chromeInstallerUrl -OutFile $chromeInstallerPath
    Log-Message "Chrome installer downloaded successfully."

    # Run the Chrome installer silently to update Chrome
    Log-Message "Installing/Updating Chrome."
    Start-Process -FilePath $chromeInstallerPath -ArgumentList "/silent /install" -Wait
    Log-Message "Chrome installed/updated successfully."

    # Remove the Chrome installer after the update to keep things clean
    Log-Message "Cleaning up downloaded installers."
    Remove-Item $chromeInstallerPath
}

catch {
    # Log the error and display it
    $errorMessage = $_.Exception.Message
    Log-Message "Error: $errorMessage"
    Write-Host "An error occurred: $errorMessage" -ForegroundColor Red
} finally {
    Log-Message "Browser update script completed."
}