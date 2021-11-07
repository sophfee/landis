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


