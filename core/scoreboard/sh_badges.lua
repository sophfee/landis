/*
** Badges is a sub-section of the Scoreboard system, it allows certain icons to appear for users that qualify.
*/

print("hi")
g.Badges = {}

local testers = {
	["STEAM_0:1:92733650"] = true
}

g.Badges.Data = {
	{
		icon = "icon16/cog.png",
		desc = "This user is a g_base developer.",
		userTest = function(ply)
			return ply:SteamID() == "STEAM_0:1:92733650"
		end
	},
	{
		icon = "icon16/shield.png",
		desc = "This user is an admin.",
		userTest = function(ply)
			return ply:IsAdmin() and not ply:IsSuperAdmin()
		end
	},
	{
		icon = "icon16/shield_add.png",
		desc = "This user is a super admin.",
		userTest = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		icon = "icon16/bug.png",
		desc = "This user has found critical bugs or helped test the gamemode a lot.",
		userTest = function(ply)
			return testers[ply:SteamID()]
		end
	}
}