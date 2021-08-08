-- g.chat.commands
g.chat.RegisterCommand("/me",{
	RequireAlive    = true,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_USER,
	HelpDescription = "Make yourself perform an action",
	onRun  = function(self,ply,args)
		ply:ChatPrint("========== All Commands ==========")
		for name,command in pairs(g.chat.commands) do
			ply:ChatPrint(name .. " - " .. command.HelpDescription)
		end
	end
})