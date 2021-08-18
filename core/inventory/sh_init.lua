landys.ConsoleMessage("Loading Inventory/Items Plugin")

landys.items = {}

EQUIP_WEAPON = 1
EQUIP_ARMOR  = 2
EQUIP_COS    = 3

landys.items.base = {
	UniqueID  = nil,
	Model     = "models/props_lab/huladoll.mdl",
	iconCam   = {
		pos    = Vector( 72.349167, 60.546150, 47.260101 ),
		fov    = 6,
		lookAt = Vector()
	},
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
function landys.items.RegisterItem( UniqueID, meta )
	local self = table.Inherit( meta, landys.items.base )

	function self:onEquip( ply )
		if self.equipData.type == EQUIP_WEAPON then
			
		end
	end
end