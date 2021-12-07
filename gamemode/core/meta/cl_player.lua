local PLAYER = FindMetaTable("Player")
function PLAYER:Notify(message,duration)
	local panel = vgui.Create("landisNotify")
	panel:SetDuration(duration or 5)
	panel:SetMessage(message)
end
