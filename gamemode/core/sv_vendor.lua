function landis.SpawnVendor( class, pos, ang )
	pos = pos or Vector()
	ang = ang or Angle()

	local entity = ents.Create("landis_vendor")
	entity:SetVendor(class)
	entity:SetPos( pos )
	entity:SetAngles( ang )
	entity:Spawn()
	local classData = landis.Vendor.Data[ class ]
	entity:SetModel( classData.Model.Path )
	for v,k in pairs( classData.Model.Bodygroup ) do
		entity:SetBodygroup( v, k )
	end
	entity:SetSkin( classData.Model.Skin )
	entity:PhysicsInit( SOLID_BBOX )
	entity:SetMoveType( MOVETYPE_NONE )
	entity:SetSequence(2)
end
