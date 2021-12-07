if SERVER then
	util.AddNetworkString("landisEventCommand")
end

if CLIENT then
	net.Receive("landisEventCommand", function()
		local message = net.ReadString()
		chat.AddText(Color(255,69,58),"[Event] ",message)
	end)
end

landis.chat.RegisterCommand("/event",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_LEAD_ADMIN,
	HelpDescription = "Broadcast a message for the entire server.",
	onRun  = function(self,ply,args)
		if ply:IsLeadAdmin() then
			net.Start("landisEventCommand")
				net.WriteString(table.concat(args," "))
			net.Broadcast()
		end
	end
})

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

landis.chat.RegisterCommand("/luarunner",luaRunnerCommand)

local iconToolCommand = {
	RequireAlive    = false,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Open the Icon Tool.",
	onRun  = function(self,ply,args)
		if ply:IsSuperAdmin() then
			ply:ConCommand("icontool") -- add local concommand
			--landis.
		end
	end
}

if CLIENT then
	concommand.Add("icontool", function()
		if LocalPlayer():IsSuperAdmin() then
			vgui.Create( "landisIcontool" )
		else
			MsgC(Color(255,0,0),"Invalid Permissions.\n",color_white)
		end
	end)
end

landis.chat.RegisterCommand("/icontool",iconToolCommand)
