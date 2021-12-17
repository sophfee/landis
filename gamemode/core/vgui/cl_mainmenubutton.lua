local PANEL = {}
local math = math
local floor = math.floor
local clamp = math.Clamp

function PANEL:Init()
	self.TWN = {}
	self.TWN.Colored = 0
	self.DisplayText = ""
	self.HoveredSound = false
	self:SetSize(200,45)
	self:SetText("")
	self.Tween = tween.new(0.12,self.TWN,{["Colored"]=12},"outInSine") 
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
		self.Tween:update(FrameTime())
		--self.TWN.Colored = clamp( self.TWN.Colored + (64*FrameTime()), 0, 12)
	else
		self.HoveredSound = false
		self.Tween:update(-FrameTime())
		--elf.Colored = clamp( self.TWN.Colored - (64*FrameTime()), 0, 12)
	end
		
	local r = floor(Lerp((self.TWN.Colored/12), 255, mainColor.r))
	local g = floor(Lerp((self.TWN.Colored/12), 255, mainColor.g))
	local b = floor(Lerp((self.TWN.Colored/12), 255, mainColor.b))
	local c = Color(r,g,b,GlobalAlpha)

	draw.SimpleText(
		self.DisplayText, 
		"landis-" .. 32 + floor(self.TWN.Colored/3), 
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
		"landis-" .. 32 + floor(self.TWN.Colored/3), 
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