landis.ConsoleMessage("Loading Inventory/Items Plugin")

landis.items = landis.items or {}
landis.items.data = landis.items.data or {}

EQUIP_WEAPON = 1
EQUIP_ARMOR  = 2
EQUIP_COS    = 3

landis.items.base = {
	UniqueID  = nil,
	DisplayName = "Unset Item",
	Description = "Missing description",
	Model     = "models/props_lab/huladoll.mdl",
	iconCam   = {
		pos    = Vector( 72.349167, 60.546150, 47.260101 ),
		fov    = 6,
		lookAt = Vector()
	},
	weight    = 0,
	canUse    = false,
	onUse     = function() end,
	useText   = "Use",
	useRemove = true, -- remove after use
	canEquip  = false, -- equip is a automatic function, depending on the way you setup the equipdata determines how it works, other cases should be made into a custom use.
	equipData = {
		type  = EQUIP_WEAPON,
		class = "weapon_pistol", -- weapon string class
		ammo1 = nil, -- give the user an amount of ammo for the priamry clip
		ammo2 = nil  -- give the user an amount of ammo for the secondary clip
	}
}

-- Setup the item class
function landis.lib.RegisterItem( meta )

	if SERVER then
		landis.ConsoleMessage("Registering new item: " .. meta.UniqueID)
	end

	local self = table.Inherit( meta, landis.items.base )

	self.OnEquip = function ( self, ply, i )
		if self.equipData.type == EQUIP_WEAPON then
			ply.Inventory[i].Equipped = ply.Inventory[i].Equipped or false
			ply.Inventory[i].Equipped = !ply.Inventory[i].Equipped -- invert value
			if SERVER then
				local t = ply.Inventory[i].Equipped and "equipped" or "unequipped"
				landis.ConsoleMessage(ply:Nick(), " has ", t, " a ", self.UniqueID
			
				if ply.Inventory[i].Equipped then
					ply:Give(self.equipData.class)
				else
					ply:StripWeapon(self.equipData.class)
				end
			end
			
		end
	end

	landis.items.data[self.UniqueID] = self
end
