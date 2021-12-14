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
