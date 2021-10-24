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
	hook.Add("CalcView", "landisMAINMENUCALCVIEW", function()
		return {
			origin = SCHEMA.MenuCamPos,
			angles = SCHEMA.MenuCamAng,
			fov = 70,
			drawviewer = true
		}
	end)
	if menuOpen then 
		self:Remove()
		return
	end
	SCHEMA:SetHUDElement("Crosshair",false)
	SCHEMA:SetHUDElement("Health",false)
	SCHEMA:SetHUDElement("Armor",false)
	SCHEMA:SetHUDElement("Ammo",false)
	menuOpen = true
	 hook.Add("HUDShouldDraw", "removeall", function(name)
		if not( name == "CHudGMod" )then return false end
	end)
	local GlobalAlpha = 255
	local fadeOut = false
	self:Dock(LEFT)
	self:SetSize(ScrW(),ScrH())
	self.Paint = function()
		if fadeOut then
			GlobalAlpha = math.Clamp(GlobalAlpha-FrameTime()*255, 0, 255)
		end
		local mainColor = landis.Config.MainColor
		draw.SimpleTextOutlined(SCHEMA.Name, "landis_base_main_menu_title", ScrW()/2, ScrH()/2-82, HSVToColor( (CurTime()*50) % 360, 1, 1 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,GlobalAlpha))
		if not SCHEMA.IsPreview then return end
		draw.SimpleTextOutlined("Preview Build", "landis_base_main_menu_btn", ScrW()/2, ScrH()/2-20, Color(255,255,0,GlobalAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,GlobalAlpha))
	end
	self.PlayBtn = vgui.Create("DButton", self, "landis_base-playbutton")
	self.PlayBtn:SetText("") // override the text for painted text
	self.OffsetPlayBtn = 0
	self.PlayBtn.HoveredSound = false
	self.PlayBtn.Paint = function(curPanel,w,h)
	local mainColor = landis.Config.MainColor
		if curPanel:IsHovered() then
			if not curPanel.HoveredSound then
				surface.PlaySound(Sound("ui/buttonrollover.wav"))
				curPanel.HoveredSound = true
			end
			self.OffsetPlayBtn = math.Clamp( self.OffsetPlayBtn + (64*FrameTime()), 0, 12)
		else
			curPanel.HoveredSound = false
			self.OffsetPlayBtn = math.Clamp( self.OffsetPlayBtn - (64*FrameTime()), 0, 12)
		end
		
		local r = Lerp((self.OffsetPlayBtn/12), 255, mainColor.r)
		local g = Lerp((self.OffsetPlayBtn/12), 255, mainColor.g)
		local b = Lerp((self.OffsetPlayBtn/12), 255, mainColor.b)
		draw.SimpleTextOutlined("Play", "landis_base_main_menu_btn", 100, h/2, Color( r, g, b, GlobalAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, GlobalAlpha ))
	end
	function self.PlayBtn:DoClick()
		surface.PlaySound(Sound("ui/buttonclickrelease.wav"))
		hook.Remove("HUDShouldDraw", "removeall")
		menuOpen = false
		MainMenu = nil
		fadeOut = true
		LocalPlayer():ScreenFade(SCREENFADE.OUT, Color(0,0,0), 1, 0.25)
		timer.Simple(1.125, function()
			LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0)
			SCHEMA:SetHUDElement("Crosshair",true)
			SCHEMA:SetHUDElement("Health",true)
			SCHEMA:SetHUDElement("Armor",true)
			SCHEMA:SetHUDElement("Ammo",true)
			hook.Remove("CalcView", "landisMAINMENUCALCVIEW")
			self:GetParent():Remove()
		end)
	end
	self.PlayBtn:SetSize(200,30)
	self.PlayBtn:SetPos(ScrW()/2-100,ScrH()/2+2)

	self.OptBtn = vgui.Create("DButton", self, "landis_base-optbutton")
	self.OptBtn:SetText("") // override the text for painted text
	self.OffsetOptBtn = 0
	self.OptBtn.HoveredSound = false
	self.OptBtn.Paint = function(curPanel,w,h)
		local mainColor = landis.Config.MainColor
		if self.OptBtn:IsHovered() then
			if not curPanel.HoveredSound then
				surface.PlaySound(Sound("ui/buttonrollover.wav"))
				curPanel.HoveredSound = true
			end
			self.OffsetOptBtn = math.Clamp( self.OffsetOptBtn + (64*FrameTime()), 0, 12)
		else
			curPanel.HoveredSound = false
			self.OffsetOptBtn = math.Clamp( self.OffsetOptBtn - (64*FrameTime()), 0, 12)
		end
		local r = Lerp((self.OffsetOptBtn/12), 255, mainColor.r)
		local g = Lerp((self.OffsetOptBtn/12), 255, mainColor.g)
		local b = Lerp((self.OffsetOptBtn/12), 255, mainColor.b)
		
		draw.SimpleTextOutlined("Options", "landis_base_main_menu_btn", 100, h/2, Color( r, g, b, GlobalAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, GlobalAlpha ))
	end
	function self.OptBtn:DoClick()
		surface.PlaySound(Sound("ui/buttonclickrelease.wav"))
		local optPanel = vgui.Create("landisBaseSettings")
		optPanel:SetBackgroundBlur(true)

	end
	self.OptBtn:SetSize(200,30)
	self.OptBtn:SetPos(ScrW()/2-100,ScrH()/2+34)

	self:MakePopup()

end

vgui.Register("landisMainMenu", PANEL, "DPanel")

MainMenu = MainMenu or nil

net.Receive("landisStartMenu", function()
	surface.PlaySound(Sound("music/hl2_intro.mp3"))
	MainMenu = MainMenu or vgui.Create("landisMainMenu")
end)

hook.Add("PlayerButtonDown", "landisMenuOpener", function(_,btn)
	if not menuOpen then
		if btn == KEY_F1 then
			MainMenu = MainMenu or vgui.Create("landisMainMenu")
		end
	end
end)
