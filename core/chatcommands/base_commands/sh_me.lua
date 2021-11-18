-- landis.chat.commands
landis.chat.RegisterCommand("/me",{
	RequireAlive    = true,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_USER,
	HelpDescription = "Make yourself perform an action",
	onRun  = function(self,ply,args)
		for v,k in ipairs(player.GetHumans()) do
			if hook.Run("PlayerCanSeePlayersChat", "ME_MESSAGE", false, k, ply) then
				k:AddChatText(Color(255,200,40),ply:Nick()," ",table.concat(args," "))
			end
		end
	end
})