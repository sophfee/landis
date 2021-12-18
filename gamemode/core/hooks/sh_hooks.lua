hook.Add("PlayerSpawn", "landisPhysgunColor", function( ply )
	player_manager.SetPlayerClass( ply, "landis_player" )
	local col = ply:GetPhysgunColor()
	if col then
		ply:SetWeaponColor( col )
	end
end )


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