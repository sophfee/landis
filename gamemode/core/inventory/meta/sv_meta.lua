--- Player methods & helper functions
-- @classmod Player

local PLAYER = FindMetaTable( "Player" )

--- Create new item and give it to a player.
-- This will silently fail if the user cannot fit the item in their inventory.
-- @param class The item class you want to add for this user again.
function PLAYER:AddItem( class )
end