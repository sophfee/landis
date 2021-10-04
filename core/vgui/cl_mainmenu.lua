-- TODO: MOVE THIS TO A VGUI FOLDER!!

local PANEL = {}

surface.CreateFont("landis_base_main_menu_title", {
	font = "Arial",
	weight = 2500,
	extended = true,
	antialias = true,
	size = 80,
	shadow = true
})

surface.CreateFont("landis_base_main_menu_btn", {
	font = "Arial",
	weight = 2500,
	extended = true,
	antialias = true,
	size = 24,
	shadow = true
})
menuOpen = false
function PANEL:Init()
	if menuOpen then 
		self:Remove()
		return
	end
	menuOpen = true
	 hook.Add("HUDShouldDraw", "removeall", function(name)
		if not( name == "CHudGMod" )then return false end
	end)
	self:Dock(LEFT)
	self:SetSize(ScrW()/2,ScrH())
	self.Paint = function()
		local mainColor = landis.Config.MainColor
		draw.SimpleTextOutlined("landis Dev", "landis_base_main_menu_title", 10, ScrH()/2-82, mainColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
	end
	self.PlayBtn = vgui.Create("DButton", self, "landis_base-playbutton")
	self.PlayBtn:SetText("") // override the text for painted text
	self.OffsetPlayBtn = 0
	self.PlayBtn.HoveredSound = false
	self.PlayBtn.Paint = function(curPanel,w,h)
	local mainColor = landis.Config.MainColor
		if curPanel:IsHovered() then
			if not curPanel.HoveredSound then
				surface.PlaySound(Sound("helix/ui/rollover.wav"))
				curPanel.HoveredSound = true
			end
			self.OffsetPlayBtn = math.Clamp( self.OffsetPlayBtn + (64*FrameTime()), 0, 12)
		else
			curPanel.HoveredSound = false
			self.OffsetPlayBtn = math.Clamp( self.OffsetPlayBtn - (64*FrameTime()), 0, 12)
		end
		surface.SetDrawColor(mainColor.r, mainColor.g, mainColor.b, (self.OffsetPlayBtn/12)*255)
		surface.SetMaterial(Material("vgui/gradient-l"))
		surface.DrawTexturedRect(0, 0, w, h)
		draw.SimpleTextOutlined("Play", "landis_base_main_menu_btn", 8, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ))
	end
	function self.PlayBtn:DoClick()
		surface.PlaySound(Sound("helix/ui/press.wav"))
		hook.Remove("HUDShouldDraw", "removeall")
		menuOpen = false
		self:GetParent():Remove()
	end
	self.PlayBtn:SetSize(200,30)
	self.PlayBtn:SetPos(10,ScrH()/2+2)

	self.OptBtn = vgui.Create("DButton", self, "landis_base-optbutton")
	self.OptBtn:SetText("") // override the text for painted text
	self.OffsetOptBtn = 0
	self.OptBtn.HoveredSound = false
	self.OptBtn.Paint = function(curPanel,w,h)
		local mainColor = landis.Config.MainColor
		if self.OptBtn:IsHovered() then
			if not curPanel.HoveredSound then
				surface.PlaySound(Sound("helix/ui/rollover.wav"))
				curPanel.HoveredSound = true
			end
			self.OffsetOptBtn = math.Clamp( self.OffsetOptBtn + (64*FrameTime()), 0, 12)
		else
			curPanel.HoveredSound = false
			self.OffsetOptBtn = math.Clamp( self.OffsetOptBtn - (64*FrameTime()), 0, 12)
		end
		surface.SetDrawColor(mainColor.r, mainColor.g, mainColor.b, (self.OffsetOptBtn/12)*255)
		surface.SetMaterial(Material("vgui/gradient-l"))
		surface.DrawTexturedRect(0, 0, w, h)
		draw.SimpleTextOutlined("Options", "landis_base_main_menu_btn", 8, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ))
	end
	function self.OptBtn:DoClick()
		surface.PlaySound(Sound("helix/ui/press.wav"))
		local optPanel = vgui.Create("landisBaseSettings")
		optPanel:SetBackgroundBlur(true)

	end
	self.OptBtn:SetSize(200,30)
	self.OptBtn:SetPos(10,ScrH()/2+34)

	self:MakePopup()

end

vgui.Register("landisMainMenu", PANEL, "DPanel")

hook.Add("PlayerButtonDown", "landisMenuOpener", function(_,btn)
	if not menuOpen then
		if input.GetKeyName(btn) == "F1" then
			local p = vgui.Create("landisMainMenu")
			//p:SetBackgroundBlur(true)
		end
	end
end)

//local foo = vgui.Create("landisbaseMainMenu")
