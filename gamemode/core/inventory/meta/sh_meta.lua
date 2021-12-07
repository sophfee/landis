--- Player methods & helper functions.
-- @classmod Player

local PLAYER = FindMetaTable( "Player" )

PLAYER.Inventory = {}

--- [INTERNAL] Setup player inventory.
-- [INTERNAL] Sets up inventory.
function PLAYER:SetupInventory()
	self.Inventory = {}
end

function PLAYER:Weight()
	local weight = 0
	for v,k in ipairs(self.Inventory) do
		local item = landis.items.data[k.UniqueID]
		weight = weight + item.weight
	end
	return weight
end

--- Can pickup item.
-- monkey nuts.
-- @param item Item that the user wants to pickup.
function PLAYER:CanPickupItem( item )
	local item = landis.items.data[item] or error()
	local weight = self:Weight()
	return !(weight + item.weight > 20)
end
