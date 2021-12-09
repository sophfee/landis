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
  for v,k in ipairs(t) do
		if type(k) == "string" then
			t[v] = "\"" .. k .. "\""
		elseif type(k) == "table" then
			t[v] = "Color("..k.r..","..k.g..","..k.b..")"
		end
	end
	self:SendLua( "chat.AddText(" .. table.concat( t, ", " ) .. ")" )
end

local BlacklistedNames = {} -- add names

function PLAYER:SetRPName(name)
	sql.Query("UPDATE landis_user SET rpname = " .. sql.SQLStr(name) .. " WHERE steamid = " .. sql.SQLStr(self:SteamID64()))
	self:SetNWString("RPName", name)
end
