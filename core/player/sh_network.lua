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
-- eChat.CommandColors[PERMISSION_LEVEL_ADMIN] = Color(52,199,89,255)
-- eChat.CommandColors[PERMISSION_LEVEL_LEAD_ADMIN] = Color(88,86,214)

function meta:GetPhysgunColor()
	if self:IsSuperAdmin() then return Vector( 1.00000, .000000, .000000 ) end
	if self:IsLeadAdmin()  then return Vector( .247058, .000000, .498039 ) end
	if self:IsAdmin()      then return Vector( .000000, 1.00000, .258823 ) end
	return nil
end

if SERVER then
	hook.Add("PlayerSpawn","setuphands", function(ply)
		ply:SetupHands()
	end)
	hook.Add("PlayerDeathSound","mutebeep",function() return true end)
end

hook.Add("PlayerSpawn", "SpawnSetColor", function( ply )
	local col = ply:GetPhysgunColor()
	if col then
		ply:SetWeaponColor( col )
	end
end )