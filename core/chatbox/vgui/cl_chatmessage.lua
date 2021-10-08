-- custom chat VGUI system made by nick.
-- do not redistribute.

local PANEL = {}

function PANEL:Init()
	self.message = nil	
	self.text    = ""
	self.colors  = {}
end

function PANEL:SetMessage( ... )

	local args = { ... }

	self.text    = "<font=landis.chatbox_16><colour=255,255,255>"
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
			MsgC( curColor, k )

		elseif k:IsPlayer() then

			local teamColor = team.GetColor( k:Team() )
			MsgC( teamColor, k:Nick() )

			self.text       = self.text .. "</colour><colour=" .. teamColor.r .. "," .. teamColor.g .. "," .. teamColor.b ..">"
			self.text       = self.text .. k:Nick()
			self.sender     = k

		end

	end
	self.text = self.text .. "</colour></font>"
	
	local w   = landis.chatbox.chatLog:GetWide() - 5
	self.message = markup.Parse( self.text, landis.chatbox.chatLog:GetWide() )
	self:SetSize( w, self.message:GetHeight() )
	MsgC("\n")
	--self:GetParent():GetVBar():AnimateTo(0, 0.2)

end

function PANEL:OnClick()
	-- Copy SteamID & Open Player Info from message click.
	if LocalPlayer():IsAdmin() then
		local playerMenu = DermaMenu()
		local opt_a = playerMenu:AddOption( "[admin] Copy Sender's SteamID.", function() SetClipboardText( self.sender:SteamID() ) end )
		opt_a:SetIcon("")
	end
end

function PANEL:Paint( w, h )

	if self.message then

		self.message:Draw( 0, 0, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 255 )

	end

end

vgui.Register( "chatmessage", PANEL, "Panel" )