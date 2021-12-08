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

landis.VendorPanel = nil

net.Receive("landisVendorOpen", function()
	local ent = net.ReadEntity()
	local class = net.ReadString()
	local ven = net.ReadTable()

	if not ent or not class then return end

	if ven.Panel then
		landis.VendorPanel = landis.VendorPanel or vgui.Create( ven.Panel ) 
	end

end)
