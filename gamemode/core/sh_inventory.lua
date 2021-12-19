landis.ConsoleMessage("Loading Inventory/Items Plugin")

landis.items = landis.items or {}
landis.items.data = landis.items.data or {}

EQUIP_WEAPON = 1
EQUIP_ARMOR  = 2
EQUIP_COS    = 3

landis.items.base = {
	UniqueID  = nil,
	ID = 0,
	DisplayName = "Unset Item",
	Description = "Missing description",
	Model       = "models/props_lab/huladoll.mdl",
	Icon       = {
		pos    = Vector( 72.349167, 60.546150, 47.260101 ),
		fov    = 6,
		lookAt = Vector()
	},
	Weight    = 0,
	Droppable = false,
	Usable    = false,
	OnUse     = function() end,
	UseText   = "Use",
	UseRemove = true, -- remove after use
	CanEquip  = false, -- equip is a automatic function, depending on the way you setup the equipdata determines how it works, other cases should be made into a custom use.
	EquipData = {
		type  = EQUIP_WEAPON,
		class = "weapon_pistol", -- weapon string class
		ammo1 = nil, -- give the user an amount of ammo for the priamry clip
		ammo2 = nil  -- give the user an amount of ammo for the secondary clip
	}
}

-- Setup the item class
function landis.RegisterItem( meta )

	if SERVER then
		landis.ConsoleMessage("Registering new item: " .. meta.UniqueID)
	end

	local self = table.Inherit( meta, landis.items.base )

	self.OnEquip = function ( self, ply, i )
		if self.EquipData.type == EQUIP_WEAPON then
			ply.Inventory[i].Equipped = ply.Inventory[i].Equipped or false
			ply.Inventory[i].Equipped = !ply.Inventory[i].Equipped -- invert value
			if SERVER then
				local t = ply.Inventory[i].Equipped and "equipped" or "unequipped"
				landis.ConsoleMessage(ply:Nick(), " has ", t, " a ", self.UniqueID)
			
				if ply.Inventory[i].Equipped then
					ply:Give(self.EquipData.class,true)
				else
					ply:StripWeapon(self.EquipData.class)
				end
			end
			
		end
	end

	self.onDrop = function ( self, ply, i )
		if self.Droppable then
			if SERVER then
				local Item = ents.Create("landis_item")
            
            	local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector()*100,ply)
            	if tr.HitPos then
                	Item:SetPos(tr.HitPos)
            	else
                	Item:SetPos(ply:EyePos()+(ply:GetAimVector()*100))
            	end
            	Item:Spawn()
            	Item:SetItem(ply.Inventory[i].UniqueID)
			end
			table.remove(ply.Inventory, i)
		end
	end

	landis.items.data[self.UniqueID] = self
end

local meta = FindMetaTable("Player")

function meta:DropItem(index)
	
end