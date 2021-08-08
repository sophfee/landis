-- g.chat.commands

if SERVER then
	util.AddNetworkString("eventCommand")
end

if CLIENT then
	net.Receive("eventCommand", function()
		local message = net.ReadString()
		chat.AddText(Color(255,69,58),"[Event] ",message)
	end)
end

g.chat.RegisterCommand("/event",{
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Shows this message.",
	onRun  = function(self,ply,args)
		if ply:IsSuperAdmin() then
			net.Start("eventCommand")
				net.WriteString(table.concat(args," "))
			net.Broadcast()
		end
	end
})