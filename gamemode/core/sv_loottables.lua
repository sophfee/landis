landis.Loot = landis.Loot or {}
landis.Loot.Tables = landis.Loot.Tables or {}

function landis.RegisterLootTable(UniqueID,DataTable)
	landis.ConsoleMessage("Registering loot table: " .. UniqueID)
	landis.Loot.Tables[UniqueID] = DataTable
end
