local meta = FindMetaTable("Player")

function meta:SetupDataTables()
	self:NetworkVar("Float", 0, "Stamina")
	if SERVER then
		self:SetStamina(5)
	end
end