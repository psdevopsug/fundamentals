# Understanding the makeup of a cmdlet
# Microsoft uses a standard of Verb-Noun naming for cmdlets

# Lets look at the cmdlets in a installed module
Get-Command -Module AppX

# Lets look at all commands available
Get-Command

# What verbs does Microsoft use
Get-Verb

# Get-Command has a -Verb parameter to help us look for verbs
Get-Command -Verb 'Dismount'

# We can also do it this way - note that this one does not use a parameter name
# but a position
Get-Command 'dismount*'

# if you knew you were looking for a cmdlet that worked with a service you'd try
Get-Command '*service*'

# So if we want look at the services on the computer we could then use Get-Se and press TAB
# <TYPE>

# But what about the parameter's? If we type '-' then press TAB we will cycle through them
# <TYPE>

# But that doesn't explain what the parameters are 
Get-Help

# Wrapper function with pagination
help

# Alias for help
man

# Get help on Get-Service
man Get-Service

# It tells us at the bottom of the screen we need to update help.
# We need to do that in an elevated prompt
# <GO TO CONSOLE>

# Now that help is updated let's try that again
man Get-Service

# Get the detailed help
man Get-Service -Detailed

# Get the examples
man Get-Service -Examples

# Get the FULL help
man Get-Service -Full

# Get the online help
man Get-Service -Online

# The parameter help is very useful
# Also note the 'Common Parameters'
man Get-Service -Full

# If you just want to see the help on a single parameter use it's name
man Get-Service -Parameter 'Name'