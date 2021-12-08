local PANEL = {}

function PANEL:Init()
    self:SetSize(400,160)

    self.Name  = ""
    self.Desc  = ""
    self.Model = nil
    self.Index = 0


end

function PANEL:Paint(w,h)
    landis.DrawText(
        self.Name, 
        5,
        5,
        {},
        {x=0,y=0},
        color_white
    )
end

vgui.Register("landisItem", PANEL, "DPanel")