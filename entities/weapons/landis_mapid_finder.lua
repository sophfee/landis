AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "MapID Finder"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.Instructions = "Used for development"
    SWEP.Category = "Landis"
end

SWEP.ViewModel = Model("models/weapons/v_hands.mdl")
SWEP.WorldModel	= ""

SWEP.ViewModelFOV = 0
SWEP.ViewModelFlip = false
SWEP.HoldType = "normal"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:PrimaryAttack()
    if CLIENT then
        return
    end
    self:SetNextPrimaryFire(0.2)
	local ply = self.Owner
	local tr = ply:GetEyeTrace()
	if tr.Hit then
		local ent = tr.Entity
		if IsValid(ent) then
			ply:AddChatText("Map Creation ID: " .. ent:MapCreationID() .. " | " .. ent:GetClass())
            ply:SendLua("SetClipboardText(\"" .. ent:MapCreationID() .. "\")")
		end
	end
end