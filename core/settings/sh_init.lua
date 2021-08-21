--[[


HOW TO USE::






valueType    = "bool", -- internal
type         = "tickbox",
printName    = "Base Setting",
category     = "Other"










]]--


landis.Settings = {}

if CLIENT then

	landis.lib.SettingsPanels = {}

	landis.lib.SettingsPanels["tickbox"] = function( parent,data )
		local PANEL = vgui.Create("DCheckBoxLabel", parent)
		PANEL:DockMargin(5, 5, 5, 5)
		PANEL:Dock(TOP)
		PANEL:SetText(data:GetPrintName())
		PANEL:SetValue(data:GetValue())
		function PANEL:OnChange(bVal)
			data:SetValue(bVal)
			//PrintTable(data)
		end
	end

	landis.lib.SettingsPanels["dropdown"] = function( parent,data )
		local DropDown = vgui.Create("DComboBox", parent)
		DropDown:DockMargin(5, 5, 5, 5)
		DropDown:Dock(TOP)

		DropDown:SetText(data:GetPrintName())
		--PANEL:SetValue(data:GetValue())
		for v,k in ipairs(data.options) do
			DropDown:AddChoice(k)
		end

		DropDown.OnSelect = function( self, _, val)
			data:SetValue(val)
		end
		DropDown:SetSize(DropDown:GetWide()/3,DropDown:GetTall())
	end

	landis.lib.SettingsPanels["slider"] = function( parent,data )
		local PANEL = vgui.Create("DNumSlider", parent)
		PANEL:DockMargin(5, 5, 5, 5)
		PANEL:Dock(TOP)
		PANEL:SetText(data:GetPrintName())
		
		PANEL:SetDecimals( data.options.dec )
		PANEL:SetMax(data.options.max)
		PANEL:SetMin(data.options.min)
		PANEL:SetValue(data:GetValue())

		function PANEL:OnValueChanged(bVal)
			data:SetValue(math.Round(bVal,0))
		end
	end

	landis.lib.SettingsInit = {}

	landis.lib.SettingsInit["tickbox"] = function( data )
		data:SetValueType("bool")
		data.defaultValue = false
	end

	landis.lib.SettingsInit["dropdown"] = function( data )
		data:SetValueType("string")
		data.defaultValue = ""
	end

	landis.lib.SettingsInit["slider"] = function( data )
		local t = data["options"]
		

		if not t then Error("Invalid Arguments for Setting!") end
		if not t["max"] then Error("Invalid Arguments for Setting!") end -- arg check
		if not t["min"] then Error("Invalid Arguments for Setting!") end -- arg check
		if not t["dec"] then Error("Invalid Arguments for Setting!") end -- arg check
		data:SetValueType("int")
		data.defaultValue = t.max
		--ata.activeValue = data.activeValue > data.options.min and data.options.min or data.activeValue 
	end

end

local baseStruct = {
	type         = "tickbox",
	-- In new versions this is INTERNAl, shouldn't be changed unless custom.
	createPanel  = function(parent,data)
		if SERVER then return end -- ensure that this never runs on the server.
		local func = landis.lib.SettingsPanels[data.type]
		if func then
			func(parent,data)
		end
	end,
	init         = function(data)
		if SERVER then return end -- ensure that this never runs on the server.
		func = landis.lib.SettingsInit[data.type]
		if func then
			func(data)
		end
	end,
	printName    = "Unset Option",
	category     = "UNSET",
	defaultValue = false, -- fallback
	activeValue  = false
}

DefaultSettings = {
	["useThirdperson"] = {
		type         = "tickbox",
		printName    = "Enable Thirdperson",
		category     = "Camera",
		activeValue  = false
	},
	["crosshairGap"] = {
		type         = "slider",
		options      = {max=16,min=1,dec=0},
		printName    = "Crosshair Gap",
		category     = "Crosshair",
		defaultValue = 4, -- fallback
		activeValue  = 4
	},
	["dropDownTest"] = {
		type         = "dropdown",
		options      = {"amogus","test 2","opt 3"},
		printName    = "Test",
		category     = "Testing",
		defaultValue = "", -- fallback
		activeValue  = ""
	},
	["crosshairLength"] = {
		type         = "slider",
		options      = {max=16,min=1,dec=0},
		printName    = "Crosshair Length",
		category     = "Crosshair",
		defaultValue = 4, -- fallback
		activeValue  = 4
	},
	["buttonClicks"] = {
		type         = "tickbox",
		printName    = "Enable Button Hover/Press Noise",
		category     = "Misc.",
		activeValue  = false
	},
	["ThirdpersonFOV"] = {
		type         = "slider",
		options      = {max=90,min=80,dec=0},
		printName    = "Thirdperson FOV",
		category     = "Camera",
		defaultValue = 4, -- fallback
		activeValue  = 4
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
			local mainColor = landis.Config.MainColor
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
function landis.lib.DefineSetting(className,struct)

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

	landis.Settings[className] = CSetting
	CSetting.init(CSetting)
	return landis.Settings[className] -- return reference to effect the global table

end

for name,data in pairs(DefaultSettings) do
	landis.lib.DefineSetting(name,data) -- setup for cl & sv so they are sync'd, this sync check will be performed upon firing any functions, if something out of place, it'll perform auto-moderation dependant on how big the inconsistency is. (i.e. function change = insta ban)
end

if SERVER then return end

local saveDataName = "settings.json"

function landis.lib.GetSetting(className)
	local data = landis.Settings[className]
	if data then
		return data:GetValue()
	end
	return false
end

local dir = "landis"

file.CreateDir("landis")

-- INTERNAL
function landis.lib.LoadSettings()
	if file.Exists(dir,"DATA") then
		if file.Exists( dir .. "/" .. saveDataName, "DATA") then
			local data = file.Open( dir .. "/" .. saveDataName, "r", "DATA")
			if data then
				local tableData = util.JSONToTable(data:ReadLine())
				for name,value in pairs(tableData) do
					if not landis.Settings[name] then continue end
					landis.Settings[name]:SetValue(value)
				end
			end
		end
	end
end

-- INTERNAL
function landis.lib.SaveSettings()
	local d = {}
	for n,v in pairs(landis.Settings) do
		d[n] = v:GetValue()
	end
	file.Write( dir .. "/" .. saveDataName, util.TableToJSON(d,false).."\n// Do not edit this file! You risk an automatic-ban if file has any inconsistencies!")
end

landis.lib.LoadSettings()

-- rename to draw gBaseSettings



--[[
local data = landis.Settings["test"]

local parent = vgui.Create("DFrame")
parent:SetSize(400,400)
parent:Center()
parent:MakePopup()

data.createPanel(parent,data)
]]