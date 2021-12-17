landis.Loot = landis.Loot or {}
landis.Loot.Tables = landis.Loot.Tables or {}
landis.Loot.Containers = landis.Loot.Containers or {}

function landis.RegisterLootTable(UniqueID,DataTable)
	landis.ConsoleMessage("Registering loot table: " .. UniqueID)
	landis.Loot.Tables[UniqueID] = DataTable
end

function landis.SpawnContainer(pos,ang,loot_table,model)
    landis.ConsoleMessage("Spawning new loot container: ")
    local CONTAINER = ents.Create("landis_loot_container") 
    CONTAINER:SetPos(pos)
    CONTAINER:SetAngles(ang)
    CONTAINER:SetContainerType(loot_table)
    CONTAINER:SetModel(model)
    CONTAINER:PhysicsInit(SOLID_VPHYSICS)
    CONTAINER:SetMoveType(MOVETYPE_NONE)
    CONTAINER:Spawn()
end