--- Draw Helpers to prevent very very very long draw.SimpleText funcs & various other things

local Gradient_Directions = {"left","right","up","down"}
local Gradient_Textures   = {
  ["left"] = "vgui/gradient-l",
  ["right"] = "vgui/gradient-r",
  ["up"] = "vgui/gradient-u",
  ["down"] = "vgui/gradient-d"
}

function landis.DrawGradient(direction, x, y, w, h, color)
  
  direction = string.lower(direction) -- not case sensitive :)
  if not Gradient_Directions[direction] then
    landis.Error("Invalid Gradient Direction Specified!")
    return
  end
  
  color = color or color_white -- fallback
  
  local tex = Gradient_Textures[direction]
  local mat = Material(tex)
  
  draw.NoTexture()
  
  surface.SetMaterial(mat)
  surface.SetDrawColor(color)
  
  surface.DrawTexturedRect(x,y,w,h)
  
end

local baseFontData = {
  size = 24,
  bold = false,
  shadow = false
}

function landis.DrawText(text, fontData, alignment, color)
  fontData = table.inherit(fontData, baseFontData)
  local font = "landis-"
  -- attributes
  font = font .. fontData.size
  if fontData.shadow then font = font .. "-S" end
  if fontData.bold then font = font .. "-B" end
  -- finish this
end


concommand.Add("landis_outline_test", function()
	local aiment = LocalPlayer():GetEyeTrace()
	if aiment.Entity then
		local deez = aiment.Entity
		hook.Add("PreDrawHalos", deez, function()
			outline.Add(deez,HSVToColor( (CurTime()*24) % 360, 1, 1 ),OUTLINE_MODE_NOTVISIBLE)
		end)
	end
end)