util.AddNetworkString("ragdoll_camera")

function GM:PlayerSpawn(ply)
	ply:SetModel("models/player/Group01/male_06.mdl")
	if ply:IsAdmin() then
		ply:Give("weapon_physgun")
	end
	if ply:IsLeadAdmin() then
		ply:Give("gmod_tool")
	end
	ply:Give("landis_hands")
end

hook.Add("DoPlayerDeath", "ragdoll_create",function(ply)
	ply:CreateRagdoll()
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

util.AddNetworkString("landis_RequestTeamJoin")

net.Receive("landis_RequestTeamJoin", function(len,ply)
	local teamIndex = net.ReadInt(32)
	if teamIndex then
		local limit = landis.Teams.Data[teamIndex].Limit
		if limit then
			if #team.GetPlayers(teamIndex) < limit then
				hook.Run("PlayerJoinTeam", ply, teamIndex)
			end
		else
			hook.Run("PlayerJoinTeam", ply, teamIndex)
		end
	end
end)