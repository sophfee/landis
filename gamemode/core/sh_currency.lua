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
            Money:SetMoney(amt)
            local tr = util.QuickTrace(self:EyePos(), self:EyeVector()*100)
            if tr.HitPos then
                Money:SetPos(tr.HitPos)
            else
                Money:SetPos(self:EyePos()+(self:EyeVector()*100))
            end
            Money:Spawn()
        end
    end
end