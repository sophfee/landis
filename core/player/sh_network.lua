local meta = FindMetaTable("Player")

function meta:SetupDataTables()
	self:NetworkVar("Float", 0, "Stamina")
	if SERVER then
		self:SetStamina(5)
	end
end

function meta:GetPermissionLevel()
	if self:IsSuperAdmin() then
		return PERMISSION_LEVEL_SUPERADMIN
	end
	if self:IsAdmin() then
		return PERMISSION_LEVEL_ADMIN
	end
	return PERMISSION_LEVEL_USER
end

if SERVER then 
	util.AddNetworkString("gNotify")

	function meta:Notify(message,duration)
		if not message then return end
		duration = duration or 5
		net.Start("gNotify")
			net.WriteString(message)
			net.WriteInt(duration,32)
		net.Send(self)
	end
end

if CLIENT then
	function meta:Notify(message,duration)
		local panel = vgui.Create("gNotify")
		panel:SetDuration(duration or 5)
		panel:SetMessage(message)
	end
	net.Receive("gNotify", function()
		local message = net.ReadString()
		local duration = net.ReadInt(32)
		LocalPlayer():Notify(message,duration)
	end)
end

if SERVER then
	hook.Add("PlayerSpawn","setuphands", function(ply)
		ply:SetupHands()
	end)
	hook.Add("PlayerDeathSound","mutebeep",function() return true end)
end