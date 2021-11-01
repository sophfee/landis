hook.Add( "PlayerNoClip", "FeelFreeToTurnItOff", function( ply, desiredState )
	if ( desiredState == false ) then -- the player wants to turn noclip off
		ply:SetNWBool("InNoclip",false)
		return true -- always allow
	elseif ( ply:IsAdmin() ) then
		ply:SetNWBool("InNoclip",true)
		return true -- allow administrators to enter noclip
	end
end )