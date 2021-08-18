-- landys.chat.commands
landys.chat.RegisterCommand("/me",{
	RequireAlive    = true,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_USER,
	HelpDescription = "Make yourself perform an action",
	onRun  = function(self,ply,args)
		return // not finished, need sv code
	end
})