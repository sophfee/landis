local PANEL = {}

landis.Notifications = {}

surface.CreateFont("notifyText", {
	font = "Arial",
	weight = 3500,
	shadow = true,
	antialias = true,
	size = 18,
	extended = true
})

/*

Call order:

create vgui
set duration,
set message

*/

function PANEL:SetMessage(text)

	local font = "<font=notifyText>"

	local r = markup.Parse(font..text, self:GetWide()-20)
	local w,h = r:Size()
	self:SetSize(w+20,h+20)
	
	
	self.Paint = function ( self, w, h )
		blurDerma( self, 200, 10, 20 )
		surface.SetDrawColor(30, 30, 30,180)
		surface.DrawRect(0, 0, w, h)
		r:Draw(10,10,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, h-3, ( ( self.removeTime - CurTime() ) / self.duration ) * w, 3)
		if CurTime() > self.removeTime then
			self:Remove()
			table.RemoveByValue(landis.Notifications, self)
		end
	end

	local yoffset = 0

	for v,k in ipairs(landis.Notifications) do

		yoffset = yoffset - 20 - k:GetTall()

	end

	self:SetPos(ScrW()-w-20,ScrH()-h-40+yoffset)
	table.ForceInsert(landis.Notifications, self)

end

function PANEL:SetDuration(time)
	self.removeTime = CurTime() + time
	self.duration   = time
end

function PANEL:Init()
	self:SetSize(320,80)
	//self:SetPos(ScrW()-200,ScrH()-100)

	surface.PlaySound(Sound("buttons/blip1.wav"))
	self.removeTime = CurTime() + 5
	self.duration   = 5

	//self.message = vgui.Create("DLabel", self)
end

vgui.Register("landisNotify",PANEL, "DPanel")