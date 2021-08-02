g_base.Settings = {}
print("loaded file")
local baseStruct = {
	valueType    = "bool",
	createPanel  = function()
		if SERVER then return end -- ensure that this never runs on the server.
	end,
	printName    = "Base Setting",
	category     = "Other",
	defaultValue = false, -- fallback
	activeValue  = false
}

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

local testStruct = {
	valueType    = "bool",
	createPanel  = function(parent,data)
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
	printName    = "Test Setting",
	category     = "Other",
	defaultValue = false, -- fallback
	activeValue  = false
}

local validType = {
	"bool",
	"string",
	"int",
	"float"
}

-- Function: Create Setting Class
-- Info: This should be created on both client and server so server can verify settings and check for irregularities.
function Setting(className,struct)

	local CSetting = table.Inherit(struct, baseStruct)
	PrintTable(CSetting)

	function CSetting:SetValueType(newType)
		if not table.HasValue(validType, newType) then
			error("Tried to set setting to an invalid type")
			return
		end
		self.valueType = newType
	end

	function CSetting:GetValueType()
		return self.valueType
	end

	function CSetting:SetValue(val)
		-- ensure that the types are strictly the same
		if type(val) == type(self.defaultValue) then
			self.activeValue = val
			return
		end
		error("Value to set didn't match the type of the default value!")
	end

	function CSetting:GetValue()
		return self.activeValue or nil
	end

	function CSetting:SetPrintName(name)
		if type(name) == "string" then
			self.printName = name
			return
		end
		self.printName = tostring(name)
	end

	function CSetting:GetPrintName()
		return self.printName
	end

	function CSetting:SetCategory(newCategory)
		if type(newCategory) == "string" then
			self.category = newCategory
			return
		end
		self.category = tostring(newCategory)
	end

	g_base.Settings[className] = CSetting
	return g_base.Settings[className] -- return reference to effect the global table

end

for name,data in pairs(settings) do
	Setting(name,data) -- setup for cl & sv so they are sync'd, this sync check will be performed upon firing any functions, if something out of place, it'll perform auto-moderation dependant on how big the inconsistency is. (i.e. function change = insta ban)
end
--[[
local data = g_base.Settings["test"]

local parent = vgui.Create("DFrame")
parent:SetSize(400,400)
parent:Center()
parent:MakePopup()

data.createPanel(parent,data)
]]