# File: init-windows.ps1
# Description: Automate Windows updates and install Chocolatey

# Make sure script runs with admin rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You must run this script as Administrator!"
    pause
    exit
}

Write-Host "[+] Checking for and installing Windows Updates..."
Install-Module PSWindowsUpdate -Force -Scope CurrentUser
Import-Module PSWindowsUpdate
Get-WindowsUpdate -AcceptAll -Install -AutoReboot

# Chocolatey install
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "[+] Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "[✓] Chocolatey already installed."
}

# Optional: install common tools
$packages = @(
    'git',
    'notepadplusplus',
    '7zip',
    'python',
    'sysinternals',
    'vscode',
    'wireshark'
)

Write-Host "[+] Installing common tools via Chocolatey..."
foreach ($pkg in $packages) {
    choco install $pkg -y --no-progress
}

Write-Host "`n[✓] Windows environment is now fully set up!"
