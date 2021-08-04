local SKIN = {}
derma.RefreshSkins()

g_base.Config.ButtonColorOff      = Color(72,72,74,255)
g_base.Config.ButtonColorHovered  = Color(99,99,102,255)
g_base.Config.ButtonColorOn       = Color(142,142,147,255)
g_base.Config.CloseButtonColor    = Color(255,69,58,255)

surface.CreateFont("g_base-default-14", {
	font = "Arial",
	weight = 2500,
	size = 14
})

surface.CreateFont("g_base-default-20", {
	font = "Arial",
	weight = 2500,
	size = 20
})

surface.CreateFont("close_button", {
	font = "Lucida Console",
	weight = 2500,
	size = 16
})

local blur = Material("pp/blurscreen")
function blurDerma(panel,alpha,layers,density)
    local x, y = panel:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255, alpha)
    surface.SetMaterial(blur)
    for i = 1, 3 do
        blur:SetFloat("$blur", (i / layers) * density)
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
    end
end


function SKIN:PaintFrame( self,w,h )
	blurDerma(self,200,10,20)
	local mainColor = g_base.Config.MainColor
	local bgColor   = g_base.Config.BGColorDark
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 220 )
	surface.DrawRect( 0, 0, w, h )
	surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b )
	surface.DrawRect( 0, 0, w, 23 )
	surface.DrawOutlinedRect( 0, 23, w, h-23, 2 )
	self.lblTitle:SetTextColor(color_white)
	if self:GetSizable() then
		surface.SetDrawColor(0, 0, 0)
		draw.NoTexture()
		surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b )
		surface.DrawPoly({
			{x=w-15,y=h-5},
			{x=w-5,y=h-15},
			{x=w-5,y=h-5}
		})
	end
end

function SKIN:PaintMenuBar(self,w,h)
	local bgColor   = g_base.Config.ButtonColorOff
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect( 0, 0, w, h )
end

function SKIN:PaintWindowMaximizeButton() end
function SKIN:PaintWindowMinimizeButton() end

function SKIN:PaintWindowCloseButton(self,w,h)
	if not self.ButtonHoldAlpha then
		self.ButtonHoldAlpha = 0
	end
	local mainColor = g_base.Config.CloseButtonColor
	local bgColor   = g_base.Config.ButtonColorOff
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b, self.ButtonHoldAlpha )
	surface.DrawRect(0, 0, w, h)
	if self:IsHovered() then
		self.ButtonHoldAlpha = math.Clamp(self.ButtonHoldAlpha+(((1/60)*FrameTime()))*50000,0,255)
	else
		self.ButtonHoldAlpha = math.Clamp(self.ButtonHoldAlpha-(((1/60)*FrameTime()))*50000,0,255)
	end
	surface.SetDrawColor(255, 255, 255)
	draw.NoTexture()
	surface.DrawTexturedRectRotated(w/2, h/2, h/2, 2, 45)
	surface.DrawTexturedRectRotated(w/2, h/2, h/2, 2, -45)
	--surface.DrawLine(w/2-h/2+6, 6, w/2+h/2-6, h-6)
	//draw.SimpleText("X", "close_button", w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SKIN:PaintPropertySheet(self,w,h)
	--blurDerma(self,200,10,20)
	local mainColor = g_base.Config.MainColor
	local bgColor   = g_base.Config.BGColorDark
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 220 )
	surface.DrawRect( 0, 26, w, h-26 )
	surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b )
	surface.DrawOutlinedRect( 0, 26, w, h-26, 2 )
end

function SKIN:PaintTab(self,w,h)
	
	if not self.hSND then
		self.hSND = false
	end
	if not self.pSND then
		self.pSND = false
	end
	if self:GetName() == "DNumberScratch" then return end
	self:SetTextColor(color_white)
	local bgColor   = g_base.Config.ButtonColorOff
	if self:IsHovered() then
		if not self.hSND then
			if g_base:GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/rollover.wav")) end
			self.hSND = true
		end
		bgColor = g_base.Config.ButtonColorHovered
	else self.hSND = false end
	if self:IsDown() then
		if not self.pSND then
			if g_base:GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/press.wav")) end
			self.pSND = true
		end
		bgColor = g_base.Config.ButtonColorOn
	else self.pSND = false end
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	local mainColor = g_base.Config.MainColor
	if self:IsActive() then
		surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b )
	end
	surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintButton(self,w,h)
	if not self.hSND then
		self.hSND = false
	end
	if not self.pSND then
		self.pSND = false
	end
	if self:GetName() == "DNumberScratch" then return end
	self:SetTextColor(color_white)
	local bgColor   = g_base.Config.ButtonColorOff
	if self:IsHovered() then
		if not self.hSND then
			if g_base:GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/rollover.wav")) end
			self.hSND = true
		end
		bgColor = g_base.Config.ButtonColorHovered
	else self.hSND = false end
	if self:IsDown() then
		if not self.pSND then
			if g_base:GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/press.wav")) end
			self.pSND = true
		end
		bgColor = g_base.Config.ButtonColorOn
	else self.pSND = false end
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintTooltip(self,w,h)
	local bgColor = g_base.Config.BGColorLight
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintComboBox(self,w,h)
	self:SetTextColor(color_white)
	local bgColor   = g_base.Config.ButtonColorOff
	if self:IsHovered() then
		bgColor = g_base.Config.ButtonColorHovered
	end
	if self:IsDown() then
		bgColor = g_base.Config.ButtonColorOn
	end
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintMenuOption(self,w,h)
	local bgColor   = g_base.Config.BGColorLight
	self:SetTextColor(color_black) 
	if self:IsHovered() then
		bgColor = g_base.Config.MainColor
		self:SetTextColor(color_white)
	end
	if self:IsDown() then
		bgColor = Color(100,210,255)
	end
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
end



function SKIN:PaintLabel(self,w,h)
	print(self:GetFont())
	if self:GetFont() == "DermaDefault" then
		self:SetFont("g_base-default-20")
	end
end

derma.DefineSkin("g_base", "The default skin for g_base.", SKIN)
-- lol look at tthe identifier
hook.Add("ForceDermaSkin", "foreskin", function()
	return "g_base"
end)