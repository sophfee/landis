util.AddNetworkString("landisRefreshTable")

hook.Add("WeaponEquip", "landisRefreshTable", function(_,ply)
    net.Start("landisRefreshTable")
        net.WriteInt(_:GetSlot(), 32)
    net.Send(ply)
end)