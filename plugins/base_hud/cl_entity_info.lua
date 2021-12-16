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

hook.Add( "HUDPaint", "landisDrawEntInfo", function()

	local ply = LocalPlayer()
	if not ply then return end
	

	local traceData = util.QuickTrace( ply:EyePos(), ply:GetAimVector() * 128, ply)
	local hitEnt

	if traceData.Hit then
		local e = traceData.Entity
		if ((e.DisplayName and e.Description) or (not(e:GetNWString("DisplayName","NULL") == "NULL"))) or e:IsPlayer() then 
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

			local name = p and (not p:InNoclip() and k:GetRPName() or "") or (k:GetNWString("DisplayName", "nil") == "nil" and k.DisplayName or k:GetNWString("DisplayName", "nil") )
			--if not name then table.remove(drawEnts, v) continue end

			local desc = p and (not p:InNoclip() and ( k:IsTyping() and "Typing..." or "" ) or "") or (k:GetNWString("Description", "nil") == "nil" and k.Description or k:GetNWString("Description", "nil") )
			--if not desc then table.remove(drawEnts, v) continue end

			local heightOffset = k.HeightOffset or 0

			local pos = k:IsPlayer() and (k:GetPos() + Vector(0,0,k:OBBCenter().z*2)):ToScreen() or k:LocalToWorld( k:OBBCenter() + Vector(0,0,-heightOffset) ):ToScreen()

			local col = p and team.GetColor( k:Team() ) or Color( 255,214,10,alpha )

			

			draw.DrawText( name, "landis-24-S-B", pos.x, pos.y-24-heightOffset, Color(col.r,col.g,col.b,alpha),TEXT_ALIGN_CENTER)
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