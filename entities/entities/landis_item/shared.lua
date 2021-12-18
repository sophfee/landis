AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Item"
ENT.Category  = "landis"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"ItemClass")
	self:NetworkVar("String",1,"DisplayName")
	self:NetworkVar("String",2,"Description")
end