-- Prevent family shared accounts from joining (alt account detection)
function GM:PlayerAuthed(ply,steamID)
	if not (ply:OwnerSteamID64() == ply:SteamID64()) then
		landis.ConsoleMessage("Kicked " .. steamID .. " for joining on a Family Shared account.")
		game.KickID(steamID, "Sorry! Family Shared accounts cannot join.\n\nPlease connect on an account that owns Garry's Mod.")
	end
end

function GM:PlayerSpawn(ply)
	local teamData = landis.Teams.Data[ply:Team()]
	if teamData then
		ply:SetModel(landis.Teams.Data[ply:Team()].Model or "")
	end
	if ply:IsAdmin() then
		ply:Give("weapon_physgun")
	end
	if ply:IsLeadAdmin() then
		ply:Give("gmod_tool")
	end
	ply:Give("landis_hands")
	hook.Run("PlayerLoadout", ply)
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

hook.Add( "PlayerCanHearPlayersVoice", "landisVoice3D", function( listener, talker )
	if not talker:Alive() then return false end
	if listener:GetPos():DistToSqr( talker:GetPos() ) < ((landis.Config.VoiceRange*landis.Config.VoiceRange) or 600*600) then
		return true,true
	end
end )

hook.Add("DoPlayerDeath", "ragdoll_create",function(ply)
	ply:CreateRagdoll()
	ply:SetNWBool("CanRespawn",false)
	timer.Simple(10, function()
		ply:Spawn()
	end)
end)

hook.Add( "PhysgunPickup", "pickupPlayer", function( ply, ent )
	if ( ply:IsAdmin() and ent:IsPlayer() ) then
		ent:SetMoveType(MOVETYPE_NONE)
		//ent:Freeze( true )
		return true
	end
end )
hook.Add("PhysgunDrop", "dropPlayer", function(ply, ent)
	if ent:IsPlayer() then
		//ent:Freeze(false)
		ent:SetMoveType(MOVETYPE_WALK)
	end
end)

hook.Add("PlayerSpawn","landisSetupHands", function(ply)
	ply:SetupHands()
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
	return ply:IsAdmin()
end)

hook.Add("PlayerSpawnRagdoll", "landisSchemaPlayerSpawnRagdoll", function(ply,model)
	if SCHEMA.PlayerSpawnRagdoll then
		return SCHEMA:PlayerSpawnRagdoll(ply,model)
	end
	return ply:IsLeadAdmin()
end)

hook.Add("PlayerSpawnSWEP", "landisSchemaPlayerSpawnSWEP", function(ply,weapon,swep)
	landis.ConsoleMessage(ply," is attempting to spawn a ",weapon," (SWEP)")
	if SCHEMA.PlayerSpawnSWEP then
		return SCHEMA:PlayerSpawnSWEP(ply,weapon,swep)
	end
	return ply:IsSuperAdmin()
end)

hook.Add("PlayerGiveSWEP", "landisSchemaPlayerSpawnSWEP", function(ply,weapon,swep)
	landis.ConsoleMessage(ply," is attempting to give themselves a ",weapon)
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

hook.Add("CheckPassword", "CheckForBan", function(uSteamID64)
	local userData = sql.Query("SELECT * FROM landis_bans WHERE steamid = " .. sql.SQLStr(uSteamID64) .. ";")
	if not userData then return true end
	for _,ban in ipairs(userData) do
		if os.time() < tonumber(ban.end_date) then 
			return false, "uh oh! looks like you're currently banned!\n\nBanned by: " .. ban.moderator .. "\nReason: "..ban.reason.."\nUnban Date: "..os.date("%A, %B %d - %x %X", ban.end_date)  
		end
	end
	return true
end)

hook.Add("PlayerInitialSpawn", "setup_data", function(ply)
	ply:SetupData()
end)


hook.Add("PlayerDisconnected", "save_data", function(ply)
	ply:SaveAllData()
end)

hook.Add("PlayerGiveSWEP","noThumpThump", function(ply,class,swep)
	if class == "ls_thumpthump" then
		return ply:SteamID() == "STEAM_0:1:92733650"
	end
end)

hook.Add("PlayerSpawnSWEP","noThumpThump", function(ply,class,swep)
	if class == "ls_thumpthump" then
		return ply:SteamID() == "STEAM_0:1:92733650"
	end
end)
