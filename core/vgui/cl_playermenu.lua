-- The hub for most things a player will need.

local PANEL = {}

local pWidth = LOW_RES and 400 or 800
local pHeight = LOW_RES and 320 or 720

function PANEL:Init()
	self:SetBackgroundBlur(true)
	self:SetSize(pWidth,pHeight)
	self:Center()
	self:SetDraggable(false)
	self:MakePopup()
end


vgui.Register("landisPlayerMenu", PANEL, "DFrame")