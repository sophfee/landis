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
	hook.Add("PlayerSpawn","setuphands", function(ply)
		ply:SetupHands()
	end)
	hook.Add("PlayerDeathSound","mutebeep",function() return true end)
end