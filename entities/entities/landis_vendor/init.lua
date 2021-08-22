AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

print("init lua ran!")

function ENT:Initialize()
	self:SetModel( Model("models/mossman.mdl") )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSequence(2)
end