local meta = FindMetaTable("Player")

landis.Teams = landis.Teams or {}
landis.Teams.Data = {}
landis.TeamIndex = landis.TeamIndex or 1

-- provide table for team data
-- 

-- Must be hooked into CreateTeams or bugs out
function landis.Teams.Define(self)
	
	if landis.Teams.Data[self.UniqueID] then
		landis.ConsoleMessage("Tried to define already existing team!")
		return nil
	end
	landis.ConsoleMessage("Registering team \""..self.UniqueID.."\"")
	team.SetUp(landis.TeamIndex, self.DisplayName, self.TeamColor, true)
	landis.Teams.Data[landis.TeamIndex] = self
	landis.TeamIndex = landis.TeamIndex + 1

	return teamIndex
end

function meta:GetTeamData()
	return landis.Teams.Data[self:Team()]
end

function meta:GetLoadout()
	return self:GetTeamData().loadout or nil
end

if SERVER then

	hook.Add("PlayerLoadout", "landisTeamLoadout", function(ply)
		local loadout = ply:GetLoadout() or nil
		if loadout then
			for v,k in pairs(loadout.weapons) do
				print(v)
				ply:Give(v)
			end
			for v,k in pairs(loadout.ammo) do
				print(v)
				ply:GiveAmmo(k,v,true)
			end
		end
	end)
end

local VENDOR = landis.lib.CreateVendorTable()
