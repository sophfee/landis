local ENTITY = FindMetaTable("Entity")

function ENTITY:IsDoor()
    return self:GetClass():find("door")
end

function ENTITY:IsDoorLocked()
    return self:GetSaveTable().m_bLocked
end

function ENTITY:GetDoorGroup()
    if self:IsDoor() then
        return (self:GetDTInt(0) or 6)
    end
end