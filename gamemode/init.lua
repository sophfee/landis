MsgC(Color(10,132,255),"[landis] Initializing core elements...\n")

-- Just a little badge file, nothing special
resource.AddSingleFile("materials/badges/smile.png")

INCLUDE_VERSION_DATA = false -- Keep off unless you have the git cloned!

if INCLUDE_VERSION_DATA then
local root = GM.FolderName
local b = file.Open( "gamemodes/landis/.git/FETCH_HEAD", "r", "MOD" ):ReadLine()
local branchID = "hi"
local spl = string.Split(b, " ")
spl[3] = string.gsub(spl[3], "of https://github.com/urnotnick/landys", "")
spl[3] = string.Trim(spl[3])

SetGlobalString(1, string.sub(spl[1],1,7))
SetGlobalString(2, spl[3])
end

AddCSLuaFile("shared.lua")
include("shared.lua")

