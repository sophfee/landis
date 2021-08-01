
util.AddNetworkString("settings-send-to-client")

local settings = {
	["useThirdperson"] = {
		valueType    = "bool",
		createPanel  = function()
			if SERVER then return end -- ensure that this never runs on the server.
			local PANEL = vgui.Create("DCheckBoxLabel", parent)
			PANEL:Dock(TOP)
			PANEL:SetText(data:GetPrintName())
			PANEL:SetValue(data:GetValue())
			PANEL.Paint = function(self,w,h)
				local mainColor = g_base.Config.MainColor
				surface.SetDrawColor(mainColor.r,mainColor.g,mainColor.b,200)
				surface.DrawRect(0, 0, w, h)
			end
			function PANEL:OnChange(bVal)
				data:SetValue(bVal)
				PrintTable(data)
			end
		end,
		printName    = "Enable Thirdperson",
		category     = "Camera",
		defaultValue = false, -- fallback
		activeValue  = false
	}
}

for class,data in pairs(settings) do
	Setting(class,data)
end

net.Start("settings-send-to-client")
	net.WriteTable(settings)
net.Broadcast()
