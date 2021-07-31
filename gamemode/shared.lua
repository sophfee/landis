DeriveGamemode("base")
g_base = {}

// fallback configurations
g_base.Config =  {}
g_base.Config.MainColor        = Color( 10,  132, 255 )
g_base.Config.DefaultTextColor = Color( 245, 245, 245 )
g_base.Config.BGColorDark      = Color( 44,  44,  46  )
g_base.Config.ConsolePrefix    = "[g_base]"
// instead of writing out the same LONG ASS FUCKING MESSAGE use this simple function!! :)))
function g_base.ConsoleMessage(...)
	local mColor = g_base.Config.MainColor
	local prefix = g_base.Config.ConsolePrefix .. " "
	local textCo = g_base.Config.DefaultTextColor
	MsgC(mColor,prefix,textCo,...,"\n") // \n to prevent same line console messages
end

local function includedir( scanDirectory, isGamemode )
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
				--print(fileName)
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
PERMISSION_LEVEL_SUPERADMIN = 3

function g_base.GetPermissionLevel(ply)
	if ply:IsSuperAdmin() then return 3 end
	if ply:IsAdmin()      then return 2 end
	return 1
end

// load core plugins/extensions
g_base.ConsoleMessage("loading extensions")
includedir( GM.FolderName .. "/admin/"  )

g_base.ConsoleMessage("loading plugins")
includedir( GM.FolderName .. "/plugins/" )