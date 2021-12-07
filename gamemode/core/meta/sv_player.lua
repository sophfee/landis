local PLAYER = FindMetaTable("Player")

function PLAYER:SetXP( num )
  sql.Query("UPDATE landis_user SET xp = " .. num .. " WHERE steamid = " .. sql.SQLStr( self:SteamID64() ) )
  self:SetNWInt( "XP", num )
end
