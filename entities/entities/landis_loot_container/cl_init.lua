if SERVER then
  AddCSLuaFile()
  return
end

include("shared.lua")

ENT.Base      = "base_gmodentity"
ENT.Type      = "anim"
ENT.PrintName = "Loot Container"
ENT.Category  = "landis"
ENT.name      = "Lootable Container"
ENT.desc      = "Sometimes some materials and gear can appear here."