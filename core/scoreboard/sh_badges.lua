/*
** Badges is a sub-section of the Scoreboard system, it allows certain icons to appear for users that qualify.
*/

g.Badges = {}

local devs = {
	["STEAM_0:1:92733650"] = true, -- nick
	["STEAM_0:1:155826697"] = true -- fisq
}

local testers = {
	["STEAM_0:1:92733650"] = true, -- nick
	["STEAM_0:1:513014903"] = true, -- creamy
	["STEAM_0:1:545592128"] = true -- henry
}

local smilers = {
	["STEAM_0:1:92733650"] = true, -- nick
	["STEAM_0:1:94748887"] = true  -- idiot swift
}

g.Badges.Data = {
	{
		icon = "icon16/cog.png",
		desc = "This user is a g_base developer.",
		userTest = function(ply)
			return devs[ply:SteamID()]
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
	},
	{
		icon = "materials/badges/smile.png",
		desc = "                 :)                 ",
		userTest = function(ply)
			return smilers[ply:SteamID()]
		end
	}
}