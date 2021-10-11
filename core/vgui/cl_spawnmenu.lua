hook.Add( "SpawnMenuOpen", "SpawnMenuWhitelist", function()
	return LocalPlayer():IsAdmin()
end )

surface.CreateFont("entdesc",{
	font = "arial",
	size = 12,
	weight = 1000,
	antialias = true,
	extended = true
})

spawnmenu.AddCreationTab( "Vendors",function()
	PANEL = vgui.Create("DIconLayout")
	PANEL:SetSpaceX(5)
	PANEL:SetSpaceY(5)

	for v,k in pairs(landis.Vendor.Data) do
		local btn = vgui.Create("DModelPanel", PANEL)
		btn:SetModel(k.Model.Path)
		btn.oldPaint = btn.Paint
		btn.Paint =function(panel,w,h)
			draw.SimpleText(k.DisplayName,"entname",0,0,Color(10,132,255))
			draw.DrawText(k.Description,"entdesc",0,16)
			panel:oldPaint(w,h)
		end
		btn.Entity:SetSkin(k.Model.Skin)
		for i,e in pairs(k.Model.Bodygroup) do
			btn.Entity:SetBodygroup(i,e)
		end

		--btn:SetText(k.DisplayName .. " (" .. k.UniqueID .. ")" )
		btn.DoClick = function()
			surface.PlaySound(Sound("ui/buttonclickrelease.wav"))
			net.Start("landis_spawn_vendor")
				net.WriteString(k.UniqueID)
			net.SendToServer()
		end
		btn:SetSize(250,250)
		PANEL:Add(btn)
	end

	return PANEL
end, "icon16/wrench.png" )