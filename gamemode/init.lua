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


hook.Add("PlayerSay", "DiscordWebhook", function(ply,text)
    http.Post("localhost:8080", {})
end)