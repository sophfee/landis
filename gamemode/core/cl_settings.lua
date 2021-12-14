-- [[Settings.v2]] --
-- HEAVILY BASED ON IMPULSE'S SETTING SYSTEM
-- LARGE MAJORITY OF CREDIT GOES TO VIN BECAUSE FUCK I COULD NOT FIGURE THIS OUT
landis.Settings = landis.Settings or {}

function landis.LoadSettings()
    for v,k in pairs(landis.Settings) do
        -- check types
        if k.type == "tickbox" or k.type == "slider" or k.type == "int" then
            -- number values
            local default = k.default
            if k.type == "tickbox" then
                default = tonumber(k.default)
            end

            k.value = cookie.GetNumber("landis_setting-"..v, default)
        elseif k.type == "dropdown" or k.type == "textbox" then
            -- string values
            k.value = cookie.GetString("landis_setting-"..v, k.default)
        end
    end
end

function landis.SetSetting(name,val)
    local data = landis.Settings[name]
    if data then
        if type(val) == "boolean" then
            val = val and 1 or 0
        end
        cookie.Set("landis_setting-"..name, val)
        data.value = val
        return
    end
    landis.Error("Could not SetSetting! Improper name!")
end

function landis.GetSetting(name)
	local data = landis.Settings[name]

	if data.type == "tickbox" then
		if data.value == nil then
			return data.default
		end

		return tobool(data.value)
	end

	return data.value or data.default
end


function landis.DefineSetting(name,data)
    landis.Settings[name] = data
    landis.LoadSettings()
end

