--- A module for Chat Commands and the client's chat box.
-- @module Chat

landis.chat = {}
landis.chat.commands = {}
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
		return ply:GetPermissionLevel() >= self.PermissionLevel
	end,
	onRun  = function(self,ply,args)
		-- this should be used and not left to the default set by the base
	end
}

--- Chat Command
-- Registers a chat command. Must be called on both Client & Server.
-- @param className What a user has to enter into their chatbox, must start with /.
-- @param struct The command data, including the code that runs when the command is issued.
function landis.chat.RegisterCommand(className,struct)
	if not className or not struct then return end
	local makeStruct = table.Inherit(struct, baseStruct)
	-- shoud never fail
	if makeStruct then
		landis.chat.commands[string.lower(className)] = makeStruct
		if SERVER then
			landis.ConsoleMessage("Registered Chat Command: "..className)
		end
	end
end

hook.Add("PlayerSay", "chat-plugin-runner", function(ply,text)
	ply:SetNWBool("IsTyping",false)
	if string.Left(text, 1) == "/" then
		local arr = string.Split(text, " ")
		local command = string.lower(table.Copy(arr)[1])
		table.remove(arr, 1)
		local args = table.Copy(arr)
		local validCommands = table.Copy(landis.chat.commands)
		if validCommands[command] then
			
			local cmdData = validCommands[command]

			-- can client run the command
			if cmdData.canRun(cmdData,ply,args) then
				cmdData.onRun(cmdData,ply,args)
				return ""
			else
				ply:Notify("Invalid Permission or Arguments!")
				return ""
			end
		end
		ply:Notify("The command \"" .. command .. "\" doesn't exist." )
		return ""
	end
	text = string.Replace(text, "<", "&lt;")
	text = string.Replace(text, ">", "&gt;")
	return text
end)