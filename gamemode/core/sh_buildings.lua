landis.Buildings = landis.Buildings or {}
landis.Buildings.Data = landis.Buildings.Data or {}
landis.Doors = landis.Doors or {}

function landis.Buildings.Register(UniqueID,self)
	if SERVER then
		landis.ConsoleMessage("Registered Building ID: " .. UniqueID)
	end
	for v,k in pairs(self.Doors) do
		validDoor = false
		do
			local door = Entity(v)
			
			if not IsValid(door) then return end
			--if not (door:GetClass() == "func_door") then return end
			
			if self.Label then
				door.DoorLabel = self.Label
			end
			
			if self.Purchasable then
				door:SetNWString("Description","Press F2 to open purchase menu")
			else
				door:SetNWString("Description","")
			end
			
			landis.Doors[v] = k
			
			validDoor = true
		end
		if not validDoor then
			return landis.Error("Invalid building! Failed at door registry!")
		end
	end
	landis.Buildings.Data[UniqueID] = self
end

if SERVER then
	hook.Add("PlayerButtonDown","landisPurchaseProperty",function(ply,btn)
		if btn == KEY_F2 then
			landis.ConsoleMessage(ply:Nick() .. " has attempted to open an interaction... [TESTING_PURCHASE_PROPERTY]")
			do
				local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector()*250, ply)
				if not tr.Hit then return end
				local ent = tr.Entity
				if not IsValid(ent) then return end
				if landis.Doors[ent:EntIndex()] then
					landis.ConsoleMessage("do the door thang")
				end
			end
		end
	end)
end

landis.Buildings.Register("AA",{
	Purchasable = true,
	Label = "deez nuts",
	Doors = {
		[ 142 ] = {}
	}
})