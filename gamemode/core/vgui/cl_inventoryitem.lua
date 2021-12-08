local PANEL = {}

function PANEL:Init()
    self:SetSize(400,80)
    self:SetText("")

    self.Name  = ""
    self.Desc  = ""
    self.Model = vgui.Create("DModelPanel",self,"ItemModelDisplay")
    self.Model:SetPos(0,0)
    self.Model:SetSize(80,80)
    self.Index = 0

    self:Dock(TOP)
end

function PANEL:Paint(w,h)
    landis.DrawGradient("left",0,0,w,h,landis.Config.MainColor)
    landis.DrawText(
        self.Name, 
        5,
        5,
        {},
        {x=0,y=0},
        color_white
    )
end

vgui.Register("landisItem", PANEL, "DButton")
