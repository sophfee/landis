local PANEL = {}

function PANEL:Init()
	self:SetSize(100,50)
	self.Model = vgui.Create("DModelPanel", self)
	self.Model:SetSize(self:GetWide(),self:GetTall())
	self.Team = 0
end

function PANEL:SetTeam(index)
	self.Team = 0
end

function PANEL:Paint(w,h)
	draw.SimpleText(team.GetName(self.Team), "entname", 55, 5)
end

vgui.Register("landisTeam", PANEL, "DButton")