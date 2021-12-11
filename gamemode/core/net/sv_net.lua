util.AddNetworkString("landisStartChat")
util.AddNetworkString("ragdoll_camera")
util.AddNetworkString("landis_RequestTeamJoin")
util.AddNetworkString("landis_spawn_vendor")
util.AddNetworkString("landisItemEquip")

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

net.Receive("landisItemEquip", function(len,ply)
	if (ply.limitItemEquip or 0) > CurTime() then -- or 0 returns 0 if the thing is nil
		return -- if the player's next allowed vendorspawn is greater than the current time we return
	end
	ply.limitItemEquip = CurTime() + 1


	local itemIndex = net.ReadInt(32)
	local itemData  = ply.Inventory[itemIndex]

	if itemData then
		if itemData.canEquip then
			ply.Inventory[itemIndex].OnEquip(itemData,ply,itemIndex)
		end
	end
end)

net.Receive("landis_spawn_vendor", function(len,ply)
	if (ply.limitSpawnVendor or 0) > CurTime() then -- or 0 returns 0 if the thing is nil
		return -- if the player's next allowed vendorspawn is greater than the current time we return
	end
	ply.limitSpawnVendor = CurTime() + 2


	if ply:IsSuperAdmin() then
		landis.ConsoleMessage(ply:Nick() .. " has spawned a vendor.")
		landis.SpawnVendor(net.ReadString(),ply:GetEyeTrace().HitPos or ply:GetPos())
	end

end)

net.Receive("landis_RequestTeamJoin", function(len,ply)
	if (ply.teamWaitJoin or 0) > CurTime() then 
		return
	end
	ply.teamWaitJoin = CurTime() + 2
	
	
	local teamIndex = net.ReadInt(32)
	if teamIndex then
		local limit = landis.Teams.Data[teamIndex].Limit
		if limit then
			if #team.GetPlayers(teamIndex) < limit then
				hook.Run("PlayerJoinTeam", ply, teamIndex)
			end
		else
			hook.Run("PlayerJoinTeam", ply, teamIndex)
		end
	end
end)
