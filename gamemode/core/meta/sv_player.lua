local PLAYER = FindMetaTable("Player")

function PLAYER:SetXP( num )
  sql.Query("UPDATE landis_user SET xp = " .. num .. " WHERE steamid = " .. sql.SQLStr(self:SteamID64()))
  self:SetNWInt("XP", num)
end

util.AddNetworkString("landisNotify")

function PLAYER:Notify(message,duration)
	if not message then return end
	duration = duration or 5
	net.Start("landisNotify")
		net.WriteString(message)
		net.WriteInt(duration,32)
	net.Send(self)
end

function PLAYER:AddChatText(...)
	local t = {...}
	net.Start("landisAddChatText")
		net.WriteTable(t)
	net.Send(self)
end

local BlacklistedNames = {} -- add names

function PLAYER:SetRPName(name,no_sync)
	self:SetNWString("RPName", name)
	if not no_sync then
		sql.Query("UPDATE landis_user SET rpname = " .. sql.SQLStr(name) .. " WHERE steamid = " .. sql.SQLStr(self:SteamID64()))
	end
end

function PLAYER:GetSyncRPName()
	local T = sql.Query("SELECT rpname FROM landis_user WHERE steamid = " .. sql.SQLStr(tostring(self:SteamID64())))
	return T[1].rpname
end
function PLAYER:AddInventoryItem(class)
	net.Start("landisPickupItem")
		net.WriteEntity(self)
		net.WriteString(class)
	net.Send(self)
	table.ForceInsert(self.Inventory, landis.items.data[class])
end
