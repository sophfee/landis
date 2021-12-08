hook.Add("HUDPaint", "debug_inventory_hud", function()
	local text = ""
	for v,k in ipairs(LocalPlayer().Inventory) do
		text = tostring(v) .. "-" .. k.UniqueID .. "\n"
	end
	draw.SimpleText(text, "BudgetLabel", 0, 100)
end)