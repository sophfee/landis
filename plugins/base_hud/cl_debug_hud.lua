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

local function GetDebugHUDText()
	local t = "[Debug Info]\n"
	
	t=t.."usergroup: " .. LocalPlayer():GetUserGroup() .. "\n"
	t=t.."schema: " .. landis.Schema.Name .. "\n" -- deathTime
	t=t.."ping: " .. LocalPlayer():Ping() .. "\n"
	t=t.."isTyping: " .. tostring(LocalPlayer():IsTyping()) .. "\n"
	t=t.."radialMenuOpen: " .. tostring(not landis.Radial.Close) .. "\n"
	t=t.."radialMenuRadius: " .. landis.Radial.Radius .. "\n"
	t=t.."deathTime: " .. deathTime .. "\n"
	t=t.."teamIndex: " .. landis.TeamIndex

	return t
end

hook.Add("HUDPaint", "DebugHud_LANDIS", function()
	if not DVBUILD then return end
	draw.DrawText(DISPLAY .. " - " .. VERSION, "DebugHUD24", ScrW()-5, 5, Color( 230, 230, 230, 150 ),TEXT_ALIGN_RIGHT)
	draw.DrawText(XTNOTES, "DebugHUD18", ScrW()-5, 41, Color( 230, 230, 230, 150 ),TEXT_ALIGN_RIGHT)
	if landis.lib.GetSetting("debugHUD") then
		draw.DrawText(GetDebugHUDText(), "BudgetLabel", 16, 16)
	end
end)

concommand.Add("landis_debug_dump", function()
	print("=====[DEBUG TABLE DUMP]=====")
	PrintTable(landis)
	print("=====[END DUMP]=====")
end)