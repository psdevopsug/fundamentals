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