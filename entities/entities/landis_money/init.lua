AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:SetMoneyA(amt)
    self:SetNWInt("Money",amt)
    self:SetNWString("DisplayName","Money")
    self:SetNWString("Description",amt .. " Credits")
end
function ENT:Initialize()
	self:SetModel( Model("models/props/cs_assault/money.mdl") )
    self:SetUseType(SIMPLE_USE)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetMoneyA(50)
end

function ENT:Think()
end

function ENT:Use(caller)
	if IsValid(caller) then
		if caller:IsPlayer() then
			caller:SetNWInt("Money",caller:GetNWInt("Money",0) + self:GetMoney())
            self:Remove()
		end
	end
end