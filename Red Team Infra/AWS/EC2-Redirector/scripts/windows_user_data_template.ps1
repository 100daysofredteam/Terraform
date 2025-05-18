<powershell>

# Enable WSL Feature

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Install Chocolatey

Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


# Install VS Code, Python, .NET SDK
$packages = @("vscode", "python", "dotnet-sdk")

foreach ($pkg in $packages) {
 choco install $pkg -y --no-progress
    } 


</powershell>