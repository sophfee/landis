hook.Add("HUDPaint", "debug_inventory_hud", function()
	local text = ""
	for v,k in ipairs(LocalPlayer().Inventory) do
		text = tostring(v) .. "-" .. k .. "\n"
	end
	draw.SimpleText(text, "DermaDefault", 0, 100)
end)