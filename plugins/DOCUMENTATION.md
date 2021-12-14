# THIS MIGHT BE OUTDATED!!!!
# Plugins & How they work

# What are plugins?
- plugins are code that are automatically ran after all other core code has ran.

# How do they work
- Plugins work as any other code in gLua, however they are able to inherit and extend the core functionality

# Single Script Documentation

# Chat

# landis.RegisterChatCommand(className,struct)
- Registers a new chat command

- className
* The text you input into your chatbox to run the command
	- must start with /

- struct
* Class Setup
	- RequiresArgs
		- does this function require arguments to run
	- RequiresAlive
		- does the caller need to be alive to run this command
	- PermissionLevel
		- Use the Enum for permission level
			1. PERMISSION_LEVEL_USER
			2. PERMISSION_LEVEL_ADMIN
			3. PERMISSION_LEVEL_SUPERADMIN
