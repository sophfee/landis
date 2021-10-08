hook.Add("landisOpenVendor", "landisBasicVendorFunc", function(ply,ent,class)
	local ven = landis.GetVendor(class)
	if ven then
		if ven.Behavior == "basic" then

			net.Start( "landisVendorOpen" )

				net.WriteEntity( ent ) -- Entity Reference
				net.WriteString( class or "example_vendor" ) -- Vendor Class
				net.WriteTable( ven ) -- vendor data

			net.Send( ply )

		end
	end
end)

util.AddNetworkString("landis_spawn_vendor")

net.Receive("landis_spawn_vendor", function(len,ply)
	if ply:IsAdmin() then
		MsgC(Color(10,132,255),"[landis] " .. ply:Nick() .. " has spawned a vendor.\n")
		landis.lib.SpawnVendor(net.ReadString(),ply:GetPos())
	end
end)