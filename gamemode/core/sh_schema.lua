landis.Schema = {}
landis.Schema.Name = landis.Schema.Name or "#NONE"

SCHEMA = {}
SCHEMA.Config = {}
SCHEMA.HUD = {}
SCHEMA.HUD.Elements = {
	["Crosshair"] = true,
	["Health"] = true,
	["Armor"] = true,
	["Ammo"] = true
}

function landis.Schema.Boot( schemaName )
	landis.ConsoleMessage("booting schema \"" .. schemaName .. "\"")
	landis.Schema.Name = schemaName
	landis.includeDir(GM.FolderName .. "/schema")
	landis.ConsoleMessage("schema finished booting!")
	
end
hook.Add("InitPostEntity","landisLoadDoors",function()
	if SERVER then
		for doorGroup,doors in pairs(SCHEMA.Doors) do
			for _,mapID in ipairs(doors) do
				local doorEnt = ents.GetMapCreatedEntity(mapID)
				if IsValid(doorEnt) then
					doorEnt:SetDTInt(0,doorGroup)
				end
			end
			--[[if IsValid(doorEnt) then
				landis.SetDoorgroup(doorEnt,doorGroup)
			else
				landis.Warn("Failed to load doorgroup for door @ " .. tostring(doorPos))
			end]]
		end
	end
	
end)
-- Default Hooks

function SCHEMA:ShowRankInChat(ply,rank)
	return true
end

function SCHEMA:SetHUDElement( element, bVal )
	self.HUD.Elements[element] = bVal
end

function SCHEMA:ShouldDrawElement( element )
	return self.HUD.Elements[element]
end