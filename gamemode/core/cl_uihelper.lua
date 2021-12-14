--- Draw Helpers to prevent very very very long draw.SimpleText funcs & various other things

local Gradient_Directions = {
  ["left"]=true,
  ["right"]=true,
  ["up"]=true,
  ["down"]=true
}
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

function landis.DrawText(text, x, y, fontData, alignment, color)
  fontData = table.Inherit(fontData, baseFontData)
  local font = "landis-"
  -- attributes
  font = font .. fontData.size
  if fontData.shadow then font = font .. "-S" end
  if fontData.bold then font = font .. "-B" end
  -- finish this
  draw.SimpleText(text, font, x, y, color or color_white, alignment.x, alignment.y)

end

-- Provide a 3D CONTEXT not A 2D CONTEXT!!!!
function landis.DrawText3D(text,pos,direction,fontData,alignment,color)
	cam.Start3D2D(pos,direction,0.1)
		landis.DrawText(text,0,0,fontData,alignment,color)
	cam.End3D2D()
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
