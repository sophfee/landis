if SERVER then
    AddCSLuaFile()
    return
end
include("shared.lua")
ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Landis Item"
ENT.Category  = "landis"
ENT.Spawnable = true
ENT.AdminOnly = true