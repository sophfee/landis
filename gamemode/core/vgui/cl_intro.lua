local PANEL = {}

local math = math
local floor = math.floor
local function getRandomSlideShow()
	local t = {}
	for v,k in RandomPairs(SCHEMA.MenuCamSlideShow) do
		table.ForceInsert(t, k)
	end
	return t
end
function PANEL:Init()
    SCHEMA:SetHUDElement("Crosshair",false)
	SCHEMA:SetHUDElement("Health",false)
	SCHEMA:SetHUDElement("Armor",false)
	SCHEMA:SetHUDElement("Ammo",false)
    hook.Add("HUDShouldDraw", "removeall", function(name)
		if not( name == "CHudGMod" )then return false end
	end)
    self:SetSize(ScrW(),ScrH())
    self:Center()
    self:MakePopup()
    self:SetText("")
end
function PANEL:Paint(w,h)

    draw.RoundedBox(0,0,0,w,h,Color(0,0,0,100))

    landis.blur(self,255,16,24)

    local c = landis.Config.MainColor
    draw.SimpleText(SCHEMA.Name or "Empty", "landis-128", w/2+5, h/2, Color(
		floor(c.r/2),
		floor(c.g/2),
		floor(c.b/2),
		floor(GlobalAlpha)
	), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,GlobalAlpha))

	draw.SimpleText(SCHEMA.Name or "Empty", "landis-128", w/2, h/2, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,GlobalAlpha))
    draw.SimpleText("Click anywhere to begin.","landis-24-S",w/2,h/2+64,Color(245,245,245),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

end

function PANEL:DoClick()
    MainMenu = MainMenu or vgui.Create("landisMainMenu")
    self:Remove()
end

landis.Splash = landis.Splash or nil

vgui.Register("landisSplash", PANEL, "DLabel")

net.Receive("landisStartMenu", function()
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
			angles = Slides[Current].ang + Angle(math.sin(CurTime()/2)*0.8,math.cos(CurTime())*1.2,0), --+ Angle((gui.MouseY()/ScrH())*45,(gui.MouseX()/ScrW())*45,0),
			fov = 70,
			drawviewer = true
		}
	end)
	landis.Splash = landis.Splash or vgui.Create("landisSplash")
end)