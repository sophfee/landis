function GM:HUDDrawTargetID()
end

hook.Add("PlayerBindPress", "landisInventoryMenuOpen", function(ply, bind, pressed)
    if bind == "+menu_context" then
        if not input.IsKeyDown(KEY_LALT) then
            if pressed then
                INVENTORY_PANEL = vgui.Create("landisInventory")
            else
                INVENTORY_PANEL:Remove()
                
            end
            return true
        end
        if not pressed then
            if INVENTORY_PANEL then
                INVENTORY_PANEL:Remove()
            end
        end
    end
end)