DeriveGamemode("sandbox")
landis = landis or {}
landis.lib = landis.lib or {}
landis.__VERSION = "DEV-0.1"
landis.__DISPLAY = "Landis Base"
landis.__XTNOTES = [[This gamemode is considered confidential.
(c) 2021 Nick S]]
landis.__DVBUILD = true

// fallback configurations
landis.Config =  {}
landis.Config.MainColor        = Color( 10,  132, 255 )
landis.Config.DefaultTextColor = Color( 245, 245, 245 )
landis.Config.BGColorDark      = Color( 44,  44,  46  )
landis.Config.BGColorLight     = Color( 229, 229, 234  )
landis.Config.ConsolePrefix    = "[landis]"
// instead of writing out the same LONG ASS FUCKING MESSAGE use this simple function!! :)))
function landis.ConsoleMessage(...)
	local mColor = landis.Config.MainColor
	local prefix = landis.Config.ConsolePrefix .. " "
	local textCo = landis.Config.DefaultTextColor
	MsgC(mColor,prefix,textCo,...,"\n") // \n to prevent same line console messages
end

function landis.lib.includeDir( scanDirectory, isGamemode )
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

-- Core Client Meta
if CLIENT then
	--        Get ratio scale
	LOW_RES = ScrH()*ScrW() < 1000000 and true or false
end

if SERVER then
	// load core plugins/extensions
	landis.ConsoleMessage("loading libraries")
	landis.lib.includeDir( GM.FolderName .. "/gamemode/lib"  )

	//landis.ConsoleMessage("loading extensions")
	landis.lib.includeDir( GM.FolderName .. "/core"  )

	//landis.ConsoleMessage("loading plugins")
	landis.lib.includeDir( GM.FolderName .. "/plugins" )
end
if CLIENT then 
	// load core plugins/extensions
	landis.ConsoleMessage("loading libraries")
	landis.lib.includeDir( GM.FolderName .. "/gamemode/lib"  )

	landis.ConsoleMessage("loading extensions")
	landis.lib.includeDir( GM.FolderName .. "/core"  )

	landis.ConsoleMessage("loading plugins")
	landis.lib.includeDir( GM.FolderName .. "/plugins" )
end
/*
local data = landis.Settings["test"]

local parent = vgui.Create("DFrame")
parent:SetSize(400,400)
parent:Center()
parent:MakePopup()

data.createPanel(parent,data)
*/