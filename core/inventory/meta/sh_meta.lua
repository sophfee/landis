local meta = FindMetaTable( "Player" )

meta.Inventory = {}

-- Internal, replicated on client by running the same command
function meta:SetupInventory()

end

-- func: Can pickup item,
--@realm shared
function meta:CanPickupItem( item )
end

function meta:GetOpenSlot()
	for v,k in ipairs( self.Inventory ) do
		if not k then return v end
	end
	return false -- no slots available
end