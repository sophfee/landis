local PANEL = {}

function PANEL:Init()
	self.Colored = 0
	self.DisplayText = ""
	self.HoveredSound = false
	self:SetSize(200,30)
	self:SetText("")
end

function PANEL:SetDisplayText(t)
	self.DisplayText = t
end

function PANEL:Paint(w,h)
	local mainColor = landis.Config.MainColor
	if self:IsHovered() then
		if not self.HoveredSound then
			surface.PlaySound(Sound("ui/buttonrollover.wav"))
			self.HoveredSound = true
		end
		self.Colored = math.Clamp( self.Colored + (64*FrameTime()), 0, 12)
	else
		self.HoveredSound = false
		self.Colored = math.Clamp( self.Colored - (64*FrameTime()), 0, 12)
	end
		
	local r = Lerp((self.Colored/12), 255, mainColor.r)
	local g = Lerp((self.Colored/12), 255, mainColor.g)
	local b = Lerp((self.Colored/12), 255, mainColor.b)

	draw.SimpleTextOutlined(self.DisplayText or "null", "landis_base_main_menu_btn", w/2, h/2, Color( r, g, b, GlobalAlpha or 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, GlobalAlpha ))
end

function PANEL:DoClick()
	surface.PlaySound(Sound("ui/buttonclickrelease.wav"))
	if self.WhenPressed then
		self:WhenPressed()
	end
end

vgui.Register("landisMainMenuButton", PANEL, "DButton")