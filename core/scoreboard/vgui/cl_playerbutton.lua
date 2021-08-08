local PANEL = {}

surface.CreateFont("pCardName", {
	font = "Arial",
	weight = 3000,
	antialias = true,
	shadow = true,
	extended = true,
	size = 24
})

surface.CreateFont("pCardMisc", {
	font = "Arial",
	weight = 3000,
	antialias = true,
	shadow = true,
	extended = true,
	size = 18
})

function PANEL:Paint(w,h)

	if not IsValid(self.Owner) then return end

	surface.SetMaterial(Material("vgui/gradient-l"))

	local r, gC, b = self.Color:Unpack()

	surface.SetDrawColor(r,gC,b,180)
	surface.DrawTexturedRect(0, 0, w, h)

	if not self.Owner then return end

	draw.SimpleText(self.Owner:Nick(), "pCardName", 69, 5)

	local r, gC, b = color_white:Unpack()

	surface.SetDrawColor(r,gC,b,255)
	surface.DrawOutlinedRect(0, 0, w, h, 1)

	draw.SimpleText( self.Owner:Ping(), "pCardMisc", w-5, 5, color_white, TEXT_ALIGN_RIGHT )

end
function PANEL:SetPlayer(ply)
	if not ply:IsPlayer() then return end
	self.Owner = ply
	self.Color = team.GetColor( ply:Team() )
	self.Icon:SetModel(ply:GetModel())
	self.Icon:SetFOV(3.4)
	self.Icon:SetLookAt(Vector(0, -0, 66.1))
	self.Icon:SetCamPos(Vector(190,-50,71))
	self.Icon:SetAnimSpeed( 4 )
	self.Icon:SetDisabled( true )

end
function PANEL:Init()

	self:SetText("")
	self:SetTooltip("Left-Click to open Player Card.")
	self.Icon = vgui.Create("DModelPanel", self)
	self.Icon:SetSize(62,62)
	self.Icon:SetPos(1,1)
	self.Owner = nil
	function self.Icon:LayoutEntity()
	end
end
function PANEL:DoClick()
	if not IsValid( self.Owner ) then return end
	if openPlayercard then return end
	openPlayercard = true
	local __ = vgui.Create("gPlayerCard")
	__:Center()
	__:MakePopup()
	__:SetPlayer( self.Owner )
end

vgui.Register("gPlayerPanel", PANEL, "DButton")