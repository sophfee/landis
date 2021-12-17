landis.Buildings = landis.Buildings or {}
landis.Buildings.Data = landis.Buildings.Data or {}
landis.Doors = landis.Doors or {}
landis.DoorCache = ents.FindByClass("prop_door_rotating")

function landis.Buildings.Register(UniqueID,self)
	if SERVER then
		landis.ConsoleMessage("Registered Building ID: " .. UniqueID)
	end
	for v,k in pairs(self.Doors) do
		validDoor = false
		do
			local door = nil

			for i,d in ipairs(landis.DoorCache) do
				if d:GetPos():DistToSqr( k.pos ) < 160 then
					door = d
					table.remove(landis.DoorCache,i)
					break
				end
			end
			
			if not IsValid(door) then return end
			if not (door:GetClass() == "prop_door_rotating") then return end
			
			if k.label then
				door.DoorLabel = k.label
			end
			
			if self.Purchasable then
				door:SetNWString("Description","Press F2 to open purchase menu")
			else
				door:SetNWString("Description","")
			end
			
			landis.Doors[door:EntIndex()] = k
			
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
				if ent:GetClass() == "prop_door_rotating" then return end
				if landis.Doors[ent:EntIndex()] then
					landis.ConsoleMessage("do the door thang")
				end
			end
		end
	end)
end

landis.Buildings.Register("RDC",{
	Purchasable = false,
	Doors = {
		[1] = {
			pos   = Vector(3384,4535,382),
			label = "RDC Exit"
		},
		[2] = {
			pos   = Vector(2991,4792,382),
			label = "RDCRDCRDC"
		},
		[3] = {
			pos = Vector(1889,4744,438),
			label = "dor"
		},
		[4] = {
			pos = Vector(2540,5221,382),
			label = "Shop"
		}
	}
})