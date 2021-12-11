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

--[[]

Call order:

create vgui
set duration,
set message

]]

function PANEL:SetMessage(text)

	local font = "<font=notifyText>"

	local r = markup.Parse(font..text, self:GetWide()-20)
	local w,h = r:Size()
	self:SetSize(w+20,h+20)
	
	
	self.Paint = function ( self, w, h )
		--blurDerma( self, 200, 10, 20 )
		draw.RoundedBoxEx(16, 0, 0, w, h, Color(30,30,30,self.alpha),true,false,true,false)
		--surface.SetDrawColor(30, 30, 30,180)
		--surface.DrawRect(0, 0, w, h)
		r:Draw(10,10,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,self.alpha)
		local mainColor = landis.Config.MainColor

		draw.RoundedBoxEx(0, w-4, 0, 16, h, Color(mainColor.r, mainColor.g, mainColor.b, self.alpha),true,false,true,false)
		--surface.SetDrawColor(255, 255, 255)
		--surface.DrawRect(0, h-3, ( ( self.removeTime - CurTime() ) / self.duration ) * w, 3)
		if CurTime() > self.removeTime and not self.fadingOut then
			self.fadingOut = true
			surface.PlaySound("landis/ui/notification.mp3")
			for i=1,255 do
				timer.Simple(i/510, function()
					self.alpha = 255-i
				end)
			end
			timer.Simple(0.5, function()
				self:Remove()
				table.RemoveByValue(landis.Notifications, self)
			end)
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
	--self:SetPos(ScrW()-200,ScrH()-100)

	surface.PlaySound(Sound("landis/ui/beep.wav"))
	self.removeTime = CurTime() + 5
	self.duration   = 5
	self.alpha = 0
	self.fadingOut = false
	for i=1,255 do
		timer.Simple(i/510, function()
			self.alpha = i
		end)
	end

	--self.message = vgui.Create("DLabel", self)
end

vgui.Register("landisNotify",PANEL, "DPanel")

