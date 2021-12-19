hook.Add("PlayerSpawn", "landisPhysgunColor", function( ply )
	player_manager.SetPlayerClass( ply, "landis_player" )
	local col = ply:GetPhysgunColor()
	if col then
		ply:SetWeaponColor( col )
	end
end )

function GM:PlayerSpawn( ply )
	if CLIENT then return end
	local teamData = landis.Teams.Data[ply:Team()]
	ply:SetHunger(60)
	ply:EditRPName(ply:GetSyncRPName(),true) -- Save process time by skipping sync process since you are fetching from DB
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

function GM:StartCommand(ply,cmd)
	if not ply:IsWeaponRaised() then
		cmd:RemoveKey(IN_ATTACK+IN_ATTACK2)
	end
end

function GM:OnReloaded()
	landis.Reload()
end

function GM:PlayerFootstep(ply,pos,foot,sound)
	if SCHEMA.PlayerFootstep then
		SCHEMA:PlayerFootstep(ply,pos,foot,sound)
		return true
	end
end