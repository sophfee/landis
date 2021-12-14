local PANEL = {}

function PANEL:Init()
	self:SetSize(800,600)
	self:SetTitle("Settings & Options")
	self.TabHolder = vgui.Create("DPropertySheet", self)
	self.TabHolder:DockMargin(10, 10, 10, 10)
	self.TabHolder:Dock(FILL)

	-- assemble the categories
	local cg = {}

	for name,metaData in pairs(landis.Settings) do
		if not cg[metaData.category] then
			cg[metaData.category] = {name}
			continue
		end
		table.ForceInsert(cg[metaData.category], name)
	end

	for name,classes in pairs(cg) do
		--[[if landis.AdminCategories[name] then
			if not (LocalPlayer():IsAdmin()) then
				continue
			end
		end]]
		local c = vgui.Create("DPanel", self.TabHolder)
		self.TabHolder:AddSheet(name,c)
		c.Paint = function() end
		c:DockMargin(10, 10, 10, 10)
		c:Dock(FILL)
		for _,classname in ipairs(classes) do
			class = landis.Settings[classname]
			--if not (class.category == name) then continue end
			if class.type == "tickbox" then
				local panel = vgui.Create("DCheckBoxLabel", c, class.classname)
				panel:SetText(class.name)
				panel:SetChecked(landis.GetSetting(classname))
				panel:DockMargin(5, 5, 5, 5)
				panel.ClassName = classname
				panel:Dock(TOP)
				function panel:OnChange(bVal)
					landis.SetSetting(self.ClassName,bVal)
				end
			end
			if class.type == "slider" then
				local PANEL = vgui.Create("DNumSlider", c, classname)
				PANEL:DockMargin(5, 5, 5, 5)
				PANEL:Dock(TOP)
				PANEL:SetText(class.name)
				PANEL.ClassName = classname
				PANEL:SetDecimals( class.dec )
				PANEL:SetMax(class.max)
				PANEL:SetMin(class.min)
				PANEL:SetValue(landis.GetSetting(classname))

				function PANEL:OnValueChanged(bVal)
					landis.SetSetting(self.ClassName,bVal)
				end
			end
		end
	end

	self:Center()
	self:MakePopup()

end

vgui.Register("landisBaseSettings", PANEL, "DFrame")
