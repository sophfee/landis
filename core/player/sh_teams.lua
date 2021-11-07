local meta = FindMetaTable("Player")

landis.Teams = landis.Teams or {}
landis.Teams.Data = landis.Teams.Data or {}

-- provide table for team data
-- 

function landis.Teams.Define(self)
	
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

	return teamIndex
end

hook.Add("CreateTeams", "landis_SetupTestTeams", function()

	TEAM_TEST_1 = landis.Teams.Define({
		UniqueID = "test_one",
		Description = "This is team 1, we are red.",
		DisplayName = "Team 1",
		Limit = 1,
		Model = "models/player/group01/male_02.mdl",
		TeamColor = Color(255,0,0)
	})

	TEAM_TEST_2 = landis.Teams.Define({
		UniqueID = "test_two",
		Description = "This is team 2, we are blue.",
		DisplayName = "Team 2",
		Model = "models/player/group01/male_07.mdl",
		TeamColor = Color(0,0,255)
	})

end)