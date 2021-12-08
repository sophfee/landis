hook.Add("HUDPaint", "debug_inventory_hud", function()
	local text = ""
	for v,k in pairs(LocalPlayer().Inventory) do
		text = text .. tostring(v) .. "-" .. k.UniqueID .. "\n"
	end
	draw.DrawText(text, "BudgetLabel", 100, 100)
end)

concommand.Add("landis_inventory_dump",function()
	PrintTable(LocalPlayer().Inventory)
end)