# v0.1.0
# Define parameters
param (
    [string]$runnerscope,
    [string]$runnergroup,
    [string]$user,
    [string]$userpassword,
    [string]$labels,
    [switch]$noreplace,
    [switch]$enableupdate,
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

Set-Location -Path "C:\ProgramData\runner"
$runnerurl = "https://github.com/$runnerscope"

Expand-Archive -Path "C:\ProgramData\runner\actions-runner-win-x64-*.zip" -DestinationPath "C:\ProgramData\runner"

# Build the argument list and configure the Github Actions Runner
$argList = @("--unattended", "--url", $runnerurl, "--pat", $githubpat, "--WindowsLogonAccount", $user, "--WindowsLogonPassword", $userpassword, "--runasservice")

if ($null -eq $noreplace) {
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
if ($null -eq $enableupdate) {
    $argList += "--disableupdate"
}
if ($null -ne $ephemeral) {
    $argList += "--ephemeral"
}

Start-Process -FilePath .\config.cmd -ArgumentList $argList -NoNewWindow -Wait

# Added to follow recommendations in https://github.com/actions/runner-images/blob/main/docs/create-image-and-azure-resources.md#post-generation-scripts
$securePassword = ConvertTo-SecureString $userpassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $user, $securePassword
Start-Process Notepad.exe -Credential $credential

Get-ChildItem C:\post-generation -Filter *.ps1 | ForEach-Object { Start-Process $_.FullName -Credential $credential }

# Starting the Github Actions Runner service
Start-Service actions.runner.*
