local math = math
local clamp = math.Clamp
local floor = math.floor

-- Prevent family shared accounts from joining (alt account detection)
function GM:PlayerAuthed(ply,steamID)
	if not (ply:OwnerSteamID64() == ply:SteamID64()) then
		landis.ConsoleMessage("Kicked " .. steamID .. " for joining on a Family Shared account.")
		game.KickID(steamID, "Sorry! Family Shared accounts cannot join.\n\nPlease connect on an account that owns Garry's Mod.")
	end
end

function GM:CanDrive()
	return false
end

function GM:PlayerSpawn(ply)
	local teamData = landis.Teams.Data[ply:Team()]
	ply:SetHunger(60)
	ply:SetRPName(ply:GetSyncRPName(),true) -- Save process time by skipping sync process since you are fetching from DB
	ply:SetRunSpeed(200)
	ply:SetWalkSpeed(118)
	ply:SetSlowWalkSpeed(70)
	ply:SetDuckSpeed(0.2)
	if teamData then
		ply:SetModel(landis.Teams.Data[ply:Team()].Model or "")
	end
	ply:Give("weapon_physgun")
	ply:Give("gmod_tool")
	ply:Give("landis_hands")
	hook.Run("PlayerLoadout", ply)
end
function GM:PlayerSetHandsModel( ply, ent )
	local teamData = ply:GetTeamData()
	if teamData then
		do
			if teamData.Hands then
				ent:SetModel(teamData.Hands)
				return
			end
		end
	end
   local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
   local info = player_manager.TranslatePlayerHands(simplemodel)
   if info then
      ent:SetModel(info.model)
      ent:SetSkin(info.skin)
      ent:SetBodyGroups(info.body)
   end
end
hook.Add("PlayerSetHandsModel","landisManualHands",function(ply,ent)
	
end)

function GM:PlayerDeathThink()
	return false
end

function GM:PlayerPostThink(ply)
	ply.HungerTick = ply.HungerTick or CurTime()
	if CurTime() > ply.HungerTick then
		ply:SetHunger(clamp(ply:GetHunger()-1,0,100))
		ply.HungerTick = CurTime() + landis.Config.HungerInterval
	end
end

hook.Add("PlayerNoClip", "landisNoclip", function(ply, desiredState)
	if ( desiredState == false ) then -- the player wants to turn noclip off
		ply:RemoveEffects(EF_NODRAW)
		ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		ply:GodDisable()
		ply:SetNWBool("InNoclip",false)
		return true -- always allow
	elseif ( ply:IsAdmin() ) then
		ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		ply:AddEffects(EF_NODRAW)
		ply:GodEnable()
		ply:SetNWBool("InNoclip",true)
		return true -- allow administrators to enter noclip
	end
end)

function GM:PlayerCanSeePlayersChat( _, __, listener, talker )
	if not talker:Alive() then return false end
	if listener:GetPos():DistToSqr( talker:GetPos() ) < ((landis.Config.VoiceRange*landis.Config.VoiceRange) or 600*600) then
		return true,true
	end
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	if not talker:Alive() then return false end
	if listener:GetPos():DistToSqr( talker:GetPos() ) < ((landis.Config.VoiceRange*landis.Config.VoiceRange) or 600*600) then
		return true,true
	end
end

hook.Add("DoPlayerDeath", "landisRagdollCreate",function(ply)
	ply:CreateRagdoll()
	ply:SetNWBool("CanRespawn",false)
	timer.Simple(10, function()
		ply:Spawn()
	end)
end)

hook.Add( "PhysgunPickup", "landisPickupPlayer", function( ply, ent )
	if ( ply:IsAdmin() and ent:IsPlayer() ) then
		ent:SetMoveType(MOVETYPE_NONE)
		return true
	end
end )
hook.Add("PhysgunDrop", "landisDropPlayer", function(ply, ent)
	if ent:IsPlayer() then
		ent:SetMoveType(MOVETYPE_WALK)
	end
end)

hook.Add("PlayerSpawn","landisSetupHands", function(ply)
	ply:SetupHands()
	ply:SetTeam(1)
end)

hook.Add("PlayerDeathSound","landisMuteDeathsound",function() return true end)

hook.Add("landisOpenVendor", "landisBasicVendorFunc", function(ply,ent,class)
	local ven = landis.GetVendor(class)
	if ven then
		if ven.Behavior == "basic" then

			net.Start( "landisVendorOpen" )

				net.WriteEntity( ent ) -- Entity Reference
				net.WriteString( class or "example_vendor" ) -- Vendor Class
				net.WriteTable( ven ) -- vendor data

			net.Send( ply )

		elseif ven.Behavior == "merchant" then
			net.Start( "landisVendorOpen" )

				net.WriteEntity( ent ) -- Entity Reference
				net.WriteString( class or "example_vendor" ) -- Vendor Class
				net.WriteTable( ven ) -- vendor data

			net.Send( ply )
		end
	end
end)

hook.Add("PlayerSpawnNPC", "landisSchemaSpawnNPC", function(ply,npc_type,weapon)
	if SCHEMA.PlayerSpawnNPC then
		return SCHEMA:PlayerSpawnNPC(ply,npc_type,weapon)
	end
	return ply:IsLeadAdmin()
end)

hook.Add("PlayerSpawnProp", "landisSchemaPlayerSpawnProp", function(ply,model)
	if SCHEMA.PlayerSpawnProp then
		return SCHEMA:PlayerSpawnProp(ply,model)
	end
	return true
end)

hook.Add("PlayerSpawnEffect", "landisSchemaPlayerSpawnEffect", function(ply,model)
	if SCHEMA.PlayerSpawnEffect then
		return SCHEMA:PlayerSpawnEffect(ply,model)
	end
	return ply:IsAdmin()
end)

hook.Add("PlayerSpawnSENT", "landisSchemaPlayerSpawnSENT", function(ply,sent)
	if SCHEMA.PlayerSpawnSENT then
		return SCHEMA:PlayerSpawnSENT(ply,sent)
	end
	return ply:IsSuperAdmin()
end)

hook.Add("PlayerSpawnVehicle", "landisSchemaPlayerSpawnVehicle", function(ply,veh)
	if SCHEMA.PlayerSpawnVehicle then
		return SCHEMA:PlayerSpawnVehicle(ply,veh)
	end
	return ply:IsSuperAdmin()
end)

hook.Add("PlayerSpawnRagdoll", "landisSchemaPlayerSpawnRagdoll", function(ply,model)
	if SCHEMA.PlayerSpawnRagdoll then
		return SCHEMA:PlayerSpawnRagdoll(ply,model)
	end
	return ply:IsLeadAdmin()
end)

hook.Add("PlayerSpawnSWEP", "landisSchemaPlayerSpawnSWEP", function(ply,weapon,swep)
	landis.ConsoleMessage(ply:Nick().." is attempting to spawn a "..weapon.." (SWEP)")
	if SCHEMA.PlayerSpawnSWEP then
		return SCHEMA:PlayerSpawnSWEP(ply,weapon,swep)
	end
	return ply:IsSuperAdmin()
end)

hook.Add("PlayerGiveSWEP", "landisSchemaPlayerSpawnSWEP", function(ply,weapon,swep)
	landis.ConsoleMessage(ply:Nick() .. " is attempting to give themselves a " .. weapon)
	if SCHEMA.PlayerGiveSWEP then
		return SCHEMA:PlayerGiveSWEP(ply,weapon,swep)
	end
	return ply:IsSuperAdmin()
end)

util.AddNetworkString("landisStartMenu")

hook.Add("PlayerInitialSpawn", "landisStartMenu", function(ply,transition)
	net.Start("landisStartMenu")
		net.WriteBool(transition)
	net.Send(ply)
end)

hook.Add("CheckPassword", "landisCheckForBan", function(uSteamID64)
	local userData = sql.Query("SELECT * FROM landis_bans WHERE steamid = " .. sql.SQLStr(uSteamID64) .. ";")
	if userData then
		for _,ban in ipairs(userData) do
			if os.time() < tonumber(ban.end_date) then 
				return false, "uh oh! looks like you're currently banned!\n\nBanned by: " .. ban.moderator .. "\nReason: "..ban.reason.."\nUnban Date: "..os.date("%A, %B %d - %x %X", ban.end_date)  
			end
		end
	end
end)

hook.Add("PlayerInitialSpawn", "landisSetupData", function(ply)
	ply:SetupData()
end)


hook.Add("PlayerDisconnected", "landisSaveData", function(ply)
	ply:SaveAllData()
end)
