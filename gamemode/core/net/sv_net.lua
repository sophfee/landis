util.AddNetworkString("landisNotify")
util.AddNetworkString("landisStartChat")
util.AddNetworkString("ragdoll_camera")
util.AddNetworkString("landis_RequestTeamJoin")
util.AddNetworkString("landis_spawn_vendor")
util.AddNetworkString("landisItemDrop")
util.AddNetworkString("landisItemEquip")
util.AddNetworkString("landisItemUse")
util.AddNetworkString("landisRPNameChange")
util.AddNetworkString("landisRequestRank")
util.AddNetworkString("landisAddChatText")
util.AddNetworkString("landisClearInventory")

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

net.Receive("landisItemDrop", function(len,ply)
	if (ply.limitItemDrop or 0) > CurTime() then -- or 0 returns 0 if the thing is nil
		return -- if the player's next allowed item drop is greater than the current time we return
	end
	ply.limitItemDrop = CurTime() + 1


	local itemIndex = net.ReadInt(32)
	if itemIndex == nil then
		return
	end
	
	local itemData  = ply.Inventory[itemIndex]

	if itemData then
		if itemData.Droppable then
			ply.Inventory[itemIndex].onDrop(itemData,ply,itemIndex)
		end
	end
end)

net.Receive("landisItemEquip", function(len,ply)
	if (ply.limitItemEquip or 0) > CurTime() then -- or 0 returns 0 if the thing is nil
		return -- if the player's next allowed item equip is greater than the current time we return
	end
	ply.limitItemEquip = CurTime() + 1


	local itemIndex = net.ReadInt(32)
	if itemIndex == nil then
		return
	end

	local itemData  = ply.Inventory[itemIndex]

	if itemData then
		if itemData.canEquip then
			ply.Inventory[itemIndex].OnEquip(itemData,ply,itemIndex)
		end
	end
end)

net.Receive("landisItemUse", function(len,ply)
	if (ply.limitItemUse or 0) > CurTime() then -- or 0 returns 0 if the thing is nil
		return -- if the player's next allowed item use is greater than the current time we return
	end
	ply.limitItemUse = CurTime() + 1


	local itemIndex = net.ReadInt(32)
	if itemIndex == nil then
		return
	end

	local itemData  = ply.Inventory[itemIndex]

	if itemData then
		if itemData.Usable then
			if not itemData.UseBar then -- easier
				print("hi")
				ply.Inventory[itemIndex].OnUse(itemData,ply,itemIndex)
				if itemData.UseRemove then
					table.remove(ply.Inventory, itemIndex)
				end
			else
				timer.Simple(itemData.UseBarTime,function()
					print("hi")
					ply.Inventory[itemIndex].OnUse(itemData,ply,itemIndex)
					if itemData.UseRemove then
						table.remove(ply.Inventory, itemIndex)
					end
				end)
			end
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
				ply:SetNWInt("Rank",0)
				ply:SetNWInt("Class",0)
				ply:SetRPName(ply:GetSyncRPName())
				ply:SetTeam(teamIndex)
				local data = landis.Teams.Data[teamIndex]
				ply:SetModel(data.Model)
				ply:SetupHands()
			end
		else
			ply:SetNWInt("Rank",0)
			ply:SetNWInt("Class",0)
			ply:SetRPName(ply:GetSyncRPName())
			ply:SetTeam(teamIndex)
			local data = landis.Teams.Data[teamIndex]
			ply:SetModel(data.Model)
			ply:SetupHands()
		end
	end
end)

net.Receive("landisRPNameChange", function(len,ply)
	if (ply.rpNameChangeWait or 0) > CurTime() then 
		return
	end
	ply.rpNameChangeWait = CurTime() + 2


	local name = net.ReadString()
	if name == nil then -- nick, remember, players could just be sending nothing at all
		return
	end


	name = landis.SafeString(name)
	local len  = name:len()

	if len >= 24 then
		ply:Notify("Name too long! (max 24)")
		return
	end

	if len <= 6 then
		ply:Notify("Name too short! (min 6)")
		return
	end

	ply:SetRPName(name)

end)

net.Receive("landisRequestRank", function(len,ply)
	if (ply.rankRequestWait or 0) > CurTime() then
		return
	end
	ply.rankRequestWait = CurTime() + 1
	local rank = net.ReadInt(32)
	if rank == nil then -- make rank is valid
		return
	end

	local class = net.ReadInt(32)
	if class == nil then -- make sure class is valid
		return
	end
	

	ply:SetNWInt("Rank", rank)
	ply:SetNWInt("Class", class)
	
	if SCHEMA.OnBecomeRank then
		SCHEMA:OnBecomeRank(ply,rank,class)
	end
end)
