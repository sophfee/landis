AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Hands"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.Instructions = [[Your bare hands.]]
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

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	self:SetNextPrimaryFire(CurTime() + 0.4)
	local ply = self.Owner
	local tr = ply:GetEyeTrace()
	if tr.Hit then
		local ent = tr.Entity
		if IsValid(ent) then
			if ent:IsDoor() then
				if ply:CanLockDoor(ent) then
					ent:Fire("Lock")
					ent:EmitSound(Sound("doors/latchunlocked1.wav"))
				else
					local r = math.random(0,1)
					if r == 0 then
						ent:EmitSound(Sound("physics/wood/wood_crate_impact_hard2.wav"))
						return
					end
					ent:EmitSound(Sound("physics/wood/wood_crate_impact_hard3.wav"))
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	self:SetNextSecondaryFire(CurTime() + 0.4)
	local ply = self.Owner
	local tr = ply:GetEyeTrace()
	if tr.Hit then
		local ent = tr.Entity
		if IsValid(ent) then
			if ent:IsDoor() then
				if ply:CanLockDoor(ent) then
					ent:Fire("Unlock")
					if ent:GetClass() == "func_door" then
						ent:Fire("Open")
					end
					ent:EmitSound(Sound("doors/latchunlocked1.wav"))
				else
					local r = math.random(0,1)
					if r == 0 then
						ent:EmitSound(Sound("physics/wood/wood_crate_impact_hard2.wav"))
						return
					end
					ent:EmitSound(Sound("physics/wood/wood_crate_impact_hard3.wav"))
				end
			end
		end
	end
end