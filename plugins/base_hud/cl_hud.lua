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

surface.CreateFont("hud36", {
	font = "Arial",
	shadow = false,
	size = 36,
	weight = 6000,
	antialias = true,
	extended = true,
	italic = false
})

local function drawBar(label,val,col,pos)
	local value = val*3

	local vert = {
		pos,
		{ x = pos.x + 300, y = pos.y },
		{x=pos.x+300+25,y=pos.y + 25 },
		{x=pos.x,y=pos.y+25}
	}
	local vertOutline = {
		{x=pos.x+300+2,y=pos.y+2},
		{x=pos.x+300+27,y=pos.y+27},
		{x=pos.x+2,y=pos.y+27},
		{x=pos.x,y=pos.y+25}
	}
	local r,g,b = col:Unpack()

	surface.SetDrawColor(80/2, 80/2, 80/2,255)
	surface.DrawPoly(vertOutline)

	surface.SetDrawColor(80,80,80,255)
	surface.DrawPoly(vert)

	surface.SetMaterial(Material("vgui/gradient-l"))
	surface.SetDrawColor(r/3, g/3, b/3,120)

	surface.DrawTexturedRect(pos.x,pos.y,300,25)

	draw.NoTexture()

	local vert = {
		pos,
		{x=pos.x+value,y=pos.y},
		{x=pos.x+value+25, y = pos.y + 25},
		{x=pos.x, y = pos.y + 25 }
	}
	local vertOutline = {
		{ x = pos.x + value + 2, y = pos.y + 2 },
		{ x = pos.x + value + 27, y = pos.y + 27 },
		{ x = pos.x + 2, y = pos.y + 27 },
		{ x = pos.x, y = pos.y + 25 }
	}

	surface.SetDrawColor( r / 3, g / 3, b / 3, 255 )
	surface.DrawPoly( vertOutline )
	surface.SetDrawColor( r, g, b, 255 )
	surface.DrawPoly( vert )
	surface.SetMaterial( Material( "vgui/gradient-l" ) )
	surface.SetDrawColor( r / 2, g / 2, b / 2, 100 )
	surface.DrawTexturedRect( pos.x, pos.y, value, 25 )

	draw.DrawText( tostring( math.Round( val, 0 ) ), "hud24", pos.x + 5, pos.y + 2, Color( r / 8, g / 8, b / 8, 255 ), TEXT_ALIGN_LEFT )
	draw.DrawText( tostring( math.Round( val, 0 )), "hud24", pos.x + 3, pos.y + 1, color_white, TEXT_ALIGN_LEFT )
	draw.SimpleText( label, "hud18", pos.x + 2, pos.y, Color( r / 8, g / 8, b / 8, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( label, "hud18", pos.x, pos.y - 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	draw.NoTexture()

end

local function drawBarFlipped(label,val,col,pos)
	local value = val*3

	local vert = {
		{
			x = pos.x,
			y = pos.y + 25
		},
		{
			x = pos.x + 25,
			y = pos.y
		},
		{
			x = pos.x + 300,
			y = pos.y
		},
		{
			x = pos.x + 300,
			y = pos.y + 25
		}
	}
	local vertOutline = {
		--{x=pos.x+2,y=pos.y+2},
		{x=pos.x+300-2,y=pos.y+2},
		{x=pos.x+300-27,y=pos.y+27},
		{x=pos.x-2,y=pos.y+27},
		{x=pos.x,y=pos.y+25}
	}
	local r,gC,b = col:Unpack()
	surface.SetDrawColor(80/2, 80/2, 80/2,255)
	surface.DrawPoly(vertOutline)
	surface.SetDrawColor(80,80,80,255)
	surface.DrawPoly(vert)
	surface.SetMaterial(Material("vgui/gradient-l"))
	surface.SetDrawColor(r/3, gC/3, b/3,120)
	surface.DrawTexturedRect(pos.x,pos.y,300,25)
	//draw.DrawText(tostring(val), "hud24", pos.x+5, pos.y+2, Color(r/3, gC/3, b/3,255), TEXT_ALIGN_LEFT)
	//draw.DrawText(tostring(val), "hud24", pos.x+3, pos.y+1, color_white, TEXT_ALIGN_LEFT)
	//raw.SimpleText(label, "hud18", pos.x+2, pos.y, Color(r/3, gC/3, b/3,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	//draw.SimpleText(label, "hud18", pos.x, pos.y-1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	draw.NoTexture()
	local vert = {
		pos,
		{x=pos.x-value,y=pos.y},
		{x=pos.x-value-25,y=pos.y+25},
		{x=pos.x,y=pos.y+25}
	}
	local vertOutline = {
		--{x=pos.x+2,y=pos.y+2},
		{x=pos.x+value+2,y=pos.y+2},
		{x=pos.x+value+27,y=pos.y+27},
		{x=pos.x+2,y=pos.y+27},
		{x=pos.x,y=pos.y+25}
	}
	local r,gC,b = col:Unpack()
	surface.SetDrawColor(r/3, gC/3, b/3,255)
	//surface.DrawPoly(vertOutline)
	surface.SetDrawColor(r,gC,b,255)
	surface.DrawPoly(vert)
	surface.SetMaterial(Material("vgui/gradient-r"))
	surface.SetDrawColor(r/2, gC/2, b/2,100)
	//surface.DrawTexturedRect(pos.x,pos.y,value,25)
	draw.DrawText(tostring(val), "hud24", pos.x+5, pos.y+2, Color(r/8, gC/8, b/8,255), TEXT_ALIGN_LEFT)
	draw.DrawText(tostring(val), "hud24", pos.x+3, pos.y+1, color_white, TEXT_ALIGN_LEFT)
	draw.SimpleText(label, "hud18", pos.x+2, pos.y, Color(r/8, gC/8, b/8,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	draw.SimpleText(label, "hud18", pos.x, pos.y-1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	draw.NoTexture()
end

local ply = LocalPlayer()
local r,gC,b = color_white:Unpack()

local whiteColor = Vector(255,255,255)
local redColor   = Vector(255,0,0)

surface.CreateFont("DEAD", {
	font = "Arial",
	size = 80,
	weight = 1000,
	antialias = true,
	extended = true
})

local youAreDeadAlpha = 0

hook.Add("HUDPaint", "hudPlugin_draw", function()
	if not IsValid(ply) then 
		ply = LocalPlayer()
		return 
	end

	--if ply:NoClipping

	if not ply:Alive() then
		youAreDeadAlpha = math.Clamp( youAreDeadAlpha + FrameTime() * 50, 0, 255 )
		draw.SimpleText("YOU ARE DEAD", "DEAD", ScrW()/2, ScrH()/2, Color( 255, 255, 255, youAreDeadAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
		return 
	end

	surface.SetDrawColor( 255, 255, 255 )
	local centerW = ScrW()/2
	local centerH = ScrH()/2
	local len     = landis.lib.GetSetting("crosshairLength")
	local gap     = landis.lib.GetSetting("crosshairGap")
	surface.DrawRect( centerW, centerH + 1 + gap, 1, len)
	surface.DrawRect( centerW + 1 + gap, centerH, len, 1 )
	surface.DrawRect( centerW, centerH - gap - len, 1, len)
	surface.DrawRect( centerW - gap - len, centerH, len, 1 )

	
	drawBar("Health",(ply:Health()/ply:GetMaxHealth())*100,Color(255,0,0),{x=25,y=ScrH()-50})
	//drawBar("Stamina",ply:GetNWFloat("Stamina"),Color(50,173,230),{x=25,y=ScrH()-100})
	if ply:Armor() > 0 then drawBar("Armor",ply:Armor(),Color(50,173,230),{x=25,y=ScrH()-100}) end
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) then
		if wep.DrawAmmo then

			local str = "<font=hud36><colour=90,90,90>"
			for i=1, 3-( #tostring( wep:Clip1() ) ) do str = str .. "0" end
			local colV = wep:Clip1() / wep:GetMaxClip1() < 0.334 and LerpVector(math.sin(math.abs(CurTime()*8))/math.pi, redColor, whiteColor) or whiteColor
			--print(colV)
			local floor = math.floor
			local col = floor(colV.x) .. "," .. floor(colV.y) .. "," .. floor(colV.z)
			--print(col)
			str = str .. "</colour><colour="..col..">" ..  wep:Clip1() .. "</colour><colour=255,255,255>/" .. "</colour><colour=90,90,90>" 
			for i=1, 3-( #tostring( wep:Ammo1() ) ) do str = str .. "0" end
			str = str .. "</colour><colour=255,255,255>" ..  wep:Ammo1() .. "</colour></font>" 

			local markupObj = markup.Parse( str )
			markupObj:Draw(ScrW()-25, ScrH()-25,TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM,255)

			--draw.SimpleText( "000/000" , "hud36", ScrW()-25, ScrH()-25, Color( 90, 90, 90, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			--draw.SimpleText( string.sub(tostring(wep:Clip1() + 1000),2,4) .. "/" .. string.sub(tostring(wep:Ammo1() + 1000),2,4) , "hud36", ScrW()-25, ScrH()-25, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

		end
	end
end)
