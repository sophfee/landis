landis.Buildings = landis.Buildings or {}
landis.Buildings.Data = landis.Buildings.Data or {}

function landis.Buildings.Register(UniqueID,self)
    if SERVER then
        landis.ConsoleMessage("Registered Building ID: " .. UniqueID)
    end
    landis.Buildings.Data[UniqueID] = self
end
