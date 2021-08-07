local meta = FindMetaTable("Player")

function meta:SetupDataTables()
	self:NetworkVar("Float", 0, "Stamina")
	if SERVER then
		self:SetStamina(5)
	end
end

if SERVER then
	hook.Add("PlayerSpawn","setuphands", function(ply)
		ply:SetupHands()
	end)
	hook.Add("PlayerDeathSound","mutebeep",function() return true end)
end