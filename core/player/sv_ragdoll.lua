util.AddNetworkString("ragdoll_camera")

function GM:PlayerSpawn(ply)
	ply:SetModel("models/player/Group01/male_06.mdl")
end

function GM:PostPlayerDeath(ply)
	ply:CreateRagdoll()
end