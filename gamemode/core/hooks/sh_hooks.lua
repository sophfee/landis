hook.Add("PlayerSpawn", "SpawnSetColor", function( ply )
	local col = ply:GetPhysgunColor()
	if col then
		ply:SetWeaponColor( col )
	end
end )
