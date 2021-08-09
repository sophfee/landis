// mostly moderation things
hook.Add("CheckPassword", "CheckForBan", function(uSteamID64)
	local userData = g.userdata.Fetch(uSteamID64)
	if not userData then return true end
	for _,ban in ipairs(userData.bans) do
		if os.time() < ban.endDate then 
			return false, "uh oh! looks like you're currently banned!\n\nBanned by: " .. ban.mod .. "\nReason: "..ban.desc.."\nUnban Date: "..os.date("%A, %B %d - %x %X", ban.endDate)  
		end
	end
	return true
end)

hook.Add("PlayerInitialSpawn", "setup_data", function(ply)
	ply:SetupData()
end)


hook.Add("PlayerDisconnected", "save_data", function(ply)
	ply:SaveAllData()
end)