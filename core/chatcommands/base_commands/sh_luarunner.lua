local luaRunnerCommand = {
	RequireAlive    = false,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Open the Lua Runner.",
	onRun  = function(self,ply,args)
		if ply:IsSuperAdmin() then
			ply:ConCommand("luarunner")
		end
	end
}
landys.chat.RegisterCommand("/luarunner",luaRunnerCommand)

local iconToolCommand = {
	RequireAlive    = false,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Open the Icon Tool.",
	onRun  = function(self,ply,args)
		if ply:IsSuperAdmin() then
			ply:ConCommand("icontool") -- add local concommand
		end
	end
}

if CLIENT then
	concommand.Add("icontool", function()
		if LocalPlayer():IsSuperAdmin() then
			vgui.Create( "landysIcontool" )
		else
			MsgC(Color(255,0,0),"Invalid Permissions.\n",color_white)
		end
	end)
end

landys.chat.RegisterCommand("/icontool",iconToolCommand)