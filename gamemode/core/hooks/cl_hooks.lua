local ply = LocalPlayer()

function GM:AddDeathNotice()
end

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

hook.Add("Think", "landisRagdollCamera",function()
	if not IsValid(ply) then ply = LocalPlayer() return end
	if not ply:Alive() then
		if not hookRunning then
			ply:DoRagdollCamera()
		end
	else
		hook.Remove("CalcView","landisCalcRagdollCamera")
	end
end)
