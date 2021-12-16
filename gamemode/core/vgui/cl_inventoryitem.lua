--[[
INTERNAL VGUI PANEL! DO NOT CREATE MANUALLY
]]--

local PANEL = {}

function PANEL:Init()
    self:SetSize(400,80)
    self:SetText("")

    self.Name  = ""
    self.Desc  = ""
    self.Model = vgui.Create("DModelPanel",self,"ItemModelDisplay")
    self.Model:SetPos(0,0)
    self.Model:SetSize(80,80)
    function self.Model:LayoutEntity() return end
    self.Index = 0

    self:Dock(TOP)
end

function PANEL:SetItem(index)
    
    local itm = LocalPlayer().Inventory[index]
    
    if itm then
        
        self.Name = itm.DisplayName
        self.Desc = itm.Description
        self.Index = index
        
        local c = itm.iconCam
        self.Model:SetModel(Model(itm.Model))
        self.Model:SetCamPos(c.pos)
        self.Model:SetFOV(c.fov)
        self.Model:SetLookAt(c.lookAt)
        
    end
    
end

function PANEL:Paint(w,h)
    landis.DrawGradient("left",0,0,w,h,landis.Config.MainColor)
    landis.DrawText(
        self.Name, 
        85,
        5,
        {shadow=true},
        {x=0,y=0},
        Color(160,160,0,255)
    )
    landis.DrawText(
        self.Desc, 
        85,
        34,
        {shadow=true},
        {x=0,y=0},
        color_white
    )
end

function PANEL:DoClick()
    local I = LocalPlayer().Inventory[self.Index]
    local Index = self.Index
    if I then
        local M = DermaMenu()
        if I.Usable then
            M:AddOption(I.UseText, function()
                if I.UseBar then
                    INVENTORY_PANEL:Hide()
                    net.Start("landisItemUse")
                        net.WriteInt(Index, 32)
                    net.SendToServer()
                    landis.MakeBar(I.UseBarText, I.UseBarTime, function()
                        I.OnUse(I,LocalPlayer(),Index)
                        if IsValid(INVENTORY_PANEL) then
                            INVENTORY_PANEL:Show()
                        end
                    end)
                    
                end
                if I.UseRemove then
                    self:Remove()
                end
            end)
        end
        if I.Droppable then
            M:AddOption("Drop", function()
                I.onDrop(I,LocalPlayer(),self.Index)
                net.Start("landisItemDrop")
                    net.WriteInt(self.Index, 32)
                net.SendToServer()
                self:Remove()
            end)
        end
        if I.CanEquip then
            M:AddOption("Equip", function()
                I.OnEquip(I,LocalPlayer(),self.Index)
                net.Start("landisItemEquip")
                    net.WriteInt(self.Index, 32)
                net.SendToServer()
            end)
        end
        M:Open()
    end
end

vgui.Register("landisItem", PANEL, "DButton")
