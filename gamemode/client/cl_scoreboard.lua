AddCSLuaFile()

surface.CreateFont("roboto_sb", {
	font = "Roboto",
	size = 24,
	weight = 500,
})


local function ToggleScoreboard(toggle)
	if toggle then
		local scrw,scrh = ScrW(), ScrH()
		ScoreboardFrame = vgui.Create("DFrame")
		ScoreboardFrame:SetTitle("")
		ScoreboardFrame:SetSize(scrw * .3, scrh * .6)
		ScoreboardFrame:Center()
		ScoreboardFrame:MakePopup()
		ScoreboardFrame:ShowCloseButton(false)
		ScoreboardFrame:SetDraggable(false)
		ScoreboardFrame.Paint = function(self,w,h)
			surface.SetDrawColor(240, 240, 240, 200)
			surface.DrawRect(0, 0, w, h)
			draw.SimpleText("SBase Scoreboard", "roboto_sb", w / 2, h * .025, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local scroll = vgui.Create("DScrollPanel", ScoreboardFrame)
		scroll:SetPos(0, ScoreboardFrame:GetTall() * .05)
		scroll:SetSize(ScoreboardFrame:GetWide(), ScoreboardFrame:GetTall() * .95)
		local ypos = 0
		for k, v in pairs(player.GetAll()) do
			local playerPanel = vgui.Create("DPanel", scroll)
			playerPanel:SetPos(0,ypos)
			playerPanel:SetSize(ScoreboardFrame:GetWide(), ScoreboardFrame:GetTall() * .1)
			local name = v:Name()
			local ping = v:Ping()
			local deaths = v:Deaths()
			playerPanel.Paint = function(self, w, h)
				if IsValid(v) then
				surface.SetDrawColor(200, 200, 200, 200)
				surface.DrawRect(0, 0, w, h)
				draw.SimpleText(name, "roboto_sb", w / 8, h / 2, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("Ping: " .. ping, "roboto_sb", w / 1.25, h / 2, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				local Avatar = vgui.Create( "AvatarImage", playerPanel )
				Avatar:SetSize( 48, 48 )
				Avatar:SetPos( w / 32, h / 7)
				Avatar:SetPlayer( v, 64 )
				end
			end
			ypos = ypos + playerPanel:GetTall() * 1.1
		end
	else
		if IsValid(ScoreboardFrame) then
			ScoreboardFrame:Remove()
		end
	end
end

hook.Add("ScoreboardShow","SBaseShowScoreboard",function()
	ToggleScoreboard(true)
	return false
end)

hook.Add("ScoreboardHide","SBaseHideScoreboard",function()
	ToggleScoreboard(false)
end)
