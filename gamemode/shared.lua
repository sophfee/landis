DeriveGamemode("sandbox")
landis = landis or {}
landis.lib = landis.lib or {}
landis.__VERSION = "DEV-0.3"
landis.__DISPLAY = "Landis Framework"
landis.__XTNOTES = "PREVIEW BUILD: " .. GetGlobalString(1)
landis.__DVBUILD = true

// fallback configurations
landis.Config =  {}
landis.Config.MainColor        = Color( 255, 69, 58 )
landis.Config.DefaultTextColor = Color( 245, 245, 245 )
landis.Config.BGColorDark      = Color( 44,  44,  46  )
landis.Config.BGColorLight     = Color( 229, 229, 234  )
landis.Config.ConsolePrefix    = "[landis]"
landis.Config.VoiceRange       = 600
-- instead of writing out the same LONG ASS FUCKING MESSAGE use this simple function!! :)))

function landis.FindPlayer(term)
	local match
	local termLen = string.len(term)
	term = string.upper(term)
	local ezTest = player.GetBySteamID( term )
	if ezTest then return ezTest end 
	for _,ply in ipairs(player.GetAll()) do
		local nick = string.upper( ply:Nick() )
		for i=0,termLen do
			local sub = string.sub(term, 0, termLen-i)
			if i == termLen then break end
			if string.match(nick,sub) then
				return ply
			end
		end
	end
end

function landis.ConsoleMessage(...)
	local mColor = landis.Config.MainColor
	local prefix = landis.Config.ConsolePrefix
	local textCo = landis.Config.DefaultTextColor
	if CLIENT then
		return MsgC(mColor,prefix,Color(50,173,230),"[Client] ",textCo,...,"\n") -- \n to prevent same line console messages
	end
	return MsgC(mColor,prefix,Color(255,59,48),"[Server] ",textCo,...,"\n")
end

function landis.Warn(...)
	local mColor = landis.Config.MainColor
	local prefix = landis.Config.ConsolePrefix
	local textCo = landis.Config.DefaultTextColor
	if CLIENT then
		return MsgC(mColor,prefix,Color(50,173,230),"[Client]",Color(255,149,0),"[Warn] ",textCo,...,"\n") -- \n to prevent same line console messages
	end
	return MsgC(mColor,prefix,Color(255,59,48),"[Server]",Color(255,149,0),"[Warn] ",textCo,...,"\n")
end

function landis.Error(...)
	local mColor = landis.Config.MainColor
	local prefix = landis.Config.ConsolePrefix
	local textCo = landis.Config.DefaultTextColor
	if CLIENT then
		return MsgC(mColor,prefix,Color(50,173,230),"[Client]",Color(255,149,0),"[Error] ",textCo,...,"\n") -- \n to prevent same line console messages
	end
	MsgC(mColor,prefix,Color(255,59,48),"[Server]",Color(255,149,0),"[Error] ",textCo,...,"\n")
	print("======[STACK TRACEBACK]=====")
	debug.Trace()
	print("======[ENDOF TRACEBACK]=====")
end

function landis.includeDir( scanDirectory, core )
	-- Null-coalescing for optional argument
	core = core or false
	
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
				
				if fileName != "shared.lua" and fileName != "init.lua" and fileName != "cl_init.lua" then
					-- print( "Found: ", fileName )
					
					-- Create a relative path for inclusion functions
					-- Also handle pathing case for including gamemode folders
					local relativePath = directory .. "/" .. fileName
	
					if core then
						relativePath = string.gsub( directory .. "/" .. fileName, "landis/gamemode/", "" )
					end

					-- Include server files
					if string.match( fileName, "^rq" ) then
						if (SERVER) then
							AddCSLuaFile(relativePath)
						end
						_G[string.sub(fileName, 3, string.len(fileName) - 4)] = include(relativePath)
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
function landis.SafeString(s)
	local pat = "[^0-9a-zA-Z%s]+"
	local cln =s
	cln = string.gsub(cln, pat, "")
	return cln
end
if SERVER then
	// load core plugins/extensions
	landis.ConsoleMessage("loading libraries")
	landis.includeDir("landis/gamemode/lib")

	landis.ConsoleMessage("loading extensions")
	landis.includeDir("landis/gamemode/core")

	landis.ConsoleMessage("loading plugins")
	landis.includeDir("landis/plugins")
end

if CLIENT then 

	landis.ConsoleMessage("loading libraries")
	landis.includeDir("landis/gamemode/lib")

	landis.ConsoleMessage("loading extensions")
	landis.includeDir("landis/gamemode/core")

	landis.ConsoleMessage("loading plugins")
	landis.includeDir("landis/plugins")

end



function landis.Reload()
	landis.Warn("A file has been refreshed! This may cause unexpected bugs!")
	if CLIENT then 
		landis.chatbox.buildBox()
	end
end

function GM:OnReloaded()
	landis.Reload()
end