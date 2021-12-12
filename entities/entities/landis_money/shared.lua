AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Landis Money"
ENT.Category  = "landis"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"Money")
	self:NetworkVar("String",1,"DisplayName")
	self:NetworkVar("String",2,"Description")
end