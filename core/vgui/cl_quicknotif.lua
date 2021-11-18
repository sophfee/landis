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