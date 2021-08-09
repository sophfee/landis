local meta = FindMetaTable("Player")

local adminGroups = {
    ["admin"] = true,
    ["leadadmin"] = true
}

function meta:IsLeadAdmin()
    return self:IsUserGroup("leadadmin") or self:IsSuperAdmin()
end

function meta:IsAdmin()
    if self:IsSuperAdmin() then
        return true
    end
    
    if adminGroups[self:GetUserGroup()] then
        return true
    end

    return false
end
