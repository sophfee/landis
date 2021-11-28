local VERSION = landis.__VERSION or "DEV-BUILD"
local DISPLAY = landis.__DISPLAY or "LandisBase"
local XTNOTES = landis.__XTNOTES or [[]]
local DVBUILD = landis.__DVBUILD or false

surface.CreateFont("DebugHUD24", {
	font = "Segoe UI Bold",
	antialias = true,
	extended = true,
	weight = 4500,
	size = 36
})
surface.CreateFont("DebugHUD18", {
	font = "Segoe UI Light",
	antialias = true,
	extended = true,
	weight = 4500,
	size = 24
})

hook.Add("HUDPaint", "DebugHud_LANDIS", function()
	if not DVBUILD then return end
	draw.DrawText(DISPLAY .. " - " .. VERSION, "DebugHUD24", ScrW()-5, 5, Color( 230, 230, 230, 150 ),TEXT_ALIGN_RIGHT)
	draw.DrawText(XTNOTES, "DebugHUD18", ScrW()-5, 41, Color( 230, 230, 230, 150 ),TEXT_ALIGN_RIGHT)
end)