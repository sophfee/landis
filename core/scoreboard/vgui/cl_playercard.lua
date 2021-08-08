local PANEL = {}

surface.CreateFont("card_header", {
	font = "Arial",
	weight = 4500,
	antialias = true,
	shadow = true,
	extended = true,
	size = 32
})

surface.CreateFont("card_subtitle", {
	font = "Arial",
	weight = 4500,
	antialias = true,
	shadow = true,
	extended = true,
	size = 24
})

function PANEL:SetPlayer( ply )
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end
	self.Player = ply
	self.Avatar:SetPlayer(ply,64)
end

function PANEL:Init()

	-- basic stuff
	self:SetSize( 500, 360 )
	self:SetSizable( false )
	self:SetTitle( "Player Information" )

	-- self.Player is the players information ur showing
	self.Player = nil

	-- steam profile picture
	self.Avatar = vgui.Create("AvatarImage", self)
	self.Avatar:SetSize(64,64)
	self.Avatar:SetPos(10,35)

	self.PaintOver = function( self, w, h )

		-- prevent death
		if not IsValid( self.Player ) then return end

		draw.SimpleText(self.Player:Nick(), "card_header", 79, 35)
		local localTeam = self.Player:Team()
		draw.SimpleText(team.GetName( localTeam ), "card_subtitle", 79, 67, team.GetColor( localTeam))

	end

end

function PANEL:OnClose()
	openPlayercard = false
end

vgui.Register("gPlayerCard", PANEL, "DFrame")