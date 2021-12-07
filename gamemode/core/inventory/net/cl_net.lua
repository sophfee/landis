net.Receive("landisPickupItem",function()
    local ply = net.ReadEntity()
    local itm = net.ReadString()
    
    ply.Inventory[#ply.Inventory+1] = landis.items.data[itm]
end)
