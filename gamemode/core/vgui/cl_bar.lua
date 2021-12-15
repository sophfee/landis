PANEL = {}

local tostring = tostring
local math = math
local floor = math.floor

Ellipsis = {
  [1] = ".",
  [2] = "..",
  [3] = "..."
}

function PANEL:Init()
  self.Tween = nil
  self.Callback = nil
  self.Progress = 0
  self.Label = "Using"
  self.EllipsisIndex = 1
  self.EllipsisChangeAt = CurTime() + 0.5
  self:SetSize(ScrW()/2,ScrH()/16)
  self:Center()
  self:MakePopup()
end

function PANEL:SetupBar(Label,Time)
  self.Tween = tween.new(self, Time, {"Progress"=1}, "linear")
  self.Label = Label or "Using"
end

function PANEL:SetCallback(Callback)
  if Callback then
    self.Callback = Callback
  end
end

function PANEL:Paint(w,h)
  local mainColor = landis.Config.MainColor
  if self.Tween then
    self.Tween:update(Frametime())
  end
  if CurTime() > self.EllipsisChangeAt then
    self.EllipsisIndex = self.EllipsisIndex + 1
    if self.EllipsisIndex > 3 then
      self.EllipsisIndex = 1
    end
    self.EllipsisChangeAt = CurTime() + 0.5
  end
  surface.SetDrawColor(40,40,40,135)
  surface.DrawRect(0,0,w,h)
  landis.blur(self,200,10,20)
  surface.SetDrawColor(mainColor.r,mainColor.g,mainColor.b,255)
  surface.DrawRect(0,0,w*(self.Progress),h)
  surface.SetDrawColor(40,40,40,255)
  surface.DrawOutlinedRect(0,0,w,h,2)
  landis.DrawText(tostring(floor(self.Progress)).."%",w/2,h/2,{size=24,bold=true,shadow=true},{x=TEXT_ALIGN_CENTER,y=TEXT_ALIGN_CENTER},color_white})
  landis.DrawText(self.Label .. Ellipsis[self.EllipsisIndex],10,10,{size=18,bold=false,shadow=true},{x=TEXT_ALIGN_LEFT,y=TEXT_ALIGN_TOP},color_white})
  if self.Progress == 1 then
    if self.Callback then
      self.Callback()
    end
    self:Remove()
  end
end

vgui.Register("landisBar",PANEL,"DPanel")
