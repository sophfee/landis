local hiddenElements = {
	CHudHealth = true,
	CHudBattery = true,
	CHudCrosshair = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudSquadStatus = true
}

hook.Add("HUDShouldDraw", "hudPlugin_hideDefault", function(elem)
	if hiddenElements[elem] then
		return false
	end
end)

surface.CreateFont("hud24", {
	font = "Arial",
	shadow = false,
	size = 24,
	weight = 6000,
	antialias = true,
	extended = true,
	italic = true
})

surface.CreateFont("hud18", {
	font = "Arial",
	shadow = false,
	size = 18,
	weight = 6000,
	antialias = true,
	extended = true,
	italic = true
})

local function drawBar(label,val,col,pos)
	local value = val*3
	local vert = {
		pos,
		{x=pos.x+value,y=pos.y},
		{x=pos.x+value+25,y=pos.y+25},
		{x=pos.x,y=pos.y+25}
	}
	local vertOutline = {
		{x=pos.x+2,y=pos.y+2},
		{x=pos.x+value+2,y=pos.y+2},
		{x=pos.x+value+27,y=pos.y+27},
		{x=pos.x+2,y=pos.y+27},
		{x=pos.x,y=pos.y+25}
	}
	local r,g,b = col:Unpack()
	surface.SetDrawColor(r/3, g/3, b/3,255)
	surface.DrawPoly(vertOutline)
	surface.SetDrawColor(r,g,b,255)
	surface.DrawPoly(vert)
	surface.SetMaterial(Material("vgui/gradient-l"))
	surface.SetDrawColor(r/3, g/3, b/3,120)
	surface.DrawTexturedRect(pos.x,pos.y,value,25)
	draw.DrawText(tostring(val), "hud24", pos.x+5, pos.y+2, Color(r/3, g/3, b/3,255), TEXT_ALIGN_LEFT)
	draw.DrawText(tostring(val), "hud24", pos.x+3, pos.y+1, color_white, TEXT_ALIGN_LEFT)
	draw.SimpleText(label, "hud18", pos.x+2, pos.y, Color(r/3, g/3, b/3,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	draw.SimpleText(label, "hud18", pos.x, pos.y-1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	draw.NoTexture()
end

local ply = LocalPlayer()
local r,g,b = color_white:Unpack()

hook.Add("HUDPaint", "hudPlugin_draw", function()
	if not IsValid(ply) then 
		ply = LocalPlayer()
		return 
	end
	if not ply:Alive() then return end
	drawBar("Health",ply:Health(),Color(255,0,0),{x=25,y=ScrH()-50})
	if ply:Armor() > 0 then drawBar("Armor",ply:Armor(),Color(50,173,230),{x=25,y=ScrH()-100}) end
end)