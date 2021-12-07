-- commands to help view various things
concommand.Add("landis_debug_eyepos", function()
    local eyePos = LocalPlayer():EyePos()
    local format = "Vector(" .. eyePos.x .. "," .. eyePos.y .. "," .. eyePos.z .. ")"
    SetClipboardText(format)
end)

concommand.Add("landis_debug_eyeang", function()
    local eyeAng = LocalPlayer():EyeAngles()
    local format = "Angle(" .. eyeAng.p .. "," .. eyeAng.y .. "," .. eyeAng.r .. ")"
    SetClipboardText(format)
end)
