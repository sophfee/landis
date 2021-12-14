-- in progress, will probably break

landis.Radial = {}

landis.Radial.Radius = 0

landis.Radial.RadiusTween = tween.new(0.5,landis.Radial,{Radius=255},"outBack")

landis.Radial.Time = 0

landis.Radial.Close = true

landis.Radial.Opts = {}

-- taken from: https://wiki.facepunch.com/gmod/surface.DrawPoly
-- im a lazy fuck
function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

local function DrawOption(index,label)
    
    local radius = landis.Radial.Radius
    local a = math.rad( (index/8) * -360 )
    local x = ScrW()/2
    local y = ScrH()/2
    surface.SetDrawColor(landis.Config.MainColor)
    local cir = {}
    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    local a = math.rad( ((index+1)/8) * -360 )
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    surface.DrawPoly(cir)
end

local function HoveringOption()
    local MouseX = gui.MouseX()
    local MouseY = gui.MouseY()
    local x = ScrW()/2
    local y = ScrH()/2
    local radius = math.Clamp(math.Distance(MouseX,MouseY,x,y), 0, landis.Radial.Radius)
    local closestPoint = -1
    local closestDist = 9999999
    for i=0,8 do
        local a1 = math.rad( (i/8) * -360 )
        local a2 = math.rad( ((i+1)/8) * -360 )
        local dist1 = math.Distance(MouseX, MouseY, x + math.sin( a1 ) * radius, y + math.cos( a1 ) * radius)
        local dist2 = math.Distance(MouseX, MouseY, x + math.sin( a2 ) * radius, y + math.cos( a2 ) * radius)
        if math.abs(dist1-dist2) < closestDist then
            closestDist = math.abs(dist1-dist2)
            closestPoint = i
        end
    end
    --print(closestPoint)
    closestPoint = closestPoint + 1
    return closestPoint >= 9 and (closestPoint) - 8 or closestPoint
end

local function HUD_Paint()

    local ft = FrameTime()

    -- Update Tween
    --surface.SetDrawColor(landis.Config.MainColor)
    --draw.Circle
    --draw.Circle(ScrW()/2, ScrH()/2, landis.Radial.Radius, 6)
    surface.SetDrawColor(40, 40, 40)
    draw.Circle(ScrW()/2, ScrH()/2, landis.Radial.Radius, 8)

    for i,k in ipairs(landis.Radial.Opts) do
        --DrawOption(i,k)
    end

    local HoveredIndex = HoveringOption()
    HoveredIndex = HoveredIndex + 4 > 8 and (HoveredIndex + 4) - 8 or HoveredIndex + 4
    DrawOption(HoveredIndex-1,"farted")
    if landis.Radial.Close == true then
        landis.Radial.RadiusTween:update(-ft)
        gui.EnableScreenClicker(false)
        if landis.Radial.Radius < 1 then
            hook.Remove("HUDPaint","landisRadialMenu")
        end
        --
    else
        landis.Radial.RadiusTween:update(ft)
    end

end

function landis.Radial.Open(opts)
    landis.Radial.Close = false
    landis.Radial.Opts = opts
    --landis.Radial.RadiusTween:set(0) -- reset tween
    landis.Radial.Time = CurTime() + 5
    gui.EnableScreenClicker(true)
    hook.Add("HUDPaint", "landisRadialMenu", HUD_Paint)
end

hook.Add("PlayerButtonDown", "landisRadialOpenTest", function(_,btn)
    if btn == KEY_B then
        landis.Radial.Open({"deez","nuts","lmfao"})
    end
    if btn == MOUSE_LEFT then
        if landis.Radial.Close == false then
            hook.Run("landisRadialSelect",HoveringOption())
        end
    end
end)

hook.Add("PlayerButtonUp", "landisRadialOpenTest", function(_,btn)
    if btn == KEY_B then
        landis.Radial.Close = true
    end
end)

hook.Add("landisRadialSelect", "test", function(option)
    landis.ConsoleMessage(tostring(option))
end)