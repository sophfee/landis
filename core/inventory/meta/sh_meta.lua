--- Player methods & helper functions.
-- @classmod Player

local PLAYER = FindMetaTable( "Player" )

PLAYER.Inventory = {}

--- [INTERNAL] Setup player inventory.
-- [INTERNAL] Sets up inventory.
function PLAYER:SetupInventory()

end

--- Can pickup item.
-- monkey nuts.
-- @param item Item that the user wants to pickup.
function PLAYER:CanPickupItem( item )
end

function PLAYER:GetOpenSlot()
	for v,k in ipairs( self.Inventory ) do
		if not k then return v end
	end
	return false -- no slots available
end