--[[

just a quick lil tool i made to assist with picking out icons easily

DFrame menu tells you what the icon selected is called, copies the icon to clipboard via button

]]

local PANEL = {}

function PANEL:Init()
	self:SetSize( 400, 400 )
	self:SetTitle("Icon Tool")
	self:SetIcon("icon16/wrench.png")

	self.iconBrowser = vgui.Create( "DIconBrowser", self )
	self.iconBrowser:SetSize(380,330)
	self.iconBrowser:SetPos(10,35)

	self.copyBtn = vgui.Create( "DButton", self )
	self.copyBtn.DoClick = function( btn )
		SetClipboardText( self.iconBrowser:GetSelectedIcon() )	
		LocalPlayer():Notify("Copied icon to clipboard!")	
	end
	self.copyBtn:SetSize(200,20)
	self.copyBtn:SetPos(100,370)
	self.copyBtn:SetText("Copy Icon to Clipboard")

	self:Center()
	self:MakePopup()
end

vgui.Register("landysIcontool", PANEL, "DFrame")

