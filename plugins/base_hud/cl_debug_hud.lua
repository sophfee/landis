local VERSION = landis.__VERSION or "DEV-BUILD"
local DISPLAY = landis.__DISPLAY or "LandisBase"
local XTNOTES = landis.__XTNOTES or [[]]
local DVBUILD = landis.__DVBUILD or false

surface.CreateFont("DebugHUD24", {
	font = "Arial",
	antialias = true,
	extended = true,
	weight = 4500,
	size = 24
})
surface.CreateFont("DebugHUD18", {
	font = "Arial",
	antialias = true,
	extended = true,
	weight = 4500,
	size = 18
})

hook.Add("HUDPaint", "DebugHud_LANDIS", function()
	if not DVBUILD then return end
	draw.DrawText(DISPLAY .. " - " .. VERSION, "DebugHUD24", 5, 5, Color( 230, 230, 230, 150 ))
	draw.DrawText(XTNOTES, "DebugHUD18", 5, 29, Color( 230, 230, 230, 150 ))
end)