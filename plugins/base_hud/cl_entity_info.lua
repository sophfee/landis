local drawEnts = {}
local drawAlpha = {}
surface.CreateFont("entdata", {
	font = "Segoe UI Light",
	size = 24,
	weight = 3500,
	antialias = true,
	extended = true,
	shadow = true
})

surface.CreateFont("entname", {
	font = "Segoe UI Light",
	size = 24,
	weight = 3500,
	antialias = true,
	extended = true,
	shadow = true
})

local function getName(k)
	local name
	local p = k:IsPlayer()
	if p then
		name = k:GetInNoclip() and "" or k:GetRPName()
		return name
	end

	if k.name then
		name = k.name
		return name
	end

	if k.GetDisplayName then
		name = k:GetDisplayName()
		return name
	end

	return k:GetNWString("DisplayName","")
end

local function getDesc(k)
	local name
	local p = k:IsPlayer()
	if p then
		name = k:IsTyping() and "Typing..." or ""
		return name
	end

	if k.desc then
		name = k.desc
		return name
	end

	if k.GetDescription then
		name = k:GetDescription()
		return name
	end

	return k:GetNWString("Description","")
end


hook.Add( "HUDPaint", "landisDrawEntInfo", function()

	local ply = LocalPlayer()
	if not ply then return end
	

	local traceData = util.QuickTrace( ply:EyePos(), ply:GetAimVector() * 128, ply)
	local hitEnt

	if traceData.Hit then
		local e = traceData.Entity
		if ((e.name and e.desc) or (not(e:GetNWString("DisplayName","NULL") == "NULL"))) or e:IsPlayer() then 
			if not table.HasValue( drawEnts, traceData.Entity) then
				table.ForceInsert( drawEnts, traceData.Entity)
				table.ForceInsert( drawAlpha, 0)
			end
			hitEnt = e
		end
	end

	

	local ft = FrameTime()

	for v,k in ipairs( drawEnts ) do
		local alpha = drawAlpha[v]

		if IsValid( k ) then
			local p = k:IsPlayer()
			local name = getName(k)
			

			--if not name then table.remove(drawEnts, v) continue end

			local desc = getDesc(k)
			--if not desc then table.remove(drawEnts, v) continue end

			local heightOffset = k.HeightOffset or 0

			local pos = k:IsPlayer() and (k:GetPos() + Vector(0,0,k:OBBCenter().z*2)):ToScreen() or k:LocalToWorld( k:OBBCenter() + Vector(0,0,-heightOffset) ):ToScreen()

			local col = p and team.GetColor( k:Team() ) or Color( 255,214,10,alpha )

			

			draw.DrawText( name, "landis-24-S", pos.x, pos.y-24-heightOffset, Color(col.r,col.g,col.b,alpha),TEXT_ALIGN_CENTER)
			draw.DrawText( desc, "landis-18-S", pos.x, pos.y-heightOffset, Color( 255, 255, 255, alpha ),TEXT_ALIGN_CENTER)

			if hitEnt == k then
				drawAlpha[v] = math.Clamp( drawAlpha[v] + ft * 512, 0, 255 ) 
			else
				drawAlpha[v] = math.Clamp( drawAlpha[v] - ft * 512, 0, 255 ) 
				if drawAlpha[v] <= 0 then

					table.remove(drawEnts, v)
					table.remove(drawAlpha,v)

				end
			end

		else

			table.remove(drawEnts, v)
			table.remove(drawAlpha,v)

		end
	end

	
end)