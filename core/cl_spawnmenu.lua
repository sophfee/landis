hook.Add( "SpawnMenuOpen", "SpawnMenuWhitelist", function()
	return LocalPlayer():IsAdmin()
end )

hook.Add( "AddToolMenuTabs", "myHookClass", function()
	spawnmenu.AddToolTab( "Tab name!", "#Unique_Name", "icon16/wrench.png" )
end )