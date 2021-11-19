local hiddenElements = {
	CHudHealth = true,
	CHudBattery = true,
	CHudCrosshair = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudSquadStatus = true,
	CHudWeaponSelection = true
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
local isAlive = false
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

concommand.Add("fix_death", function()
	topText:Remove()
end)

tweenInTable = {alpha=0}
tweenOutTable = {alpha=1}
local tweenIn = tween.new(1.75,tweenInTable,{alpha=1},'outBounce')
local tweenOut = tween.new(0.85,tweenOutTable,{alpha=0},'outQuint')
local deathTime = 0

hook.Add("HUDPaint", "hudPlugin_draw", function()
	if not IsValid(ply) then 
		ply = LocalPlayer()
		return 
	end

	if ply:InNoclip() then

		draw.DrawText("Moderation View", "landis-24", 5, 5, Color( 230, 230, 230, 180 ))

		local msg = [[Playercount: ]]
		msg=msg..tostring(player.GetCount())

		draw.DrawText(msg, "landis-18", 5, 29, Color( 230, 230, 230, 180 ))

		if landis.lib.GetSetting("mod-esp") then
			for v,k in ipairs(player.GetAll()) do
				if k == LocalPlayer() then continue end
				local viewData = (k:OBBCenter()+k:GetPos()):ToScreen()
				if viewData.visible then
					draw.SimpleText(k:Nick(), "entname", viewData.x, viewData.y, team.GetColor(k:Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		end
	end

	

	if SCHEMA:ShouldDrawElement( "Crosshair" ) then
		surface.SetDrawColor( 255, 255, 255 )
		local centerW = ScrW()/2
		local centerH = ScrH()/2
		local len     = landis.lib.GetSetting("crosshairLength")
		local gap     = landis.lib.GetSetting("crosshairGap")
		surface.DrawRect( centerW, centerH + 1 + gap, 1, len)
		surface.DrawRect( centerW + 1 + gap, centerH, len, 1 )
		surface.DrawRect( centerW, centerH - gap - len, 1, len)
		surface.DrawRect( centerW - gap - len, centerH, len, 1 )
	end
	
	if SCHEMA:ShouldDrawElement( "Health" ) then drawBar("Health",(ply:Health()/ply:GetMaxHealth())*100,Color(255,0,0),{x=25,y=ScrH()-50}) end

	if SCHEMA:ShouldDrawElement( "Armor" ) then if ply:Armor() > 0 then drawBar("Armor",ply:Armor(),Color(50,173,230),{x=25,y=ScrH()-100}) end end

	if SCHEMA:ShouldDrawElement( "Ammo") then
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) then
			if wep.DrawAmmo then

				local str = "<font=hud36><colour=90,90,90>"
				for i=1, 3-( #tostring( wep:Clip1() ) ) do str = str .. "0" end
				local colV = wep:Clip1() / wep:GetMaxClip1() < 0.334 and LerpVector(math.sin(math.abs(CurTime()*8))/math.pi, redColor, whiteColor) or whiteColor
			
				local floor = math.floor
				local col = floor(colV.x) .. "," .. floor(colV.y) .. "," .. floor(colV.z)
			
				str = str .. "</colour><colour="..col..">" ..  wep:Clip1() .. "</colour><colour=255,255,255>/" .. "</colour><colour=90,90,90>" 
				for i=1, 3-( #tostring( wep:Ammo1() ) ) do str = str .. "0" end
				str = str .. "</colour><colour=255,255,255>" ..  wep:Ammo1() .. "</colour></font>" 

				local markupObj = markup.Parse( str )
				markupObj:Draw(ScrW()-25, ScrH()-25,TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM,255)

			end
		end
	end
	--if not ply:Alive() == isAlive then tweenIn:set(0) end
	--if not ply:Alive() == isAlive then tweenOut:set(1) end

	if not ply:Alive() then
		if not ply:Alive() == isAlive then 
			tweenIn:set(0) 
			deathTime = 0
			timer.Simple(1.6, function()
				for i=1,30 do
					landis.Smoke2D((ScrW()/30)*(i-1)+math.Rand(-30, 30),ScrH()/2-80)
				end
			end)
		end
		deathTime = deathTime + FrameTime()
		hiddenElements["CHudDamageIndicator"] = true 
		if deathTime > 1 then
			tweenIn:update(FrameTime())
			local flatAlpha = math.Clamp(tweenInTable.alpha, 0, 255)

			draw.RoundedBox(0, 0, 0, ScrW(), (ScrH()/2)*flatAlpha, team.GetColor(LocalPlayer():Team()))
			draw.RoundedBox(0, 0, ScrH()-((ScrH()/2)*flatAlpha), ScrW(), (ScrH()/2), team.GetColor(LocalPlayer():Team()))

			draw.SimpleTextOutlined("YOU ARE DEAD", "DEAD", ScrW()/2, ScrH()/2, Color( 255, 255, 255, flatAlpha * 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,flatAlpha)) 

			
			draw.SimpleText(flatAlpha,"BudgetLabel")
		end

	else

		if not ply:Alive() == isAlive then 
			tweenOut:set(0) 
		end

		tweenOut:update(FrameTime())

		draw.RoundedBox(0, 0, 0, ScrW(), (ScrH()/2)*tweenOutTable.alpha, team.GetColor(LocalPlayer():Team()))
		draw.RoundedBox(0, 0, ScrH()-((ScrH()/2)*tweenOutTable.alpha), ScrW(), (ScrH()/2), team.GetColor(LocalPlayer():Team()))

		draw.SimpleTextOutlined("YOU ARE DEAD", "DEAD", ScrW()/2, ScrH()/2, Color( 255, 255, 255, tweenOutTable.alpha * 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,tweenOutTable.alpha))

		hiddenElements["CHudDamageIndicator"] = nil
		draw.SimpleText(math.floor(tweenOutTable.alpha),"BudgetLabel")

	end
	isAlive = ply:Alive()
end)
