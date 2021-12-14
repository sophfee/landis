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
end

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