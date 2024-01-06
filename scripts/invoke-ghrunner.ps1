# v0.1.0
# Define parameters
param (
    [string]$runnerscope,
    [string]$runnergroup,
    [string]$user,
    [string]$labels,
    [switch]$replace,
    [switch]$disableupdate,
    [switch]$ephemeral,
    [string]$githubpat = $env:RUNNER_CFG_PAT
)

# Change directory
# Set-Location -Path "C:\Users\$user"

# Create the service file
# $scriptContent = @'
# Test
# '@

# Set-Content -Path create-latest-svc.ps1 -Value $scriptContent

# Change to runner under programdata
Set-Location -Path "C:\ProgramData\runner"

# Unzip archive *.zip
Expand-Archive -Path "C:\ProgramData\runner\actions-runner-win-x64-*.zip" -DestinationPath "C:\ProgramData\runner"

# Run command config.cmd
& .\config.cmd --unattended --url $runnerscope --pat $githubpat --labels $labels --replace $replace --disableupdate $disableupdate --ephemeral $ephemeral --runasservice

# Start service
Start-Service actions.runner.*
