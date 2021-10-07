hook.Add("landisOpenVendor", "landisBasicVendorFunc", function(ply,ent,class)
	local ven = landis.GetVendor(class)
	if ven then
		if ven.Behavior = "basic" then

			net.Start( "landisVendorOpen" )

				net.WriteEntity( ent ) -- Entity Reference
				net.WriteString( class or "example_vendor" ) -- Vendor Class
				net.WriteTable( ven ) -- vendor data

			net.Send( ply )

		end
	end
end)