local PLAYER = FindMetaTable("Player")

function PLAYER:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsTyping")
	self:NetworkVar("Int",1,"XP")
	self:NetworkVar("Bool",2,"InNoclip")
end

function PLAYER:InNoclip()
	return self:GetNWBool("InNoclip",false)
end

function PLAYER:GetRankName()
  
	if self:IsSuperAdmin() then
		return "Community Manager"
	end
	if self:IsLeadAdmin() then
		return "Lead Admin"
	end
	if self:IsAdmin() then
		return "Admin"
	end
	return "User"
end
function PLAYER:GetPermissionLevel()
	if self:IsSuperAdmin() then
		return PERMISSION_LEVEL_SUPERADMIN
	end
	if self:IsLeadAdmin() then
		return PERMISSION_LEVEL_LEAD_ADMIN
	end
	if self:IsAdmin() then
		return PERMISSION_LEVEL_ADMIN
	end
	return PERMISSION_LEVEL_USER
end

function PLAYER:IsWeaponRaised()
	local weapon = self:GetActiveWeapon()

	if IsValid(weapon) then
		if weapon.IsAlwaysRaised or false then
			return true
		elseif weapon.IsAlwaysLowered then
			return false
		end
	end

	return self:GetNWBool("weaponRaised", true)
end
