-- custom chat VGUI system made by nick.
-- do not redistribute.

local PANEL = {}

function PANEL:Init()
	self.message = nil	
	self.text    = ""
	self.rawText = ""
	self.colors  = {}
	self:SetText("")
	self:SetCursor("arrow")
end
CommandColors = {}
CommandColors[PERMISSION_LEVEL_USER] = Color(10,132,255,255)
CommandColors[PERMISSION_LEVEL_ADMIN] = Color(52,199,89,255)
CommandColors[PERMISSION_LEVEL_LEAD_ADMIN] = Color(88,86,214)
CommandColors[PERMISSION_LEVEL_SUPERADMIN] = Color(255,69,58)

function PANEL:SetMessage( ... )

	local args = { ... }

	self.text    = "<font=landis-" .. tostring(landis.lib.GetSetting("chatfontSize") or 18) .. (landis.lib.GetSetting("chatUseBold") and "-S-B" or "-S") .. "><colour=255,255,255>"
	self.colors  = {}
	self.sender  = nil

	local curColor = color_white

	for v,k in ipairs( args ) do

		local class = type( k )

		if type( k ) == "table" then

			self.text       = self.text .. "</colour><colour=" .. k.r .. "," .. k.g .. "," .. k.b ..">"
			curColor        = k

		elseif type( k ) == "string" then

			
			self.text       = self.text .. k
			
			self.rawText    = self.rawText .. k

			k = string.Replace(k, "&lt;", "<")
			k = string.Replace(k, "&gt;", ">")
			MsgC( curColor, k )


		elseif k:IsPlayer() then

			if SCHEMA:ShowRankInChat( k, k:GetUserGroup() ) then

				local teamColor = CommandColors[k:GetPermissionLevel()]
				local ka = Color(230,230,230)

				self.text       = self.text .. "</colour><colour=" .. teamColor.r .. "," .. teamColor.g .. "," .. teamColor.b ..">"
				self.text       = self.text .. "[" .. k:GetRankName() .. "] "

			end

			local teamColor = team.GetColor( k:Team() )
			MsgC( teamColor, k:Nick() )

			self.text       = self.text .. "</colour><colour=" .. teamColor.r .. "," .. teamColor.g .. "," .. teamColor.b ..">"
			self.text       = self.text .. k:Nick()
			self.sender     = k

			self.rawText    = self.rawText .. k:Nick()

		end

	end
	self.text = self.text .. "</colour></font>"
	
	local w   = landis.chatbox.chatLog:GetWide() - 5
	self.message = markup.Parse( self.text, landis.chatbox.chatLog:GetWide() )
	self:SetSize( w, self.message:GetHeight() )
	self.startTime = CurTime() + 5
	MsgC("\n")
	--self:GetParent():GetVBar():AnimateTo(0, 0.2)

end

function PANEL:DoClick()
	-- Copy SteamID & Open Player Info from message click.
	local playerMenu = DermaMenu()
	local opt_a = playerMenu:AddOption( "Copy message text", function() 
			SetClipboardText( self.rawText ) 
			LocalPlayer():Notify("Text has been copied to clipboard!")
		end )

	if LocalPlayer():IsAdmin() then
		
		
		local opt_a = playerMenu:AddOption( "[admin] Copy Sender's SteamID", function() 
			SetClipboardText( self.sender:SteamID() ) 
			LocalPlayer():Notify("Copied " .. self.sender:Nick() .. "'s SteamID!")
		end )
		opt_a:SetIcon("icon16/shield.png")

		local opt_b = playerMenu:AddOption( "[admin] Open Player Info", function() 
			local Card = vgui.Create("landisPlayerCard")
			Card:SetPlayer(self.sender)
		end )
		opt_b:SetIcon("icon16/shield.png")

		
	end
	playerMenu:Open()
end

function PANEL:Paint( w, h )

	if self.message then

		local alpha = LocalPlayer():IsTyping() and 255 or math.Clamp(255 - ((CurTime() - self.startTime)*64),0,255)

		self.message:Draw( 0, 0, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, alpha )

	end

end

vgui.Register( "chatmessage", PANEL, "DButton" )
