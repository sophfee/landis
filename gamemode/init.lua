MsgC(Color(10,132,255),"[landis] Initializing core elements...\n")
RunConsoleCommand("mp_falldamage","1")
-- Just a little badge file, nothing special
resource.AddSingleFile("materials/badges/smile.png") -- any smilers?
AddCSLuaFile("shared.lua")
include("shared.lua")
