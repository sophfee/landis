if SERVER then
	util.AddNetworkString("moderation_ban")
end

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

local banCommand = {
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_ADMIN,
	HelpDescription = "Ban a user from the server",
	onRun  = function(self,ply,args)
		if not ply:IsAdmin() then return end
		local findUser = args[1]
		local user = landis.FindPlayer(findUser)
		local p = table.Copy(args)
		table.remove(p, 1)
		table.remove(p, 1) // shifts
		local duration = args[2] or 0
		local reason = table.concat( p, " " ) or "Violation of Community Guidelines."
		if IsValid(user) then
			sql.Query("INSERT INTO landis_bans VALUES(" .. sql.SQLStr( user:SteamID64() ) .. ", " .. sql.SQLStr( ply:SteamID64() ) .. ", " .. sql.SQLStr( reason ) .. ", " .. tostring(os.time()) .. ", " .. tostring(os.time() + (duration*60)) .. ")")
			ply:Notify("Successfully banned " .. user:Nick())
			user:Kick("You have been banned.")
			
		else
			ply:Notify("Couldn't find the user to ban!")
		end

	end
}
-- landis.chat.commands
landis.chat.RegisterCommand("/ban",banCommand)

local giveXPCommand = {
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Add XP for a user. (NOT FUNCTIONAL)",
	onRun  = function(self,ply,args)
		if not ply:IsSuperAdmin() then return end
		local findUser = args[1]
		local user = landis.FindPlayer(findUser)
		local amount = args[2] or 0
		if IsValid(user) then
			ply:Notify("Successfully added XP for " .. user:Nick())
		else
			ply:Notify("Couldn't find the user to give XP!")
		end

	end
}

landis.chat.RegisterCommand("/givexp",giveXPCommand)

local SetUserGroupCommand = {
	RequireAlive    = false,
	RequireArgs     = true,
	PermissionLevel = PERMISSION_LEVEL_SUPERADMIN,
	HelpDescription = "Set a user's usergroup. (STEAM ID ONLY!)",
	onRun  = function(self,ply,args)
		if not ply:IsSuperAdmin() then return end
		local findUser = args[1]
		local user = player.GetBySteamID(findUser)
		local group = args[2] or "user"
		if IsValid(user) then
			if user:IsSuperAdmin() then
				ply:Notify("Can't change another superadmin's usergroup! You have to edit their account data!")
				return
			end
			user:SetUserGroup(group)
			ply:Notify("Successfully set " .. user:Nick() .. " to " .. group)
		else
			ply:Notify("Couldn't find the user to edit!")
		end

	end
}

landis.chat.RegisterCommand("/setusergroup",SetUserGroupCommand)