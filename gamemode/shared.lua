DeriveGamemode("sandbox")
landys = landys or {}
landys.lib = landys.lib or {}
landys.__VERSION = "DEV-0.1"
landys.__DISPLAY = "Landis Base"
landys.__XTNOTES = [[This gamemode is considered confidential.
(c) 2021 Nick S]]
landys.__DVBUILD = true

// fallback configurations
landys.Config =  {}
landys.Config.MainColor        = Color( 10,  132, 255 )
landys.Config.DefaultTextColor = Color( 245, 245, 245 )
landys.Config.BGColorDark      = Color( 44,  44,  46  )
landys.Config.BGColorLight     = Color( 229, 229, 234  )
landys.Config.ConsolePrefix    = "[landys]"
// instead of writing out the same LONG ASS FUCKING MESSAGE use this simple function!! :)))
function landys.ConsoleMessage(...)
	local mColor = landys.Config.MainColor
	local prefix = landys.Config.ConsolePrefix .. " "
	local textCo = landys.Config.DefaultTextColor
	MsgC(mColor,prefix,textCo,...,"\n") // \n to prevent same line console messages
end

function landys.lib.includeDir( scanDirectory, isGamemode )
	-- Null-coalescing for optional argument
	isGamemode = isGamemode or false
	
	local queue = { scanDirectory }
	
	-- Loop until queue is cleared
	while #queue > 0 do
		-- For each directory in the queue...
		for _, directory in pairs( queue ) do
			--print(directory)
			-- print( "Scanning directory: ", directory )
			
			local files, directories = file.Find( directory .. "/*", "LUA" )
			
			-- Include files within this directory
			for _, fileName in pairs( files ) do
				//print(fileName)
				if fileName != "shared.lua" and fileName != "init.lua" and fileName != "cl_init.lua" then
					-- print( "Found: ", fileName )
					
					-- Create a relative path for inclusion functions
					-- Also handle pathing case for including gamemode folders
					local relativePath = directory .. "/" .. fileName
					if isGamemode then
						relativePath = string.gsub( directory .. "/" .. fileName, GM.FolderName .. "/gamemode/", "" )
					end
					
					-- Include server files
					if string.match( fileName, "^sv" ) then
						if SERVER then
							include( relativePath )
						end
					end
					
					-- Include shared files
					if string.match( fileName, "^sh" ) then
						AddCSLuaFile( relativePath )
						include( relativePath )
					end
					
					-- Include client files
					if string.match( fileName, "^cl" ) then
						AddCSLuaFile( relativePath )
						
						if CLIENT then
							include( relativePath )
						end
					end
				end
			end
			
			-- Append directories within this directory to the queue
			for _, subdirectory in pairs( directories ) do
				-- print( "Found directory: ", subdirectory )
				table.insert( queue, directory .. "/" .. subdirectory )
			end
			
			-- Remove this directory from the queue
			table.RemoveByValue( queue, directory )
		end
	end
end

PERMISSION_LEVEL_USER       = 1
PERMISSION_LEVEL_ADMIN      = 2
PERMISSION_LEVEL_LEAD_ADMIN = 3
PERMISSION_LEVEL_SUPERADMIN = 4

-- deprecated


-- Core Client Meta
if CLIENT then
	--        Get ratio scale
	LOW_RES = ScrH()*ScrW() < 1000000 and true or false
end

if SERVER then
	// load core plugins/extensions
	landys.ConsoleMessage("loading libraries")
	landys.lib.includeDir( GM.FolderName .. "/gamemode/lib"  )

	//landys.ConsoleMessage("loading extensions")
	landys.lib.includeDir( GM.FolderName .. "/core"  )

	//landys.ConsoleMessage("loading plugins")
	landys.lib.includeDir( GM.FolderName .. "/plugins" )
end
if CLIENT then 
	// load core plugins/extensions
	landys.ConsoleMessage("loading libraries")
	landys.lib.includeDir( GM.FolderName .. "/gamemode/lib"  )

	landys.ConsoleMessage("loading extensions")
	landys.lib.includeDir( GM.FolderName .. "/core"  )

	landys.ConsoleMessage("loading plugins")
	landys.lib.includeDir( GM.FolderName .. "/plugins" )
end
/*
local data = landys.Settings["test"]

local parent = vgui.Create("DFrame")
parent:SetSize(400,400)
parent:Center()
parent:MakePopup()

data.createPanel(parent,data)
*/