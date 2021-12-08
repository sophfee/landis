util.AddNetworkString("landisStartChat")
net.Receive("landisStartChat", function(len,ply)
  if (ply.LastChatTime or 0) < CurTime() then
    ply:SetNWBool("IsTyping", true)
    timer.Simple(45,function()
      ply:SetNWBool("IsTyping",false)
		end)
	else
    ply.RiskAmount = (ply.RiskAmount or 0) + 1
    landis.Warn(ply:Nick().. " is sending too many net messages!")
			
		if ply.RiskAmount > 15 then
			ply:Kick("NET Overflow Intervention")
		end 
	end
	ply.LastChatTime = CurTime()+0.075
end)

util.AddNetworkString("landis_spawn_vendor")

net.Receive("landis_spawn_vendor", function(len,ply)
	if ply:IsSuperAdmin() then
		landis.ConsoleMessage(ply:Nick() .. " has spawned a vendor.")
		landis.SpawnVendor(net.ReadString(),ply:GetEyeTrace().HitPos or ply:GetPos())
	end
end)
