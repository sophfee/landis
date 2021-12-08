local PANEL = {}

INVENTORY_PANEL = nil

function PANEL:Init()
    self:SetSize(800, 600)
    self:SetTitle("Inventory")
    self:ShowCloseButton(false)
    self:SetDraggable(false)

    self.Model = nil
    self.Scroll = vgui.Create("DScrollPanel", self, "InventoryScrollMenu")

    self.Scroll:Dock(FILL)

    for v,k in ipairs(LocalPlayer().Inventory) do
        local ITEM = vgui.Create("landisItem", self.Scroll, "ItemPanel")
        ITEM.Index = v
        ITEM.Name = k.DisplayName
        ITEM.Desc = k.Description
    end

    self:Center()
    self:MakePopup()

end

vgui.Register("landisInventory", PANEL, "DFrame")