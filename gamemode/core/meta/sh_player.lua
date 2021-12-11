local PLAYER = FindMetaTable("Player")

function PLAYER:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsTyping")
	self:NetworkVar("Bool",1,"InNoclip")
	self:NetworkVar("Int",2,"XP")
	self:NetworkVar("String",3,"RPName")
end

PLAYER.Inventory = {}

--- [INTERNAL] Setup player inventory.
-- [INTERNAL] Sets up inventory.
function PLAYER:SetupInventory()
	self.Inventory = {}
end

function PLAYER:Weight()
	local weight = 0
	for v,k in ipairs(self.Inventory) do
		local item = landis.items.data[k.UniqueID]
		weight = weight + item.weight
	end
	return weight
end

--- Can pickup item.
-- monkey nuts.
-- @param item Item that the user wants to pickup.
function PLAYER:CanPickupItem( item )
	local item = landis.items.data[item] or error()
	local weight = self:Weight()
	return !(weight + item.weight > 20)
end

function PLAYER:GetRPName()
	return self:GetNWString("RPName",self:Nick())
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

	return self:GetNWBool("weaponRaised", false)
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

function PLAYER:GetPhysgunColor()
	if self:IsSuperAdmin() then return Vector( 1.00000, .000000, .000000 ) end
	if self:IsLeadAdmin()  then return Vector( .247058, .000000, .498039 ) end
	if self:IsAdmin()      then return Vector( .000000, 1.00000, .258823 ) end
	return nil
end

function PLAYER:IsTyping()
	return self:GetNWBool("IsTyping",false)
end


-- credit : Jake Green (vin)
-- code taken from impulse, PERMISSION NOT FULLY GRANTED, DO NOT USE PUBLICLY!!!! -- oh BTW I got perms dw lmao, just doesnt work well
-- !! LEAVE CODE AS COMMENT UNTIL FURTHER NOTICE !!                               -- proof of permission: https://cdn.discordapp.com/attachments/822883467997872168/896128437939503164/unknown.png

if SERVER then

	hook.Add("CanPrimaryAttack", "noShootWeaponLowered1", function(self)
		return false //self.Owner:IsWeaponRaised()
	end)

	hook.Add("CanSecondaryAttack", "noShootWeaponLowered22", function(self)
		return false //self.Owner:IsWeaponRaised()
	end)

	hook.Add("PlayerSwitchWeapon", "landisLowerWeapon",function(ply)
		ply:SetWeaponRaised(false)
	end)

	function PLAYER:SetWeaponRaised(state)
		self:SetNWBool("weaponRaised", state)

		local weapon = self:GetActiveWeapon()

		if IsValid(weapon) then
			weapon:SetNextPrimaryFire(CurTime() + 0.25)
			weapon:SetNextSecondaryFire(CurTime() + 0.25)

			if weapon.OnLowered then
				weapon:OnLowered()
			end
		end
	end

	function PLAYER:ToggleWeaponRaised()
		self:SetWeaponRaised( !self:IsWeaponRaised() )
	end

	hook.Add("PlayerButtonDown", "raise", function(self,btn)
		if btn == KEY_G then
			self:ToggleWeaponRaised()
		end
	end)

end

if CLIENT then

	local loweredAngles = Angle(17, -17, -8)

	function GM:CalcViewModelView(weapon, viewmodel, oldEyePos, oldEyeAng, eyePos, eyeAngles)
		if not IsValid(weapon) then return end

		local vm_origin, vm_angles = eyePos, eyeAngles

		do
			local lp = LocalPlayer()
			local raiseTarg = 0

			if !lp:IsWeaponRaised() then
				raiseTarg = 500
			end

			local frac = (lp.raiseFraction or 0) / 500
			local rot = weapon.LowerAngles or loweredAngles

			vm_angles:RotateAroundAxis(vm_angles:Up(), rot.p * frac)
			vm_angles:RotateAroundAxis(vm_angles:Forward(), rot.y * frac)
			vm_angles:RotateAroundAxis(vm_angles:Right(), rot.r * frac)

			lp.raiseFraction = Lerp(FrameTime() * 5, lp.raiseFraction or 0, raiseTarg)
		end

		--The original code of the hook.
		do
			local func = weapon.GetViewModelPosition
			if (func) then
				local pos, ang = func( weapon, eyePos*1, eyeAngles*1 )
				vm_origin = pos or vm_origin
				vm_angles = ang or vm_angles
			end

			func = weapon.CalcViewModelView
			if (func) then
				local pos, ang = func( weapon, viewModel, oldEyePos*1, oldEyeAngles*1, eyePos*1, eyeAngles*1 )
				vm_origin = pos or vm_origin
				vm_angles = ang or vm_angles
			end
		end

		return vm_origin, vm_angles
	end
end

function PLAYER:GetTeamData()
	return landis.Teams.Data[self:Team()]
end

function PLAYER:GetLoadout()
	return self:GetTeamData().loadout or nil
end

local adminGroups = {
    ["admin"] = true,
    ["leadadmin"] = true
}

function PLAYER:IsLeadAdmin()
    return self:IsUserGroup("leadadmin") or self:IsSuperAdmin()
end

function PLAYER:IsAdmin()
    if self:IsSuperAdmin() then
        return true
    end
    
    if adminGroups[self:GetUserGroup()] then
        return true
    end

    return false
end
