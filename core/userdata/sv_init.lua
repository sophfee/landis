landis.userdata = {}

file.CreateDir("user_data")

local meta = FindMetaTable("Player")

local baseData = {
	warns = {},
	bans  = {},
	xp    = 0,
	isAdmin = false,
	isLeadAdmin = false,
	isSuperAdmin = false
}
-- if one table doesnt exist, then the rest don't
sql.Query("CREATE TABLE IF NOT EXISTS `landis_user` ( `steamid` VARCHAR(20) NOT NULL, `xp` NUMBER, `usergroup` TEXT )")
sql.Query("CREATE TABLE IF NOT EXISTS `landis_warns` ( `steamid` VARCHAR(20) NOT NULL, `moderator` VARCHAR(20) NOT NULL, `reason` TEXT, `date` NUMBER  )")
sql.Query("CREATE TABLE IF NOT EXISTS `landis_bans` ( `steamid` VARCHAR(20) NOT NULL, `moderator` VARCHAR(20) NOT NULL, `reason` TEXT, `date` NUMBER, `end_date` NUMBER )")

// used to check userdata before they are fully connected
function landis.userdata.Fetch(uSteamID64)
	if not file.Exists("user_data/" .. uSteamID64 .. ".json", "DATA") then return nil end
	local fileClass = file.Open("user_data/" .. uSteamID64 .. ".json", "r", "DATA")
	local userData = util.JSONToTable( fileClass:ReadLine() )
	if userData then return userData else return nil end
end

function meta:IsBanned()
	for _,ban in ipairs(self.bans) do
		if os.time() < ban.endDate then return true end
	end
	return false
end

// Internal - Do not use.
function meta:GetDataDir()
	return "user_data/" .. self:SteamID64() .. ".json"
end

// Internal - Do not use.
function meta:SetupNewUser()
	local userData = baseData
	file.Write(self:GetDataDir(), util.TableToJSON(userData))
	self.log_warns = table.Copy(userData["warns"]) or {}
	self.bans  = userData["bans"] or {}
	self.log_bans  = table.Copy( userData["bans"] ) or {}
	self.xp    = userData["xp"] or 0
	self.log_xp = self.xp + 0 or 0
	self.isAdmin = self:IsAdmin()
	self.isLeadAdmin = self:IsLeadAdmin()
	self.isSuperAdmin = self:IsSuperAdmin()
end

// Internal - Do not use.
function meta:SetupData()
	local userData = sql.Query("SELECT * FROM landis_user WHERE steamid = " .. sql.SQLStr( self:SteamID64()) )
	if not userData then
		self:SetupNewUser()
		return
	end
	local fileClass = file.Open(self:GetDataDir(), "r", "DATA")
	local userData = util.JSONToTable( fileClass:ReadLine() )
	self.warns = userData["warns"] or {}
	// so you dont have to save everything at once
	// -----
	// this is useful for cases where you warn someone for something in an admin area, you dont want to save their last pos (when that gets added) so they dont re-log there in the event of a crash
	self.log_warns = table.Copy(userData["warns"]) or {}
	self.bans  = userData["bans"] or {}
	self.log_bans  = table.Copy( userData["bans"] ) or {}
	self.xp    = userData["xp"] or 0
	self.log_xp = self.xp + 0 or 0
	self.isAdmin = userData["isAdmin"]
	self.isLeadAdmin = userData["isLeadAdmin"]
	self.isSuperAdmin = userData["isSuperAdmin"]

	if self.isAdmin then
		self:SetUserGroup("admin")
	end
	if self.isLeadAdmin then
		self:SetUserGroup("leadadmin")
	end
	if self.isSuperAdmin then
		self:SetUserGroup("superadmin")
	end
end

// Internal - Do not use
function meta:SaveAllData()
	local dat = {}
	dat.warns = self.warns or {}
	dat.bans  = self.bans or {}
	dat.xp    = self.xp or 0
	dat.isAdmin = self:IsAdmin() // always sync this
	dat.isLeadAdmin = self:IsLeadAdmin() // always sync this
	dat.isSuperAdmin = self:IsSuperAdmin() // always sync this
	file.Write( self:GetDataDir(), util.TableToJSON( dat ) )
end

// Internal - Do not use
function meta:SaveRecord()
	local dat = {}
	dat.warns = self.warns or {}
	dat.bans  = self.bans or {}
	dat.xp    = self.log_xp or 0
	dat.isAdmin = self:IsAdmin() // always sync this
	dat.isLeadAdmin = self:IsLeadAdmin() // guess what/??? sync this you fucking idiot
	dat.isSuperAdmin = self:IsSuperAdmin() // always sync this

	file.Write( self:GetDataDir(), util.TableToJSON( dat ) )
end

// Function: Add Ban
// Purpose : Add a ban to a user's record
// Contact : @nick#3715
function meta:AddBan(moderator,duration,reason)
	if not moderator:IsAdmin() then return end // just ensure all security.

	reason = reason or "Violation of Community Guidelines."

	table.ForceInsert( self.bans, {
		mod = moderator:Nick(),
		endDate = os.time() + (duration*60),
		desc = reason
	} )

	self:SaveRecord()

	self:Kick("You have been banned from this server.")

end

