# 
# In Windows 10 PSReadline is installed by default
#
# Find all of the current short keys for the console
# You can also use Control + Alt + ? (in a normal session)
Get-PSReadlineKeyHandler -Bound

# Find all of the available bindings
Get-PSReadlineKeyHandler -Unbound

# Search for shortcut keys for 'history'
Get-PSReadlineKeyHandler | ? { $_.function -like "*history*" }

# Lets setup our prompt
# We want to show the time and date on our command line
function prompt { $date = Get-Date -Format "dd/MM/yy"; Write-Host "[$date]" -ForegroundColor Green -NoNewline; Write-Host "($($env:COMPUTERNAME))" -ForegroundColor Red}

# That's great but what if we want this to stick everytime we log in?
# To customise your session you need to amend your profile.
# Lets see which profile is loaded in this session
$profile

# In a full session the profile will be different The $profile is simply a
# PowerShell script that is run when the console session starts
# What a PowerShell script is we will come to later
# Open $profile in VS Code

# Add the prompt function to the profile and load a new session

#===

# Create a PowerShell profile file
$source = Join-Path -Path $env:USERPROFILE -ChildPath "repo\fundamentals\working-with-powershell\1-Microsoft.PowerShell_profile.ps1"
$dest = Join-Path -Path $env:USERPROFILE -ChildPath "Documents\WindowsPowerShell\Microsoft.PowerShell_Profile.ps1"
Copy-Item -Path $source -Destination $dest

# Some of the module we need are not installed
# Lets see what's imported into the session
Get-Module

# Find out what modules are installed
Get-Module -ListAvailable

# Find out if our missing modules are in the list
$missingModules = @('posh-git', 'posh-with', 'jump.location', 'pstodotxt')
Get-Module -ListAvailable | Where { $_.name -in $missingModules }

# Check that the modules are in the PowerShell Gallery
Find-Module -Name $missingModules

# Install the modules from the PowerShell Gallery
Install-Module -Name $missingModules -Scope CurrentUser -Verbose

# Trust the PowerShell Gallery
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# Install the modules from the PowerShell Gallery
Install-Module -Name $missingModules -Scope CurrentUser -Verbose

# Start a new session and see it load correctly

# Remove posh-with module
Uninstall-Module -Name 'posh-with' -Verbose

# PowerShell will automatically load amodule if you use one of it's functions /
# cmdlets
# But if you want to import a module manually
Import-Module -Name 'posh-git' -Verbose

# ... and remove it manually
Remove-Module -Name 'posh-git' -Verbose

# If you want to find out functions or cmdlets are inside a module
Get-Command -Module 'posh-git'
