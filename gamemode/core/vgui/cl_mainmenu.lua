local PANEL = {}
local math = math
local floor = math.floor

MainMenuMusic = nil

menuOpen = false
GlobalAlpha = 255
function PANEL:Init()
	if menuOpen then 
		self:Remove()
		return
	end
	MainMenuMusic = MainMenuMusic or CreateSound(LocalPlayer(), "music/hl2_intro.mp3")
	MainMenuMusic:Play()
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
		if SCHEMA.MenuHideTitle then return end
		local mainColor = table.Copy(landis.Config.MainColor)
		mainColor.a = GlobalAlpha
		c = mainColor
		local GlowColor = HSVToColor( (CurTime()*24) % 360, 1, 1 )
		GlowColor.a = GlobalAlpha
		draw.SimpleText(SCHEMA.Name or "Empty", "landis-96", 105, ScrH()/2-100, Color(
			floor(c.r/2),
			floor(c.g/2),
			floor(c.b/2),
			floor(GlobalAlpha)
		), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,GlobalAlpha))
		draw.SimpleText(SCHEMA.Name or "Empty", "landis-96", 100, ScrH()/2-100, mainColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,GlobalAlpha))
		if not SCHEMA.IsPreview then return end
		draw.SimpleText("Preview Build", "landis-24", 107, ScrH()/2-20, Color(128,128,0,GlobalAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,GlobalAlpha))
		draw.SimpleText("Preview Build", "landis-24", 105, ScrH()/2-20, Color(255,255,0,GlobalAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,GlobalAlpha))
	end
	self.PlayBtn = vgui.Create("landisMainMenuButton", self, "landis_base-playbutton")
	function self.PlayBtn:WhenPressed()
		if LocalPlayer():GetRPName() == LocalPlayer():Nick() then
			Derma_StringRequest("#landis.rpname.title","#landis.rpname.subtitle","#landis.rpname.default",function(name)
				net.Start("landisRPNameChange")
					net.WriteString(name)
				net.SendToServer()
				MainMenuMusic:FadeOut(1.125)
				hook.Remove("HUDShouldDraw", "removeall")
		
				MainMenu = nil
				fadeOut = true
				LocalPlayer():ScreenFade(SCREENFADE.OUT, Color(0,0,0), 1, 0.25)
				self:SetEnabled(false) -- prevent multiple clicking
				timer.Simple(1.125, function()
					gui.EnableScreenClicker(false)
					menuOpen = false
					LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0)
			
					SCHEMA:SetHUDElement("Crosshair",true)
					SCHEMA:SetHUDElement("Health",true)
					SCHEMA:SetHUDElement("Armor",true)
					SCHEMA:SetHUDElement("Ammo",true)
					hook.Remove("CalcView", "landisMAINMENUCALCVIEW")
					self:GetParent():Remove()
				end)
			end)
		else
			MainMenuMusic:FadeOut(1.125)
			hook.Remove("HUDShouldDraw", "removeall")
		
			MainMenu = nil
			fadeOut = true
			LocalPlayer():ScreenFade(SCREENFADE.OUT, Color(0,0,0), 1, 0.25)
			self:SetEnabled(false) -- prevent multiple clicking
			timer.Simple(1.125, function()
				gui.EnableScreenClicker(false)
				menuOpen = false
				LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0)
			
				SCHEMA:SetHUDElement("Crosshair",true)
				SCHEMA:SetHUDElement("Health",true)
				SCHEMA:SetHUDElement("Armor",true)
				SCHEMA:SetHUDElement("Ammo",true)
				hook.Remove("CalcView", "landisMAINMENUCALCVIEW")
				self:GetParent():Remove()
			end)
		end
		
	end
	self.PlayBtn:SetPos(100,ScrH()/2+2)
	self.PlayBtn:SetDisplayText("Play")

	self.OptBtn = vgui.Create("landisMainMenuButton", self, "landis_base-optbutton")

	function self.OptBtn:WhenPressed()
		local optPanel = vgui.Create("landisBaseSettings")
		optPanel:SetBackgroundBlur(true)
	end
	self.OptBtn:SetDisplayText("Settings")
	self.OptBtn:SetPos(100,ScrH()/2+34)

	self.Credits = vgui.Create("landisMainMenuButton", self, "landis_base-optbutton")

	function self.Credits:WhenPressed()
		Derma_Message("made by Nick :D (@urnotnick on github)","Credits!","epic!")
	end
	self.Credits:SetDisplayText("Credits")
	self.Credits:SetPos(100,ScrH()/2+68)

	
	self.github = vgui.Create("landisMainMenuButton", self, "landis_base-optbutton")

	function self.github:WhenPressed()
		gui.OpenURL("https://github.com/urnotnick/landis")
	end
	self.github:SetDisplayText("GitHub")
	self.github:SetPos(100,ScrH()/2+102)


	self.Disconnect = vgui.Create("landisMainMenuButton", self, "landis_base-optbutton")

	function self.Disconnect:WhenPressed()
		RunConsoleCommand("disconnect")
	end
	self.Disconnect:SetDisplayText("Disconnect")
	self.Disconnect:SetPos(100,ScrH()/2+140)

	--self:ParentToHUD()
	--gui.EnableScreenClicker(true)
	
	self:MakePopup()

	

end

vgui.Register("landisMainMenu", PANEL, "DPanel")

MainMenu = MainMenu or nil

local function getRandomSlideShow()
	local t = {}
	for v,k in RandomPairs(SCHEMA.MenuCamSlideShow) do
		table.ForceInsert(t, k)
	end
	return t
end

net.Receive("landisStartMenu", function()
	--Derma_Message("Hello! Welcome to Landis Development Build 0.2\n\nThis is an experimental version of the Landis framework, things may tend to destroy themselves.\nBugs may occur! This is normal for a development build. Make sure to report them!\n\nOverall, have fun toying with the new tools!\n\nEnjoy!\n- Nick","Welcome to the Landis Framework!","Let me play now!")
	--surface.PlaySound(Sound("music/hl2_intro.mp3"))
	timer.Simple(0.5, function()
		MainMenu = MainMenu or vgui.Create("landisMainMenu")
		Slides = getRandomSlideShow()
		CanChangeAt= CurTime() + 18
		Current    = 1
		hook.Add("CalcView", "landisMAINMENUCALCVIEW", function()
			if CurTime() > CanChangeAt then
				CanChangeAt = CurTime() + 18
				LocalPlayer():ScreenFade(SCREENFADE.OUT, Color(0,0,0), 1, 0.25)
				timer.Simple(1.125, function()
					LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0.25)
					Current = Current + 1
					if Current > #Slides then
						Current = 1
					end
				end)
			end
			return {
				origin = Slides[Current].pos,
				angles = Slides[Current].ang, --+ Angle((gui.MouseY()/ScrH())*45,(gui.MouseX()/ScrW())*45,0),
				fov = 70,
				drawviewer = true
			}
		end)
	end)
end)

hook.Add("PlayerButtonDown", "landisMenuOpener", function(_,btn)
	if not menuOpen then
		if btn == KEY_F1 then
			MainMenu = MainMenu or vgui.Create("landisMainMenu")
		end
	end
end)
