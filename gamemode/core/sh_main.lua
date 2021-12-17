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


function landis.Reload()
	landis.Warn("A file has been refreshed! This may cause unexpected bugs!")
	if CLIENT then 
		landis.chatbox.buildBox()
	end
end