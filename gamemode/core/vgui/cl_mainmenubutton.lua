local PANEL = {}
local math = math
local floor = math.floor
local clamp = math.Clamp

function PANEL:Init()
	self.Colored = 0
	self.DisplayText = ""
	self.HoveredSound = false
	self:SetSize(200,45)
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
		self.Colored = clamp( self.Colored + (64*FrameTime()), 0, 12)
	else
		self.HoveredSound = false
		self.Colored = clamp( self.Colored - (64*FrameTime()), 0, 12)
	end
		
	local r = floor(Lerp((self.Colored/12), 255, mainColor.r))
	local g = floor(Lerp((self.Colored/12), 255, mainColor.g))
	local b = floor(Lerp((self.Colored/12), 255, mainColor.b))
	local c = Color(r,g,b,GlobalAlpha)

	draw.SimpleText(
		self.DisplayText, 
		"landis-36", 
		7, 
		h/2, 
		Color(
			floor(c.r/2),
			floor(c.g/2),
			floor(c.b/2),
			floor(GlobalAlpha)
		),
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
	draw.SimpleText(
		self.DisplayText, 
		"landis-36", 
		5, 
		h/2, 
		c,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function PANEL:DoClick()
	surface.PlaySound(Sound("ui/buttonclickrelease.wav"))
	if self.WhenPressed then
		self:WhenPressed()
	end
end

vgui.Register("landisMainMenuButton", PANEL, "DButton")