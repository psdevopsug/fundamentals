#region Variables Definitions

# Console Colours - https://social.technet.microsoft.com/Forums/windowsserver/en-US/4b43f071-abf5-4a65-9048-82d474473a8e/how-can-i-set-the-powershell-console-background-color-not-the-text-background-color?forum=winserverpowershell
$bckgrnd = 'Black'
$Host.UI.RawUI.BackgroundColor = $bckgrnd
$Host.UI.RawUI.ForegroundColor = 'White'
$Host.PrivateData.ErrorForegroundColor = 'Red'
$Host.PrivateData.ErrorBackgroundColor = $bckgrnd
$Host.PrivateData.WarningForegroundColor = 'Magenta'
$Host.PrivateData.WarningBackgroundColor = $bckgrnd
$Host.PrivateData.DebugForegroundColor = 'Yellow'
$Host.PrivateData.DebugBackgroundColor = $bckgrnd
$Host.PrivateData.VerboseForegroundColor = 'Green'
$Host.PrivateData.VerboseBackgroundColor = $bckgrnd
$Host.PrivateData.ProgressForegroundColor = 'Cyan'
$Host.PrivateData.ProgressBackgroundColor = $bckgrnd
Clear-Host
Write-Host 'Importing All_Profiles.ps1...' -foregroundcolor Yellow

#endregion

#region Update Module Path

# Add the PowerShell module paths to PowerShell Core
if ($PSVersionTable.PSEdition -eq "Core") {
    [Environment]::SetEnvironmentVariable("PSModulePath", `
            "$($env:PSModulePath);$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules")
}

#endregion

#region Import Modules

# we need to explicity load the jump.location module as we use it's alias which doesn't auto-load it
if ($PSVersionTable.PSEdition -eq 'Core') {
    $loadModules = @('posh-git', 'pspaubytoolkit', 'posh-with')
}
else {
    $loadModules = @('posh-git', 'pspaubytoolkit', 'jump.location', 'posh-with')    
}

$loadModules | % { 
    Write-Host "Importing module: $_" -ForegroundColor Yellow
    import-module $_
}

#endregion

#region Profile Functions

# http://serverfault.com/questions/95431
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function prompt {
    # https://github.com/dahlbyk/posh-git/wiki/Customizing-Your-PowerShell-Prompt
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host

    # Reset color, which can be messed up by Enable-GitColors
    #   $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    if (Test-Administrator) {
        # Use different username if elevated
        Write-Host "(Elevated) " -NoNewline -ForegroundColor White
    }

    if ($PSVersionTable.PSEdition -eq 'Core') {
        Write-Host '(Core) ' -NoNewline
    }
    write-host "[" -noNewLine
    write-host $(get-date -format "dd/MM hh:mm") -foreground yellow -noNewLine
    write-host "] [" -noNewLine
    Write-Host "$ENV:USERNAME@" -NoNewline -ForegroundColor DarkYellow
    Write-Host "$ENV:COMPUTERNAME" -NoNewline -ForegroundColor Magenta
    write-host "]" -noNewLine

    if ($s -ne $null) {
        # color for PSSessions
        Write-Host " (`$s: " -NoNewline -ForegroundColor DarkGray
        Write-Host "$($s.Name)" -NoNewline -ForegroundColor Yellow
        Write-Host ") " -NoNewline -ForegroundColor DarkGray
    }
	
    Write-VcsStatus

    Write-Host " " -NoNewline
    #    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host $($(Get-Location) -replace ($env:USERPROFILE).Replace('\', '\\'), "~") -NoNewline -ForegroundColor Cyan
    #    Write-Host " : " -NoNewline -ForegroundColor DarkGray

    $global:LASTEXITCODE = $realLASTEXITCODE

    Write-Host ""

    return "> "
}

function remove-function ($name) {
    # removes a function from the environment
    remove-item function:$name
}

#endregion Profile Functions

#region Aliases

# Coloured directory listing
Import-Module Get-ChildItemColor
 
Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope

# the , at ,@( is only required if we only have one member of the array. Keep this comment here.
@(
    @("npp", "$env:SystemDrive\Program Files\Notepad++\notepad++.exe"),
    @("vscode", (Join-Path -Path ${env:ProgramFiles} -ChildPath 'Microsoft VS Code\code.exe'))
) | foreach {
    New-Alias -Name $_[0] -Value $_[1]
}

#endregion


# Start a transcript
$Host.PrivateData.ErrorForegroundColor = "Green"
$PSLogPath = ("{0}{1}\Documents\WindowsPowerShell\log\{2:yyyyMMdd}-{3}.log" -f $env:HOMEDRIVE, $env:HOMEPATH, (Get-Date), $PID)
New-Item -Path (Split-Path -Path $PSLogPath -Parent) -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
Add-Content -Value "# $(Get-Date) $env:username $env:computername" -Path $PSLogPath
Add-Content -Value "# $(Get-Location)" -Path $PSLogPath

Write-Host "Transcript started (log $PSLogPath)`n" -foreground green

#region PoshTodo Stuff

$todoConfig = @{
    'todoTaskFile' = $env:TODO_TASK;
    'todoDoneFile' = $env:TODO_DONE;
}

#endregion PoshTodo Stuff