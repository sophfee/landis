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

concommand.Add("landis_debug_entpos", function()
    local lp = LocalPlayer()
    local tr = util.QuickTrace(lp:EyePos(),lp:GetAimVector()*1024,lp)
    if tr.Hit and tr.Entity then
        local eyePos = tr.Entity:GetPos()
        local format = "Vector(" .. eyePos.x .. "," .. eyePos.y .. "," .. eyePos.z .. ")"
        chat.AddText("Entity: ",tostring(tr.Entity)," pos copied to clipboard.")
        SetClipboardText(format)
        return
    end
    lp:Notify("No entity found!")
end)
