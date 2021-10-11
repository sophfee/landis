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