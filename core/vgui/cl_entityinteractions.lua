local PANEL = {}

/* This is an INTERNAL Class! Do not create! */

function PANEL:Init()
	self:SetTitle("Invalid Entity Interactions!")
	self.ent = nil
	hook.Add("HUDPaint", "LinePointer", function()
		if not IsValid( self ) then
			hook.Remove("HUDPaint", "LinePointer")
		end
		if not self.ent then return end
		local red,green,blue = landys.Config.MainColor:Unpack()
		surface.SetDrawColor(red, green, blue, 255)
		local endPos     = self.ent:LocalToWorld( self.ent:OBBCenter() ):ToScreen()
		if not endPos.visible then self:Remove() return end
		local endX, endY = endPos.x,endPos.y
		local startX, startY   = self:GetPos()
		surface.DrawLine( startX, startY, endX, endY)
		surface.DrawLine( startX, startY + self:GetTall(), endX, endY)
		surface.DrawLine( startX + self:GetWide(), startY + self:GetTall(), endX, endY)
		surface.DrawLine( startX + self:GetWide(), startY, endX, endY)
	end)
	self:SetSize(600,600)
	//self:MakePopup()
end

function PANEL:SetEntity( ent )

	if not ent then return nil end
	if not IsValid(ent) then return nil end
	self.ent = ent

	local entData = scripted_ents.Get( ent:GetClass() )

	if not entData then return nil end
	if not entData["Interactions"] then return nil end

	self.ent = ent

	for v,k in ipairs( entData.Interactions ) do

	end
end

vgui.Register("landysEntityInteractions", PANEL, "DFrame")