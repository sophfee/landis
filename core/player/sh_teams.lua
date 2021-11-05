local meta = FindMetaTable("Player")

landis.Teams = landis.Teams or {}
landis.Teams.Data = landis.Teams.Data or {}

-- provide table for team data
-- 

function landis.Teams.Define(self)
	hook.Add("CreateTeams", self.UniqueID, function()
		if landis.Teams.Data[self.UniqueID] then
			landis.ConsoleMessage("Tried to define already existing team!")
			return nil
		end
		landis.ConsoleMessage("Registering team \""..self.UniqueID.."\"")
		local teamIndex
		for i=1,1000 do
			if not team.Valid(i) then
				teamIndex = i
				break
			end
		end
		team.SetUp(teamIndex, self.DisplayName, self.TeamColor, true)
		landis.Teams.Data[teamIndex] = self
	end)
	return teamIndex
end

TEAM_PETER_GRIFFIN = landis.Teams.Define({
	UniqueID = "peter",
	DisplayName = "Peter Griffin",
	Limit = 1,
	TeamColor = Color(255,0,0)
})

TEAM_LOWIS = landis.Teams.Define({
	UniqueID = "lowis",
	DisplayName = "Lowis",
	TeamColor = Color(0,255,0)
})