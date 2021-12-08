local PANEL = {}

function PANEL:Init()
	self:SetSize(400,400)
	self:SetTitle("vendor base panel")
	self:Center()
	self:MakePopup()
end

function PANEL:OnClose()
	landis.VendorPanel = nil
end

vgui.Register("VendorPanel", PANEL, "DFrame")
