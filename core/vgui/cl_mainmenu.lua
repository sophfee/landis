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
GlobalAlpha = 255
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
	GlobalAlpha = 255
	local fadeOut = false
	self:Dock(LEFT)
	self:SetSize(ScrW(),ScrH())
	self.Paint = function()
		if fadeOut then
			GlobalAlpha = math.Clamp(GlobalAlpha-FrameTime()*255, 0, 255)
		end
		local mainColor = landis.Config.MainColor
		local GlowColor = HSVToColor( (CurTime()*24) % 360, 1, 1 )
		GlowColor.a = GlobalAlpha
		draw.SimpleTextOutlined(SCHEMA.Name or "Empty", "landis_base_main_menu_title", ScrW()/2, ScrH()/2-82, GlowColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,GlobalAlpha))
		if not SCHEMA.IsPreview then return end
		draw.SimpleTextOutlined("Preview Build", "landis_base_main_menu_btn", ScrW()/2, ScrH()/2-20, Color(255,255,0,GlobalAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,GlobalAlpha))
	end
	self.PlayBtn = vgui.Create("landisMainMenuButton", self, "landis_base-playbutton")
	function self.PlayBtn:WhenPressed()
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
	self.PlayBtn:SetPos(ScrW()/2-100,ScrH()/2+2)
	self.PlayBtn:SetDisplayText("Play")

	self.OptBtn = vgui.Create("landisMainMenuButton", self, "landis_base-optbutton")

	function self.OptBtn:WhenPressed()
		local optPanel = vgui.Create("landisBaseSettings")
		optPanel:SetBackgroundBlur(true)
	end
	self.OptBtn:SetDisplayText("Settings")
	self.OptBtn:SetPos(ScrW()/2-100,ScrH()/2+34)

	self.Credits = vgui.Create("landisMainMenuButton", self, "landis_base-optbutton")

	function self.Credits:WhenPressed()
		Derma_Message("made by Nick :D (@urnotnick on github)","Credits!","epic!")
	end
	self.Credits:SetDisplayText("Credits")
	self.Credits:SetPos(ScrW()/2-100,ScrH()/2+68)

	
	self.github = vgui.Create("landisMainMenuButton", self, "landis_base-optbutton")

	function self.github:WhenPressed()
		gui.OpenURL("https://github.com/urnotnick/landis")
	end
	self.github:SetDisplayText("GitHub")
	self.github:SetPos(ScrW()/2-100,ScrH()/2+102)


	self.Disconnect = vgui.Create("landisMainMenuButton", self, "landis_base-optbutton")

	function self.Disconnect:WhenPressed()
		RunConsoleCommand("disconnect")
	end
	self.Disconnect:SetDisplayText("Disconnect")
	self.Disconnect:SetPos(ScrW()/2-100,ScrH()/2+140)

	self:MakePopup()

	

end

vgui.Register("landisMainMenu", PANEL, "DPanel")

MainMenu = MainMenu or nil

net.Receive("landisStartMenu", function()
	Derma_Message("Hello! Welcome to Landis Development Build 0.2\n\nThis is an experimental version of the Landis framework, things may tend to destroy themselves.\nBugs may occur! This is normal for a development build. Make sure to report them!\n\nOverall, have fun toying with the new tools!\n\nEnjoy!\n- Nick","Welcome to the Landis Framework!","Let me play now!")
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
