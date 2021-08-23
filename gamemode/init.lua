MsgC(Color(10,132,255),[[
//////////////////////////////////
            _                    
           | |                   
   __ _    | |__   __ _ ___  ___ 
  / _` |   | '_ \ / _` / __|/ _ \
 | (_| |   | |_) | (_| \__ \  __/
  \__, |   |_.__/ \__,_|___/\___|
   __/ |_____                    
  |___/______|                  

//////////////////////////////////

  g_base is a framework for gmod

//////////////////////////////////
]])

resource.AddSingleFile("materials/badges/smile.png")

AddCSLuaFile("shared.lua")
include("shared.lua")

-- dev Branch stats & ver data
local root = GM.FolderName
local b = file.Open( "gamemodes/landis/.git/FETCH_HEAD", "r", "MOD" ):ReadLine()
local branchID = "hi"
local spl = string.Split(b, " ")
spl[3] = string.gsub(spl[3], "of https://github.com/urnotnick/landys", "")
spl[3] = string.Trim(spl[3])
SetGlobalString(1, string.sub(spl[1],1,7))
SetGlobalString(2, spl[3])

hook.Add("PlayerSay", "DiscordWebhook", function(ply,text)
    http.Post("localhost:8080", {})
end)