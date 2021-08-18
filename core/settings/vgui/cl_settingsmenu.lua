local PANEL = {}

function PANEL:Init()
	self:SetSize(800,600)
	self:SetTitle("Settings & Options")
	self.TabHolder = vgui.Create("DPropertySheet", self)
	self.TabHolder:DockMargin(10, 10, 10, 10)
	self.TabHolder:Dock(FILL)

	function self:OnClose()
		landys.lib.SaveSettings()
	end

	-- assemble the categories
	local cg = {}

	for name,metaData in pairs(landys.Settings) do
		if not cg[metaData.category] then
			cg[metaData.category] = {name}
			continue
		end
		table.ForceInsert(cg[metaData.category], name)
	end

	for name,classes in pairs(cg) do
		local c = vgui.Create("DPanel", self.TabHolder)
		self.TabHolder:AddSheet(name,c)
		c.Paint = function() end
		c:DockMargin(10, 10, 10, 10)
		c:Dock(FILL)
		for _,class in ipairs(classes) do
			landys.Settings[class].createPanel(c,landys.Settings[class])
		end
	end

	//PrintTable(cg)
	self:Center()
	self:MakePopup()

end

vgui.Register("landysBaseSettings", PANEL, "DFrame")