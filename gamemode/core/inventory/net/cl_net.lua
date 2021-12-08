net.Receive("landisPickupItem",function()
    local ply = net.ReadEntity()
    local itm = net.ReadString()

    local t = table.Copy(landis.items.data[itm])
    
    LocalPlayer().Inventory = table.ForceInsert(ply.Inventory,t)
end)
