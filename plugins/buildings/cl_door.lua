local textColor = Color(127, 89, 53, 255)
local doorCache
local ent = Entity
local isValid = IsValid
local cam = cam
local drawSimpleText = draw.SimpleTextOutlined

landis.DefineSetting("3d2dDrawDistance",{type="slider",name="3D2D Draw Distance",min=16,max=4096,dec=0,default=1024,category="Performance"})

debugDrawDoorCount = 0

-- Thank you Witness
hook.Add("PostDrawOpaqueRenderables", "landisDoorDraw", function()
    local drawDist = landis.GetSetting("3d2dDrawDistance")
    drawDist = drawDist * drawDist -- ^2
    debugDrawDoorCount = 0
    for v,k in pairs(landis.Doors) do
        local door = ent(v)
        if door:GetPos():DistToSqr(LocalPlayer():GetPos()) > drawDist then
            continue
        end 
        debugDrawDoorCount = debugDrawDoorCount + 1 
        local name = door.DoorLabel

        if !isValid(door) or door.GetNoDraw(door) then 
            continue 
        end

        local doorPos = door:GetPos()
        local doorAng = door:GetAngles()

        local pos = door:GetPos()
        local ang = door:GetAngles()

        pos = pos + ang:Forward() * 2
        pos = pos + ang:Right() * -23
        pos = pos + ang:Up() * 25

        ang.RotateAroundAxis(ang, doorAng:Up(), 90)
        ang.RotateAroundAxis(ang, doorAng:Right(), -90)

        cam.Start3D2D(pos, ang, 0.2)
            --surface.SetDrawColor(textColor)
            drawSimpleText(name, "landis-36-B", 0, 0, textColor, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,color_black)
        cam.End3D2D()

        ang.RotateAroundAxis(ang, doorAng:Right(), 180)
        ang.RotateAroundAxis(ang, doorAng:Forward(), 180)

        pos = pos + ang:Up() * 3.1

        cam.Start3D2D(pos, ang, 0.2)
            drawSimpleText(name, "landis-36-B", 0, 0, textColor, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,color_black)
        cam.End3D2D()
    end
end)

