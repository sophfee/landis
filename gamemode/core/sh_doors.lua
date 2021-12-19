-- door groups & purchasing doors
landis.Doorgroups = landis.Doorgroups or {}
landis.Doorgroups.Data = landis.Doorgroups.Data or {}

function landis.RegisterDoorgroup(name,level)
    landis.Doorgroups.Data[level] = {
        Name = name,
        Level = level
    }
    return level
end

function landis.SetDoorgroup(door,level)
    if door:IsDoor() then
        door.Doorgroup = level
    end
end