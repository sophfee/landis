local meta = FindMetaTable("Player")

landis.Teams = landis.Teams or {}
landis.Teams.Data = landis.Teams.Data or {}
landis.TeamIndex = landis.TeamIndex or 1

-- provide table for team data
-- 

-- Must be hooked into CreateTeams or bugs out
function landis.Teams.Define(self)

	for _,Team in ipairs(landis.Teams.Data) do
		if Team.UniqueID == self.UniqueID then
			return _
		end
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

if CLIENT then
	hook.Add("PreDrawHalos", "landisTeamOutline", function()
		local ply = LocalPlayer()
		local playerTeam = ply:Team()
		local teamData = landis.Teams.Data[playerTeam] 
		if teamData then
			if teamData["OutlineTeamMates"] then
				outline.Add(team.GetPlayers(playerTeam),team.GetColor(playerTeam),teamData.OutlineMode)
			end
		end
	end)
end