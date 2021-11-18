local meta = FindMetaTable("Player")

function meta:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsTyping")
	self:NetworkVar("Int",1,"XP")
	self:NetworkVar("Bool",2,"InNoclip")

	if SERVER then
		function self:SetXP( num )
			sql.Query("UPDATE landis_user SET xp = " .. num .. " WHERE steamid = " .. sql.SQLStr( self:SteamID64() ) )
			self:SetNWInt( "XP", num )
		end
	end
end

function meta:InNoclip()
	return self:GetNWBool("InNoclip",false)
end

function meta:GetRankName()
	if self:IsSuperAdmin() then
		return "Super Admin"
	end
	if self:IsLeadAdmin() then
		return "Lead Admin"
	end
	if self:IsAdmin() then
		return "Admin"
	end
	return "User"
end
function meta:GetPermissionLevel()
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

if SERVER then 
	util.AddNetworkString("landisNotify")

	function meta:Notify(message,duration)
		if not message then return end
		duration = duration or 5
		net.Start("landisNotify")
			net.WriteString(message)
			net.WriteInt(duration,32)
		net.Send(self)
	end
end

if CLIENT then
	function meta:Notify(message,duration)
		local panel = vgui.Create("landisNotify")
		panel:SetDuration(duration or 5)
		panel:SetMessage(message)
	end
	net.Receive("landisNotify", function()
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

-- credit : Jake Green (vin)
-- code taken from impulse, PERMISSION NOT FULLY GRANTED, DO NOT USE PUBLICLY!!!! -- oh BTW I got perms dw lmao, just doesnt work well
-- !! LEAVE CODE AS COMMENT UNTIL FURTHER NOTICE !!                               -- proof of permission: https://cdn.discordapp.com/attachments/822883467997872168/896128437939503164/unknown.png

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

function meta:IsTyping()
	return self:GetNWBool("IsTyping",false)
end

if SERVER then
	--meta.LastChatTime = CurTime()
	--meta.DDoSRiskAmmount = 0
	util.AddNetworkString("landisStartChat")
	--util.AddNetworkString("landisFinishChat")
	hook.Add("PlayerSpawn","setuphands", function(ply)
		ply:SetupHands()
	end)
	hook.Add("PlayerDeathSound","mutebeep",function() return true end)
	net.Receive("landisStartChat", function(len,ply)
		--landis.Warn(ply:Nick().. " is sending too many net messages! (Risk Level: "..ply.DDoSRiskAmmount..")")
		--ply:AddChatText(tostring(ply.RiskAmount))
		if (ply.LastChatTime or 0) < CurTime() then
			ply:SetNWBool("IsTyping", true)
		else
			ply.RiskAmount = (ply.RiskAmount or 0) + 1
			landis.Warn(ply:Nick().. " is sending too many net messages!")
			
			if ply.RiskAmount > 15 then
				ply:Kick("NET Overflow Intervention")
			end 
		end
		ply.LastChatTime = CurTime()+0.075
	end)
	function meta:AddChatText(...)
		local t = {...}
		for v,k in ipairs(t) do
			if type(k) == "string" then
				t[v] = "\"" .. k .. "\""
			elseif type(k) == "table" then
				t[v] = "Color("..k.r..","..k.g..","..k.b..")"
			end
		end
		self:SendLua( "chat.AddText(" .. table.concat( t, ", " ) .. ")" )
	end
end

if CLIENT then
	
	function GM:HUDDrawTargetID()
	end
end

hook.Add("PlayerSpawn", "SpawnSetColor", function( ply )
	local col = ply:GetPhysgunColor()
	if col then
		ply:SetWeaponColor( col )
	end
end )