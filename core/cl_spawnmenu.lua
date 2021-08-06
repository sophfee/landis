hook.Add( "SpawnMenuOpen", "SpawnMenuWhitelist", function()
	return LocalPlayer():IsAdmin()
end )