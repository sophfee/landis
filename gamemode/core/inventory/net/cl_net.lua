net.Receive("landisPickupItem",function()
    local ply = net.ReadEntity()
    local itm = net.ReadString()
    
    LocalPlayer().Inventory = table.insert(ply.Inventory,#ply.Inventory,table.Copy(landis.items.data[itm]))
end)
