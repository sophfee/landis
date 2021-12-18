AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Loot Container"

ENT.Category  = "landis"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.name      = "Lootable Container"
ENT.desc      = "Sometimes some materials and gear can appear here."

ENT.Loot      = {}

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "ContainerType")
end