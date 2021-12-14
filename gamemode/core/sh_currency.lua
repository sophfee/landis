if SERVER then
    sql.Query("CREATE TABLE IF NOT EXISTS `landis_currency` ( `steamid` VARCHAR(20) NOT NULL, `cc` NUMBER, `sc` NUMBER ) ")
end

landis.Currency = landis.Currency or {}

local meta = FindMetaTable("Player")
function meta:GetMoney()
    return self:GetNWInt("Money",0)
end

if SERVER then 

    function meta:DropMoney(amt)
        if self:GetMoney() - amt > 0 then
            local Money = ents.Create("landis_money")
            
            local tr = util.QuickTrace(self:EyePos(), self:GetAimVector()*100,self)
            if tr.HitPos then
                Money:SetPos(tr.HitPos)
            else
                Money:SetPos(self:EyePos()+(self:GetAimVector()*100))
            end
            Money:Spawn()
            self:SetNWInt("Money",self:GetMoney()-amt)
            Money:SetMoneyA(amt)
        end
    end

    function meta:GiveMoney(amt)
        local t = self:GetNWInt("Money",0) + amt
        self:SetNWInt("Money",t)
        local Success = sql.Query("UPDATE landis_currency SET cc = " .. tostring(t) .. " WHERE steamid = " .. sql.SQLStr(self:SteamID64()) )
        if Success == false then
            landis.Error("Failed to update Money sync'd value! {" .. t .. "," .. self:SteamID64() .. "," .. tostring(Success) .. "}")
        end
    end

end