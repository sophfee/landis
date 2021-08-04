g_base.chat = {}
g_base.chat.commands = {}
local baseStruct = {
	RequireAlive    = false,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_USER,
	HelpDescription = "Unset description.",
	canRun = function(self,ply,args)
		if self.RequireAlive then
			if not ply:Alive() then return false end
		end
		if (self.RequireArgs == true) then
			if not args then return false end
			if #args <= 0 then return false end
		end
		return g_base.GetPermissionLevel(ply) >= self.PermissionLevel
	end,
	onRun  = function(self,ply,args)
		-- this should be used and not left to the default set by the base
	end
}

function g_base.chat.RegisterCommand(className,struct)
	if not className or not struct then return end
	local makeStruct = table.Inherit(struct, baseStruct)
	-- shoud never fail
	if makeStruct then
		g_base.chat.commands[string.lower(className)] = makeStruct
		if SERVER then
			g_base.ConsoleMessage("Registered Chat Command: "..className)
		end
	end
end

hook.Add("PlayerSay", "chat-plugin-runner", function(ply,text)
	if string.Left(text, 1) == "/" then
		local arr = string.Split(text, " ")
		local command = string.lower(table.Copy(arr)[1])
		table.remove(arr, 1)
		local args = table.Copy(arr)
		local validCommands = table.Copy(g_base.chat.commands)
		if validCommands[command] then
			
			local cmdData = validCommands[command]

			-- can client run the command
			if cmdData.canRun(cmdData,ply,args) then
				cmdData.onRun(cmdData,ply,args)
				return ""
			else
				ply:ChatPrint("You do not have permission to use this command.")
				return ""
			end
		end
		ply:ChatPrint("The command \"" .. command .. "\" doesn't exist." )
		return ""
	end
end)