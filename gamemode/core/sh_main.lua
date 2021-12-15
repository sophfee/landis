PERMISSION_LEVEL_USER       = 1
PERMISSION_LEVEL_ADMIN      = 2
PERMISSION_LEVEL_LEAD_ADMIN = 3
PERMISSION_LEVEL_SUPERADMIN = 4

-- Core Client Meta
if CLIENT then
	--        Get ratio scale
	LOW_RES = ScrH()*ScrW() < 1000000 and true or false
end

function landis.FindPlayer(searchKey)
    if not searchKey or searchKey == "" then return nil end
    local searchPlayers = player.GetAll()
    local lowerKey = string.lower(tostring(searchKey))

    for k = 1, #searchPlayers do
        local v = searchPlayers[k]

        if searchKey == v:SteamID() then
            return v
        end

        if string.find(string.lower(v:GetRPName()), lowerKey, 1, true) ~= nil then
            return v
        end

        if string.find(string.lower(v:Nick()), lowerKey, 1, true) ~= nil then
            return v
        end
    end
    return nil
end

function landis.SafeString(s)
	local pat = "[^0-9a-zA-Z%s]+"
	local cln =s
	cln = string.gsub(cln, pat, "")
	return cln
end

-- Credit to vin (vingard on github) ty for letting me use this :)
-- originally belonged to impulse (created by vin)
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

function landis.Reload()
	landis.Warn("A file has been refreshed! This may cause unexpected bugs!")
	if CLIENT then 
		landis.chatbox.buildBox()
	end
end