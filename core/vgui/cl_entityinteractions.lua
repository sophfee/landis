local PANEL = {}

/* This is an INTERNAL Class! Do not create! */

function PANEL:Init()
	self:SetTitle("Invalid Entity Interactions!")
	self.ent = nil
	self.tracedLine = vgui.Create("DPanel", self)
	self.tracedLine:NoClipping(true)
	self.tracedLine.Paint = function(p,w,h)
		if not self.ent then return end
		local red,green,blue = g.Config.MainColor:Unpack()
		surface.SetDrawColor(red, green, blue, 255)
		local endPos     = self.ent:LocalToWorld( self.ent:OBBCenter() ):ToScreen()
		local startPos   = p:GetPos()
		surface.DrawLine( startPos[1], startPos[2], endPos[1], endPos[2] )
	end
	self:SetSize(600,600)
	self:MakePopup()
end

function PANEL:SetEntity( ent )

	if not ent then return nil end
	if not IsValid(ent) then return nil end

	local entData = scripted_ents.Get( ent:GetClass() )

	if not entData then return nil end
	if not entData["Interactions"] then return nil end

	self.ent = ent

	for v,k in ipairs( endData.Interactions ) do

	end
end

vgui.Register("gEntityInteractions", PANEL, "DFrame")