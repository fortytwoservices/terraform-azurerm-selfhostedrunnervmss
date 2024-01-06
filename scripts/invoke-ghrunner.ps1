# v0.1.0
# Define parameters
param (
    [string]$runnerscope,
    [string]$runnergroup,
    [string]$user,
    [string]$userpassword,
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
$runnerurl = "https://github.com/$runnerscope"

# Unzip archive *.zip
Expand-Archive -Path "C:\ProgramData\runner\actions-runner-win-x64-*.zip" -DestinationPath "C:\ProgramData\runner"

# Initialize the argument list with mandatory arguments
$argList = @("--unattended", "--url", $runnerurl, "--pat", $githubpat, "--WindowsLogonAccount", $user, "--WindowsLogonPassword", $userpassword, "--runasservice")

# Add optional arguments based on conditions
if ($null -eq $replace || $replace) {
    $argList += "--replace"
}
if ($null -ne $labels) {
    $argList += "--labels"
    $argList += $labels
}
if ($null -ne $runner_group) {
    $argList += "--runnergroup"
    $argList += $runner_group
}
if ($null -eq $disableupdate || $disableupdate) {
    $argList += "--disableupdate"
}
if ($null -ne $ephemeral) {
    $argList += "--ephemeral"
}

# Run the config.cmd script with the argument list
Start-Process -FilePath .\config.cmd -ArgumentList $argList -NoNewWindow -Wait

#Get-ChildItem C:\post-generation -Filter *.ps1 | ForEach-Object { & $_.FullName }

# Run command config.cmd
# & .\config.cmd --unattended --url $runnerurl --pat $githubpat --WindowsLogonAccount $user --WindowsLogonPassword $userpassword --replace --disableupdate --runasservice

# Start service
Start-Service actions.runner.*
