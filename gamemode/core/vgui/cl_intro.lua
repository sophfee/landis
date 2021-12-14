local PANEL = {}

function PANEL:Init()
    LocalPlayer():ScreenFade(SCREENFADE.IN,color_black,1,0)

end

vgui.Register("landisSplash", PANEL, "Panel")