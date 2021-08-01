local PANEL = {}

function PANEL:Init()
	self.TextBox = vgui.Create("RichText", self)

	self.btnClose = vgui.Create("DButton", self)
	self.btnClose:SetText("Okay")
	self.btnClose:SetPos(self:GetWide()/2-50,self:GetTall()-40)

	self:ShowCloseButton(false)
	self:SetBackgroundBlur(true)
	self:Center()
	self:MakePopup()
end

vgui.Register("DMessage", PANEL, "DFrame")