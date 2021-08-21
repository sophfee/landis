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
	self.playerModel:SetModel(ply:GetModel())
	for v,b in ipairs(landis.Badges.Data) do
		if b.userTest(ply) then
			table.ForceInsert(self.Badges, b)
		end
	end
	for i,k in ipairs(self.Badges) do
		local icon = k.icon
		local btn  = vgui.Create( "DButton", self)
		btn:SetSize(16,16)
		btn:SetPos(10+(i-1)*16,100)
		btn:SetText("")
		btn.Paint = function(self,w,h)
			surface.SetMaterial(Material(icon))
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(0, 0, w, h)
		end
		btn.DoClick = function(self)
			Derma_Message(k.desc, "Badge Information")
		end
	end
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

	self.playerModel = vgui.Create("DModelPanel", self)
	self.playerModel:SetSize(160,333)
	self.playerModel:SetPos(340,25)
	self.playerModel:SetCamPos(Vector(190,0,40))
	self.playerModel:SetFOV(12)

	self.steamIDbtn = vgui.Create("DButton", self)
	self.steamIDbtn:SetPos(10,124)
	self.steamIDbtn:SetSize(80,20)
	self.steamIDbtn:SetText("Copy SteamID")

	function self.steamIDbtn:DoClick()
		local self = self:GetParent()
		if self.Player then
			SetClipboardText(self.Player:SteamID())
			LocalPlayer():Notify("Copied the SteamID for " .. self.Player:Nick(),3)
		end
	end

	self.Badges = {}

	function self.playerModel:LayoutEntity() end

	self.PaintOver = function( self, w, h )

		-- prevent death
		if not IsValid( self.Player ) then return end

		draw.SimpleText(self.Player:Nick(), "card_header", 79, 35)
		local localTeam = self.Player:Team()
		draw.SimpleText(team.GetName( localTeam ), "card_subtitle", 79, 67, team.GetColor( localTeam))

	end
	self:Center()
	self:MakePopup()

end

function PANEL:OnClose()
	openPlayercard = false
end

vgui.Register("landisPlayerCard", PANEL, "DFrame")

properties.Add("openPlayercard", {
	MenuLabel = "[admin] Open Player Info",
	Order = 2000, -- The order to display this property relative to other properties
	MenuIcon = "icon16/shield.png", -- The icon to display next to the property
	Filter = function(_,self,ply)
		return self:IsPlayer() and ply:IsAdmin()
	end,
	Action = function(ply,self)
		if self:IsPlayer() then
			local Card = vgui.Create("landisPlayerCard")
			Card:SetPlayer(self)

		end
	end
})

properties.Add("copySteamID", {
	MenuLabel = "[admin] Copy SteamID",
	Order = 2001, -- The order to display this property relative to other properties
	MenuIcon = "icon16/shield.png", -- The icon to display next to the property
	Filter = function(_,self,ply)
		return self:IsPlayer() and ply:IsAdmin()
	end,
	Action = function(ply,self)
		if self:IsPlayer() then
			SetClipboardText(self:SteamID())
			LocalPlayer():Notify("Copied " .. self:Nick() .. "'s SteamID.")
		end
	end
})