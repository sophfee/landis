-- g_base.chat.commands
g_base.chat.RegisterCommand("/help",{
	RequireAlive    = false,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_USER,
	HelpDescription = "Shows this message.",
	onRun  = function(self,ply,args)
		ply:ChatPrint("========== All Commands ==========")
		for name,command in pairs(g_base.chat.commands) do
			ply:ChatPrint(name .. " - " .. command.HelpDescription)
		end
	end
})