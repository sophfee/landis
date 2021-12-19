local math = math
local clamp = math.Clamp
local floor = math.floor

local PLAYER = FindMetaTable("Player")

function PLAYER:SetXP( num )
  sql.Query("UPDATE landis_user SET xp = " .. num .. " WHERE steamid = " .. sql.SQLStr(self:SteamID64()))
  self:SetNWInt("XP", num)
end

function PLAYER:SetupData()
	landis.ConsoleMessage("Setting up data for User: "..self:Nick())
	-- Setup Core Data
	do 
		local userData = sql.Query("SELECT * FROM landis_user WHERE steamid = " .. sql.SQLStr( self:SteamID64()) )
		if not userData then
			landis.ConsoleMessage("No existing core data found for user! Creating new data...")
			self:SetupNewUser()
			return
		end
		self:SetUserGroup(userData[1].usergroup)
		self:SetRPName(userData[1].rpname,false)
	end
	-- Setup Currency Data
	do
		local userData = sql.Query("SELECT * FROM landis_currency WHERE steamid = " .. sql.SQLStr( self:SteamID64()) )
		if not userData then
			landis.ConsoleMessage("No existing currency data found for user! Creating new data...")
			sql.Query("INSERT INTO landis_currency VALUES("..sql.SQLStr(self:SteamID64()) ..", ".. tostring(0) ..", ".. tostring(0)..")")
			return
		end
		self:SetNWInt("Money",userData[1].cc)
	end
end

function PLAYER:ClearInventory()
	self.Inventory = {}
	self:SendLua("LocalPlayer().Inventory = {}") -- easier than net message lol
end

function PLAYER:SetupNewUser()
	local userData = baseData
	local a = sql.Query("INSERT INTO landis_user VALUES("..sql.SQLStr(self:SteamID64()) ..", ".. sql.SQLStr(self:Nick()) ..", ".. tostring(0)..", "..sql.SQLStr("user")..")")
	sql.Query("INSERT INTO landis_currency VALUES("..sql.SQLStr(self:SteamID64()) ..", ".. tostring(0) ..", ".. tostring(0)..")")
	landis.ConsoleMessage("Created new data successfully!")
end

function PLAYER:FeedHunger(v)
	return self:SetHunger(floor(clamp(self:GetHunger()+v,0,100)))
end

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

function PLAYER:EditRPName(name,no_sync)
	self:SetRPName(name)
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
