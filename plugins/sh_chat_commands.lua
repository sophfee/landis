g_base.chat = {}
g_base.chat.commands = {}
local baseStruct = {
	RequireAlive    = false,
	RequireArgs     = false,
	PermissionLevel = PERMISSION_LEVEL_USER,
	canRun = function(self,ply)
		return g_base.GetPermissionLevel(ply) >= self.PermissionLevel
	end,
	onRun  = function(self,ply,args)
		-- this like... should be used and not left to the default set by the base
	end
}

function g_base.chat.RegisterCommand(className,struct)
	if not className or not struct then return end
	local makeStruct = table.Inherit(struct, baseStruct)
	-- shoud never fail
	if makeStruct then
		g_base.chat.commands[string.lower(className)] = makeStruct
		if SERVER then
			g_base.ConsoleMessage("Registered Chat Command: ",className)
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
			if cmdData.canRun(cmdData,ply) then
				cmdData.onRun(cmdData,ply,args)
			end
		else
			ply:ChatPrint("You do not have permission to use this command.")
			return ""
		end
		ply:ChatPrint("The command \"" .. command .. "\" doesn't exist." )
		return ""
	end
end)