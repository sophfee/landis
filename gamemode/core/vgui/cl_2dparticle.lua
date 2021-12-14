-- little effect for death transition
local PANEL = {}

function PANEL:Init()
	self.Material = Material("particle/particle_smokegrenade")
	self.Running = false
	self.StartTime = nil
	self.Scale = 1
	self.StartRotation = math.Rand(0, 360)
	self.StartX = ScrW()/2
	self.StartY = ScrH()/2
	self.Duration = math.Rand(0.3,1.9)
	self:SetSize(160,160)
	self:Center()
end

function PANEL:Paint(w,h)
	if self.Running then
		draw.NoTexture()
		local normTime = ((self.Duration-(CurTime()-self.StartTime))/self.Duration)
		--print(normTime)
		surface.SetDrawColor(255, 255, 255, math.floor(normTime*255))
		surface.SetMaterial(self.Material)
		surface.DrawTexturedRectRotated(w/2, h/2, w/self.Scale, h/self.Scale, math.floor((self.StartRotation*(normTime*normTime)+self.StartRotation)))
	end
end

function PANEL:Start()
	self.StartTime = CurTime()
	self.Running = true
end

vgui.Register("landisParticle", PANEL, "Panel")

function landis.Smoke2D(x,y)
	local a = vgui.Create("landisParticle")
	a:SetPos(x,y)
	a:Start()
	timer.Simple(5, function()
		a:Remove()
	end)
end