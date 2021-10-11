local SKIN = {}
PrintTable(derma.SkinList.Default)
SKIN.Colours = table.Copy(derma.SkinList.Default.Colours)
SKIN.Colours.Window.TitleActive = Color(255, 255, 255)
SKIN.Colours.Window.TitleInactive = Color(255, 255, 255)

SKIN.Colours.Button.Normal = Color(255, 255, 255)
SKIN.Colours.Button.Hover = Color(255, 255, 255)
SKIN.Colours.Button.Down = Color(180, 180, 180)
SKIN.Colours.Button.Disabled = Color(0, 0, 0, 100)

SKIN.Colours.Label.Highlight = Color(90, 200, 250, 255)


landis.Config.ButtonColorOff      = Color(72,72,74,255)
landis.Config.ButtonColorHovered  = Color(99,99,102,255)
landis.Config.ButtonColorOn       = Color(142,142,147,255)
landis.Config.CloseButtonColor    = Color(255,69,58,255)

landis.Config.ButtonColorOffV      = Vector(72,72,74,255)
landis.Config.ButtonColorHoveredV  = Vector(99,99,102,255)
landis.Config.ButtonColorOnV       = Vector(142,142,147,255)
landis.Config.CloseButtonColorV    = Vector(255,69,58,255)

surface.CreateFont("landis_base-default-14", {
	font = "Arial",
	weight = 2500,
	size = 14
})

surface.CreateFont("landis_base-default-20", {
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
	local mainColor = landis.Config.MainColor
	local bgColor   = landis.Config.BGColorDark
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 220 )
	surface.DrawRect( 0, 0, w, h )
	surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b )
	surface.DrawRect( 0, 0, w, 23 )
	surface.DrawOutlinedRect( 0, 23, w, h-23, 2 )
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
	local bgColor   = landis.Config.ButtonColorOff
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect( 0, 0, w, h )
end

function SKIN:PaintWindowMaximizeButton() end
function SKIN:PaintWindowMinimizeButton() end

function SKIN:PaintWindowCloseButton(self,w,h)
	if not self.ButtonHoldAlpha then
		self.ButtonHoldAlpha = 0
	end
	local mainColor = landis.Config.CloseButtonColor
	local bgColor   = landis.Config.ButtonColorOff
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
	blurDerma(self,200,10,20)
	local mainColor = landis.Config.MainColor
	local bgColor   = landis.Config.BGColorDark
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 220 )
	surface.DrawRect(  0, 20, w, h-20 )
	surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b )
	surface.DrawOutlinedRect( 0, 20, w, h-20, 2 )
end

function SKIN:PaintTab(self,w,h)
	
	if not self.hSND then
		self.hSND = false
	end
	if not self.pSND then
		self.pSND = false
	end
	if self:GetName() == "DNumberScratch" then return end
	local bgColor   = landis.Config.ButtonColorOff
	if self:IsHovered() then
		if not self.hSND then
			if landis.lib.GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/rollover.wav")) end
			self.hSND = true
		end
		bgColor = landis.Config.ButtonColorHovered
	else self.hSND = false end
	if self:IsDown() then
		if not self.pSND then
			if landis.lib.GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/press.wav")) end
			self.pSND = true
		end
		bgColor = landis.Config.ButtonColorOn
	else self.pSND = false end
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	local mainColor = landis.Config.MainColor
	if self:IsActive() then
		surface.SetDrawColor( mainColor.r, mainColor.g, mainColor.b )
	end
	surface.DrawRect(0, 0, w, 20)
end

--[[function SKIN:PaintScrollBarGrip(self,w,h)
	if not self.hSND then
		self.hSND = false
	end
	if not self.pSND then
		self.pSND = false
	end
	//if self:GetName() == "DNumberScratch" then return end
	//self:SetTextColor(color_white)
	local bgColor   = landis.Config.ButtonColorOff
	if self:IsHovered() then
		if not self.hSND then
			if landis.lib.GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/rollover.wav")) end
			self.hSND = true
		end
		//bgColor = landis.Config.ButtonColorHovered
	else self.hSND = false end
	/*if self:IsDown() then
		if not self.pSND then
			if landis.lib.GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/press.wav")) end
			self.pSND = true
		end
		bgColor = landis.Config.ButtonColorOn
	else self.pSND = false end*/
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintButtonUp(self,w,h)
	if not self.hSND then
		self.hSND = false
	end
	if not self.pSND then
		self.pSND = false
	end
	if self:GetName() == "DNumberScratch" then return end
	self:SetTextColor(color_white)
	local bgColor   = landis.Config.ButtonColorOff
	if self:IsHovered() then
		if not self.hSND then
			if landis.lib.GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/rollover.wav")) end
			self.hSND = true
		end
		bgColor = landis.Config.ButtonColorHovered
	else self.hSND = false end
	if self:IsDown() then
		if not self.pSND then
			if landis.lib.GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/press.wav")) end
			self.pSND = true
		end
		bgColor = landis.Config.ButtonColorOn
	else self.pSND = false end
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(255,255,255)
	local arrow = {
		{
			x = self:GetX() + w/4,
			y = self:GetY() + h/2
		},
		{
			x = self:GetX() + w/2,
			h = self:GetY() + h/4
		},
		{
			x = self:GetX() + w-w/4,
			h = self:GetY() + h/2
		},
		{
			x = self:GetX() + w/4,
			y = self:GetY() + h/2
		}
	}
	draw.NoTexture()
	surface.DrawPoly(arrow)
end

function SKIN:PaintVScrollBar(self,w,h)
	local bgColor   = landis.Config.ButtonColorHovered
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
end*/]]

function SKIN:PaintButton(self,w,h)
	if !self.m_bBackground then return end
	
	if not self.hSND then
		self.hSND = false
	end
	if not self.pSND then
		self.pSND = false
	end
	if not self.no then
		self.no = false
	end
	if not self.LerpPos then 
		self.LerpPos = 1
	end
	
	if self:GetName() == "DNumberScratch" then return end
	self.LerpPos = math.Clamp( self.LerpPos	+ FrameTime()*4, 0, 1)
	local bgColor   = landis.Config.ButtonColorOff
	if self:IsHovered() then
		if not self.hSND then
			if landis.lib.GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/rollover.wav")) end
			self.hSND = true
			self.LerpPos = 0
		end
		local c = LerpVector( self.LerpPos, landis.Config.ButtonColorOffV, landis.Config.ButtonColorHoveredV )
		bgColor = Color(c[1],c[2],c[3])
	else self.hSND = false end
	if self:IsDown() then
		if not self.pSND then
			if landis.lib.GetSetting("buttonClicks") then surface.PlaySound(Sound("helix/ui/press.wav")) end
			self.pSND = true
			self.LerpPos = 0
		end
		local c = LerpVector( self.LerpPos, landis.Config.ButtonColorHoveredV, landis.Config.ButtonColorOnV )
		bgColor = Color(c[1],c[2],c[3])
	else self.pSND = false end
	if not self.hSND and not self.pSND then
		if not self.no then
			self.no = true
			self.LerpPos = 0
		end
		local c = LerpVector( self.LerpPos, landis.Config.ButtonColorHoveredV, landis.Config.ButtonColorOffV )
		bgColor = Color(c[1],c[2],c[3])
	else
		self.no = false
	end

	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintTooltip(self,w,h)
	local bgColor = landis.Config.BGColorLight
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
end

local oldPaintMenuOption = derma.SkinList.Default.PaintMenuOption

function SKIN:PaintMenuOption(panel,w,h)
	panel:SetTextColor(color_black)
	if ( panel.m_bBackground && !panel:IsEnabled() ) then
		surface.SetDrawColor( Color( 0, 0, 0, 50 ) )
		surface.DrawRect( 0, 0, w, h )
		
	end

	if ( panel.m_bBackground && ( panel.Hovered || panel.Highlight) ) then
		self.tex.MenuBG_Hover( 0, 0, w, h )
		panel:SetTextColor(Color(80,80,80,255))
	end

	if ( panel:GetChecked() ) then
		self.tex.Menu_Check( 5, h / 2 - 7, 15, 15 )

	end
end

function SKIN:PaintComboBox(self,w,h)
	local bgColor   = landis.Config.ButtonColorOff
	if self:IsHovered() then
		bgColor = landis.Config.ButtonColorHovered
	end
	if self:IsDown() then
		bgColor = landis.Config.ButtonColorOn
	end
	surface.SetDrawColor( bgColor.r, bgColor.g, bgColor.b, 255 )
	surface.DrawRect(0, 0, w, h)
end





derma.DefineSkin("landis_base", "The default skin for landis.", SKIN)

-- lol look at tthe identifier
hook.Add("ForceDermaSkin", "foreskin", function()
	return "landis_base"
end)
derma.RefreshSkins()