local PANEL = {}

QuickNotifications = {}

function PANEL:Init()
	table.ForceInsert(QuickNotifications, self)
	--self.CachedNotifications = QuickNotifications
	
	self.Text = "Unset Text!"
	self.Width = 0
	self:SetPos(ScrW()/2+24,ScrH()/2+(table.KeyFromValue(QuickNotifications, self))*24)
	timer.Simple(3, function()
		
		table.RemoveByValue(QuickNotifications, self)
		self:Remove()
	end)
end

function PANEL:Paint()
	local dist = self:GetY() - ( ScrH()/2 + (table.KeyFromValue(QuickNotifications, self))*24 )
	self:SetPos(self:GetX(),self:GetY()-(dist/24))
	self.Width = self.Width + 1
	draw.SimpleText(self.Text, "notifyText")
	self:SetWide(self.Width)
end

vgui.Register("landisQuickNotification", PANEL, "Panel")

local PANEL = {}

Voices = {}

function PANEL:Init()
	table.ForceInsert(Voices, self)
	--self.CachedNotifications = QuickNotifications
	
	self.Text = "Unset Text!"
	self.Width = 0
	self:SetPos(ScrW()-24,(ScrH()-24)-(table.KeyFromValue(Voices, self))*24)
	--self.Player = nil
	timer.Simple(3, function()
		
		table.RemoveByValue(Voices, self)
		self:Remove()
	end)
end

function PANEL:Paint(w,h)
	local dist = self:GetY() - ( ScrH()/2 + (table.KeyFromValue(Voices, self))*24 )
	self:SetPos(ScrW()-24-w,Lerp(FrameTime(),self:GetY(),( ScrH() - 24 - (table.KeyFromValue(Voices, self))*24 )))
	self.Width = self.Player:IsVoiceAudible() and self.Width + 4 or self.Width + 4
	if self.Width < 0 then
		table.RemoveByValue(Voices, self)
		self:Remove()
	end 
	local teamColor = team.GetColor()
	draw.SimpleText(self.Text, "notifyText",w,h,color_white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
	self:SetWide(self.Width)
end

vgui.Register("landisVoice", PANEL, "Panel")