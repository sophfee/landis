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


