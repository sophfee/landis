local PANEL = {}

function PANEL:Init()
	self:SetText("")
	self:SetSize(100,50)
	self.Model = vgui.Create("DModelPanel", self)
	self.Model.LayoutEntity = function() end
	self.Model:SetFOV(4.4)
	self.Model:SetLookAt(Vector(0, -0, 66.1))
	self.Model:SetCamPos(Vector(190,-50,71))
	self.Model:SetAnimSpeed( 4 )
	self.Model:SetDisabled( true )
	self.Model:SetSize(self:GetTall(),self:GetTall())
	self.Team = 0
end

function PANEL:SetTeam(index)
	self.Team = index
	self.Model:SetModel(landis.Teams.Data[index].Model)
	--self.Model:SetTooltip(index)
end

function PANEL:Paint(w,h)
	draw.SimpleText(team.GetName(self.Team), "entname", 55, 5, team.GetColor(self.Team))
	draw.SimpleText(landis.Teams.Data[self.Team].Description, "entdata", 55, 25)
	local limit = landis.Teams.Data[self.Team].Limit
	if limit then
		draw.SimpleText(#team.GetPlayers(self.Team) .. "/" .. limit, "entname", self:GetWide()-5, 5, color_white, TEXT_ALIGN_RIGHT)
	end
end

function PANEL:DoClick()
	net.Start("landis_RequestTeamJoin")
		net.WriteInt(self.Team, 32)
	net.SendToServer()
	PLAYER_MENU:Remove()
	PLAYER_MENU = nil
end

vgui.Register("landisTeam", PANEL, "DButton")