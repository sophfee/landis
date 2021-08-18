landys.Settings = {}

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

DefaultSettings = {
	["useThirdperson"] = {
		valueType    = "bool",
		createPanel  = function(parent,data)
			if SERVER then return end -- ensure that this never runs on the server.
			local PANEL = vgui.Create("DCheckBoxLabel", parent)
			PANEL:DockMargin(5, 5, 5, 5)
			PANEL:Dock(TOP)
			PANEL:SetText(data:GetPrintName())
			PANEL:SetValue(data:GetValue())
			function PANEL:OnChange(bVal)
				data:SetValue(bVal)
				//PrintTable(data)
			end
		end,
		printName    = "Enable Thirdperson",
		category     = "Camera",
		defaultValue = false, -- fallback
		activeValue  = false
	},
	["crosshairGap"] = {
		valueType    = "int",
		createPanel  = function(parent,data)
			if SERVER then return end -- ensure that this never runs on the server.
			local PANEL = vgui.Create("DNumSlider", parent)
			//PANEL:DockMargin(number marginLeft, number marginTop, number marginRight, number marginBottom)
			PANEL:DockMargin(5, 0, 5, 0)
			PANEL:Dock(TOP)
			PANEL:SetText(data:GetPrintName())
			PANEL:SetMax(15)
			PANEL:SetMin(0)
			PANEL:SetDecimals(0)
			PANEL:SetValue(data:GetValue())
			function PANEL:OnValueChanged(bVal)
				data:SetValue(math.Round(bVal,0))
				//PrintTable(data)
			end
		end,
		printName    = "Crosshair Gap",
		category     = "Crosshair",
		defaultValue = 4, -- fallback
		activeValue  = 4
	},
	["crosshairLength"] = {
		valueType    = "int",
		createPanel  = function(parent,data)
			if SERVER then return end -- ensure that this never runs on the server.
			local PANEL = vgui.Create("DNumSlider", parent)
			//PANEL:DockMargin(number marginLeft, number marginTop, number marginRight, number marginBottom)
			PANEL:DockMargin(5, 0, 5, 0)
			PANEL:Dock(TOP)
			PANEL:SetText(data:GetPrintName())
			PANEL:SetMax(15)
			PANEL:SetMin(0)
			PANEL:SetDecimals(0)
			PANEL:SetValue(data:GetValue())
			function PANEL:OnValueChanged(bVal)
				data:SetValue(math.Round(bVal,0))
				//PrintTable(data)
			end
		end,
		printName    = "Crosshair Length",
		category     = "Crosshair",
		defaultValue = 4, -- fallback
		activeValue  = 4
	},
	["buttonClicks"] = {
		valueType    = "bool",
		createPanel  = function(parent,data)
			if SERVER then return end -- ensure that this never runs on the server.
			local PANEL = vgui.Create("DCheckBoxLabel", parent)
			PANEL:DockMargin(5, 5, 5, 5)
			PANEL:Dock(TOP)

			PANEL:SetText(data:GetPrintName())
			PANEL:SetValue(data:GetValue())
			function PANEL:OnChange(bVal)
				data:SetValue(bVal)
				//PrintTable(data)
			end
		end,
		printName    = "Enable Button Hover/Press Noise",
		category     = "Misc.",
		defaultValue = true, -- fallback
		activeValue  = false
	},
	["ThirdpersonFOV"] = {
		valueType    = "int",
		createPanel  = function(parent,data)
			if SERVER then return end -- ensure that this never runs on the server.
			local PANEL = vgui.Create("DNumSlider", parent)
			//PANEL:DockMargin(number marginLeft, number marginTop, number marginRight, number marginBottom)
			PANEL:DockMargin(5, 0, 5, 0)
			PANEL:Dock(TOP)
			PANEL:SetText(data:GetPrintName())
			PANEL:SetMax(100)
			PANEL:SetMin(65)
			PANEL:SetDecimals(0)
			PANEL:SetValue(data:GetValue())
			function PANEL:OnValueChanged(bVal)
				data:SetValue(math.Round(bVal,0))
				//PrintTable(data)
			end
		end,
		printName    = "Thirdperson Field of View",
		category     = "Camera",
		defaultValue = 90, -- fallback
		activeValue  = 90
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
			local mainColor = landys.Config.MainColor
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
function landys.lib.DefineSetting(className,struct)

	local CSetting = table.Inherit(struct, baseStruct)
	//PrintTable(CSetting)

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

	landys.Settings[className] = CSetting
	return landys.Settings[className] -- return reference to effect the global table

end

for name,data in pairs(DefaultSettings) do
	landys.lib.DefineSetting(name,data) -- setup for cl & sv so they are sync'd, this sync check will be performed upon firing any functions, if something out of place, it'll perform auto-moderation dependant on how big the inconsistency is. (i.e. function change = insta ban)
end

if SERVER then return end

local saveDataName = "settings.json"

function landys.lib.GetSetting(className)
	local data = landys.Settings[className]
	if data then
		return data:GetValue()
	end
	return false
end

local dir = "landys"

file.CreateDir("landys")

-- INTERNAL
function landys.lib.LoadSettings()
	if file.Exists(dir,"DATA") then
		if file.Exists( dir .. "/" .. saveDataName, "DATA") then
			local data = file.Open( dir .. "/" .. saveDataName, "r", "DATA")
			if data then
				local tableData = util.JSONToTable(data:ReadLine())
				for name,value in pairs(tableData) do
					if not landys.Settings[name] then continue end
					landys.Settings[name]:SetValue(value)
				end
			end
		end
	end
end

-- INTERNAL
function landys.lib.SaveSettings()
	local d = {}
	for n,v in pairs(landys.Settings) do
		d[n] = v:GetValue()
	end
	file.Write( dir .. "/" .. saveDataName, util.TableToJSON(d,false).."\n// Do not edit this file! You risk an automatic-ban if file has any inconsistencies!")
end

landys.lib.LoadSettings()

-- rename to draw gBaseSettings



--[[
local data = landys.Settings["test"]

local parent = vgui.Create("DFrame")
parent:SetSize(400,400)
parent:Center()
parent:MakePopup()

data.createPanel(parent,data)
]]