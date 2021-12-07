hook.Add( "PlayerNoClip", "FeelFreeToTurnItOff", function( ply, desiredState )
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
end )