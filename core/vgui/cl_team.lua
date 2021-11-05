local PANEL = {}

function PANEL:Init()
	self:SetText("")
	self:SetSize(100,50)
	self.Model = vgui.Create("DModelPanel", self)
	self.Model:SetSize(self:GetTall(),self:GetTall())
	self.Team = 0
end

function PANEL:SetTeam(index)
	self.Team = index
end

function PANEL:Paint(w,h)
	draw.SimpleText(team.GetName(self.Team), "entname", 55, 5, team.GetColor(self.Team))
end

function PANEL:DoClick()
	net.Start("landis_RequestTeamJoin")
		net.WriteInt(self.Team, 32)
	net.SendToServer()
	PLAYER_MENU:Remove()
	PLAYER_MENU = nil
end

vgui.Register("landisTeam", PANEL, "DButton")