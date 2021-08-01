net.Receive("settings-send-to-client", function()
	local t = net.ReadTable()
	PrintTable(t)
	g_base.Settings = t
end)