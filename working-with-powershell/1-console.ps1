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

