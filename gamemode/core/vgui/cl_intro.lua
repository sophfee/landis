local PANEL = {}

local math = math
local floor = math.floor

function PANEL:Init()
    self:SetSize(ScrW(),ScrH())
    self:Center()
    self:MakePopup()
    self:SetText("")
end
function PANEL:Paint(w,h)

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
    self:Remove()
end

vgui.Register("landisSplash", PANEL, "DLabel")

concommand.Add("landis_open_splash", function()
    local a = vgui.Create("landisSplash")
end)