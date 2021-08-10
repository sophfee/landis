local meta = FindMetaTable("Player")

function meta:SetupDataTables()
	self:NetworkVar("Bool", 0, "weaponRaised")
	if SERVER then
		//self:SetStamina(5)
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

function meta:IsWeaponRaised()
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

// credit : Jake Green (vin)
// code taken from impulse, PERMISSION NOT FULLY GRANTED, DO NOT USE PUBLICLY!!!!
// !! LEAVE CODE AS COMMENT UNTIL FURTHER NOTICE !!

--[[if SERVER then

	hook.Add("CanPrimaryAttack", "noShootWeaponLowered1", function(self)
		return false //self.Owner:IsWeaponRaised()
	end)

	hook.Add("CanSecondaryAttack", "noShootWeaponLowered22", function(self)
		return false //self.Owner:IsWeaponRaised()
	end)

	function meta:SetWeaponRaised(state)
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

	function meta:ToggleWeaponRaised()
		self:SetWeaponRaised( !self:IsWeaponRaised() )
	end

	hook.Add("PlayerButtonDown", "raise", function(self,btn)
		if btn == KEY_G then
			self:ToggleWeaponRaised()
		end
	end)

end

if CLIENT then

	local loweredAngles = Angle(30, -30, -25)

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
		/*do
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
		end*/

		return vm_origin, vm_angles
	end
end--]]
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