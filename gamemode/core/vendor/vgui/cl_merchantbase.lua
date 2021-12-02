local PANEL = {}

function PANEL:Init()
	self:SetSize(450,600)
	self:SetTitle("")
	self:SetDraggable(false) -- eat pooper
	self.merchant = nil
	self:Center()
	self:MakePopup()
	self.sell = vgui.Create("DPanel", self)
	self.sell:SetPos(5,30)
	self.sell:SetSize((self:GetWide()-20)/2,(self:GetTall()-35))
	self.buy = vgui.Create("DPanel", self)
	self.buy:SetPos(5+self:GetWide()/2,30)
	self.buy:SetSize((self:GetWide()-20)/2,(self:GetTall()-35))
	local a = vgui.Create("DButton", self.sell)
	//self.buy:AddItem(a)
	a:Dock(FILL)
	a:SetText("BUYING")
end

function PANEL:SetMerchant( class )
	local Merchant = landis.GetVendor( class )

	if Merchant then

	end
end

function PANEL:OnClose()
	landis.VendorPanel = nil
end

vgui.Register("merchantbase", PANEL, "DFrame")