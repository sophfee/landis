PANEL = {}

landis.PlayerVoice = {}

function PANEL:Init()
    self.Player = nil
    self:SetSize(200,30)
    self:SetPos(ScrW()-250,ScrH()-120-(#landis.PlayerVoice*40))
end

function PANEL:SetPlayer(ply)
    self.Player = ply
    landis.PlayerVoice[ply:EntIndex()] = self
end

function PANEL:Paint(w,h)

    if not self.Player then return end

    local clr = team.GetColor(self.Player:Team())

    surface.SetDrawColor(clr.r,clr.g,clr.b,120)
    surface.DrawRect(0, 0, w, h)

    landis.blur(self,200,4,4)

    surface.SetDrawColor(40,40,40,255)
    surface.DrawOutlinedRect(0,0,w,h,2)

    surface.SetDrawColor(40,40,40,255)
    surface.DrawRect(0,h-4,w*self.Player:VoiceVolume(),2,2)

    landis.DrawText(self.Player:GetRPName(),5,h/2,{size=24,bold=true,shadow=true},{x=TEXT_ALIGN_LEFT,y=TEXT_ALIGN_CENTER},color_white)

    if not self.Player:IsSpeaking() then
        
        landis.PlayerVoice[self.Player:EntIndex()] = nil
        self:Remove()

    end

end

vgui.Register("landisVoicePanel",PANEL,"DPanel")