net.Receive("landisNotify", function()
	local message = net.ReadString()
	local duration = net.ReadInt(32)
  LocalPlayer():Notify(message,duration)
end)
net.Receive("landisPickupItem",function()
    local ply = net.ReadEntity()
    local itm = net.ReadString()

    local t = table.Copy(landis.items.data[itm])
    
    LocalPlayer().Inventory = table.ForceInsert(ply.Inventory,t)
end)
