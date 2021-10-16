landis.schema = {}

SCHEMA = {}
SCHEMA.Config = {}
SCHEMA.HUD = {}
SCHEMA.HUD.Elements = {}

function landis.schema.boot( schemaName )
	landis.ConsoleMessage("booting schema \"" .. schemaName .. "\"")
	landis.lib.includeDir(GM.FolderName .. "/schema")
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