----// landys.chatbox //----
-- Author: Exho (obviously), Tomelyr, LuaTenshi
-- Version: 4/12/15

landys.chatbox = {}
landys.chatbox.isOpen = false
messages = {}
landys.chatbox.config = {
	timeStamps = false,
	position = 1,	
	fadeTime = 12
}
landys.chatbox.CommandColors = {}
landys.chatbox.CommandColors[PERMISSION_LEVEL_USER] = Color(10,132,255,255)
landys.chatbox.CommandColors[PERMISSION_LEVEL_ADMIN] = Color(52,199,89,255)
landys.chatbox.CommandColors[PERMISSION_LEVEL_LEAD_ADMIN] = Color(88,86,214)
landys.chatbox.CommandColors[PERMISSION_LEVEL_SUPERADMIN] = Color(255,69,58)

surface.CreateFont( "landys.chatbox_18", {
	font = "Arial",
	size = 18,
	weight = 3500,
	antialias = true,
	shadow = true,
	extended = true,
} )

surface.CreateFont( "landys.chatbox_16", {
	font = "Arial",
	size = 16,
	weight = 3500,
	antialias = true,
	shadow = true,
	extended = true,
} )


--// Builds the chatbox but doesn't display it
function landys.chatbox.buildBox()
	landys.chatbox.frame = vgui.Create("DFrame")
	landys.chatbox.frame:SetSize( ScrW()*0.375, ScrH()*0.25 )
	landys.chatbox.frame:SetTitle("")
	landys.chatbox.frame:ShowCloseButton( false )
	//landys.chatbox.frame:SetDraggable( true )
	//landys.chatbox.frame:SetSizable( true )
	landys.chatbox.frame:SetPos( ScrW()*0.0116, (ScrH() - landys.chatbox.frame:GetTall()) - ScrH()*0.177)
	landys.chatbox.frame:SetMinWidth( 300 )
	landys.chatbox.frame:SetMinHeight( 100 )
	landys.chatbox.oldPaint = landys.chatbox.frame.Paint
	landys.chatbox.frame.Think = function()
		if input.IsKeyDown( KEY_ESCAPE ) then
			landys.chatbox.hideBox()
		end
	end
	
	local serverName = vgui.Create("DLabel", landys.chatbox.frame)
	serverName:SetText( GetHostName() )
	serverName:SetFont( "landys.chatbox_18")
	serverName:SizeToContents()
	serverName:SetPos( 5, 4 )
	
	landys.chatbox.entry = vgui.Create("DTextEntry", landys.chatbox.frame) 
	landys.chatbox.entry:SetSize( landys.chatbox.frame:GetWide() - 50, 20 )
	landys.chatbox.entry:SetTextColor( color_white )
	landys.chatbox.entry:SetFont("landys.chatbox_18")
	landys.chatbox.entry:SetDrawBorder( false )
	landys.chatbox.entry:SetDrawBackground( false )
	landys.chatbox.entry:SetCursorColor( color_white )
	landys.chatbox.entry:SetHighlightColor( Color(52, 152, 219) )
	landys.chatbox.entry:SetPos( 45, landys.chatbox.frame:GetTall() - landys.chatbox.entry:GetTall() - 5 )
	landys.chatbox.entry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end

	landys.chatbox.entry.OnTextChanged = function( self )
		if self and self.GetText then 
			gamemode.Call( "ChatTextChanged", self:GetText() or "" )
		end
	end

	landys.chatbox.entry.OnKeyCodeTyped = function( self, code )
		local types = {"", "teamchat", "console"}

		if code == KEY_ESCAPE then

			landys.chatbox.hideBox()
			gui.HideGameUI()

		elseif code == KEY_TAB then
			
			landys.chatbox.TypeSelector = (landys.chatbox.TypeSelector and landys.chatbox.TypeSelector + 1) or 1
			
			if landys.chatbox.TypeSelector > 3 then landys.chatbox.TypeSelector = 1 end
			if landys.chatbox.TypeSelector < 1 then landys.chatbox.TypeSelector = 3 end
			
			landys.chatbox.ChatType = types[landys.chatbox.TypeSelector]

			timer.Simple(0.001, function() landys.chatbox.entry:RequestFocus() end)

		elseif code == KEY_ENTER then
			-- Replicate the client pressing enter
			
			if string.Trim( self:GetText() ) != "" then
				if landys.chatbox.ChatType == types[2] then
					LocalPlayer():ConCommand("say_team \"" .. (self:GetText() or "") .. "\"")
				elseif landys.chatbox.ChatType == types[3] then
					LocalPlayer():ConCommand(self:GetText() or "")
				else
					LocalPlayer():ConCommand("say \"" .. self:GetText() .. "\"")
				end
			end

			landys.chatbox.TypeSelector = 1
			landys.chatbox.hideBox()
		end
	end

	landys.chatbox.chatLog = vgui.Create("RichText", landys.chatbox.frame) 
	landys.chatbox.chatLog:SetSize( landys.chatbox.frame:GetWide() - 10, landys.chatbox.frame:GetTall() - 60 )
	landys.chatbox.chatLog:SetPos( 5, 30 )
	landys.chatbox.chatLog.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
	end
	landys.chatbox.chatLog.Think = function( self )
		if landys.chatbox.lastMessage then
			if CurTime() - landys.chatbox.lastMessage > landys.chatbox.config.fadeTime then
				self:SetVisible( false )
			else
				self:SetVisible( true )
			end
		end
		self:SetSize( landys.chatbox.frame:GetWide() - 10, landys.chatbox.frame:GetTall() - landys.chatbox.entry:GetTall() - serverName:GetTall() - 20 )
		//settings:SetPos( landys.chatbox.frame:GetWide() - settings:GetWide(), 0 )
	end
	landys.chatbox.chatLog.PerformLayout = function( self )
		self:SetFontInternal("landys.chatbox_18")
		self:SetFGColor( color_white )
	end
	landys.chatbox.chatLog.PaintOver = function( self, w, h )
        if not landys.chat then return end
        if not landys.chat.commands then return end
        if landys.chatbox.entry:IsEditing() then
            local typed = landys.chatbox.entry:GetValue()
            if not typed then return end
            typed = string.Split(typed, " ")[1]
            local len   = string.len(typed)
            if string.Left(typed, 1) == "/" then
                blurDerma(self,200,15,10)
                surface.SetDrawColor(30, 30, 30, 200)
                surface.DrawRect(0, 0, w, h)
                local i = 1
                local pLevel = LocalPlayer():GetPermissionLevel()
                for name,data in pairs( landys.chat.commands ) do
                    if string.Left(typed, len) == string.Left(name, len) then
                        if pLevel < data.PermissionLevel then 
                            continue 
                        end 
                        draw.SimpleText(name .. " - " .. data.HelpDescription, "landys.chatbox_18", 5, 5 + ((i-1)*18), landys.chatbox.CommandColors[data.PermissionLevel])
                        i = i + 1
                    end
                end
            end
        end
    end
	landys.chatbox.oldPaint2 = landys.chatbox.chatLog.Paint
	
	local text = "Say :"

	local say = vgui.Create("DLabel", landys.chatbox.frame)
	say:SetText("")
	surface.SetFont( "landys.chatbox_18")
	local w, h = surface.GetTextSize( text )
	say:SetSize( w + 5, 20 )
	say:SetPos( 5, landys.chatbox.frame:GetTall() - landys.chatbox.entry:GetTall() - 5 )
	
	say.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		draw.DrawText( text, "landys.chatbox_18", 2, 1, color_white )
	end

	say.Think = function( self )
		local types = {"", "teamchat", "console"}
		local s = {}

		if landys.chatbox.ChatType == types[2] then 
			text = "Say (TEAM) :"	
		elseif landys.chatbox.ChatType == types[3] then
			text = "Console :"
		else
			text = "Say :"
			s.pw = 45
			s.sw = landys.chatbox.frame:GetWide() - 50
		end

		if s then
			if not s.pw then s.pw = self:GetWide() + 10 end
			if not s.sw then s.sw = landys.chatbox.frame:GetWide() - self:GetWide() - 15 end
		end

		local w, h = surface.GetTextSize( text )
		self:SetSize( w + 5, 20 )
		self:SetPos( 5, landys.chatbox.frame:GetTall() - landys.chatbox.entry:GetTall() - 5 )

		landys.chatbox.entry:SetSize( s.sw, 20 )
		landys.chatbox.entry:SetPos( s.pw, landys.chatbox.frame:GetTall() - landys.chatbox.entry:GetTall() - 5 )
	end	
	
	landys.chatbox.hideBox()
end

--// Hides the chat box but not the messages
function landys.chatbox.hideBox()
	landys.chatbox.isOpen = false

	landys.chatbox.frame.Paint = function() end
	landys.chatbox.chatLog.Paint = function() end
	
	landys.chatbox.chatLog:SetVerticalScrollbarEnabled( false )
	landys.chatbox.chatLog:GotoTextEnd()
	
	landys.chatbox.lastMessage = landys.chatbox.lastMessage or CurTime() - landys.chatbox.config.fadeTime
	
	-- Hide the chatbox except the log
	local children = landys.chatbox.frame:GetChildren()
	for _, pnl in pairs( children ) do
		if pnl == landys.chatbox.frame.btnMaxim or pnl == landys.chatbox.frame.btnClose or pnl == landys.chatbox.frame.btnMinim then continue end
		
		if pnl != landys.chatbox.chatLog then
			pnl:SetVisible( false )
		end
	end
	
	-- Give the player control again
	landys.chatbox.frame:SetMouseInputEnabled( false )
	landys.chatbox.frame:SetKeyboardInputEnabled( false )
	gui.EnableScreenClicker( false )
	
	-- We are done chatting
	gamemode.Call("FinishChat")
	
	-- Clear the text entry
	landys.chatbox.entry:SetText( "" )
	gamemode.Call( "ChatTextChanged", "" )
	landys.chatbox.chatLog:SetVisible(true)
end

--// Shows the chat box
function landys.chatbox.showBox()
	landys.chatbox.isOpen = true
	-- Draw the chat box again
	landys.chatbox.frame.Paint = landys.chatbox.oldPaint
	landys.chatbox.chatLog.Paint = landys.chatbox.oldPaint2
	
	landys.chatbox.chatLog:SetVerticalScrollbarEnabled( true )
	landys.chatbox.lastMessage = nil
	
	-- Show any hidden children
	local children = landys.chatbox.frame:GetChildren()
	for _, pnl in pairs( children ) do
		if pnl == landys.chatbox.frame.btnMaxim or pnl == landys.chatbox.frame.btnClose or pnl == landys.chatbox.frame.btnMinim then continue end
		
		pnl:SetVisible( true )
	end
	landys.chatbox.chatLog:SetVisible(true)
	-- MakePopup calls the input functions so we don't need to call those
	landys.chatbox.frame:MakePopup()
	landys.chatbox.entry:RequestFocus()
	
	-- Make sure other addons know we are chatting
	gamemode.Call("StartChat")
end

--// Opens the settings panel
function landys.chatbox.openSettings()
	landys.chatbox.hideBox()
	
	landys.chatbox.frameS = vgui.Create("DFrame")
	landys.chatbox.frameS:SetSize( 400, 300 )
	landys.chatbox.frameS:SetTitle("")
	landys.chatbox.frameS:MakePopup()
	landys.chatbox.frameS:SetPos( ScrW()/2 - landys.chatbox.frameS:GetWide()/2, ScrH()/2 - landys.chatbox.frameS:GetTall()/2 )
	landys.chatbox.frameS:ShowCloseButton( true )
	landys.chatbox.frameS.Paint = function( self, w, h )
		landys.chatbox.blur( self, 10, 20, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 80, 80, 80, 100 ) )
		
		draw.RoundedBox( 0, 0, 25, w, 25, Color( 50, 50, 50, 50 ) )
	end
	
	local serverName = vgui.Create("DLabel", landys.chatbox.frameS)
	serverName:SetText( "landys.chatbox - Settings" )
	serverName:SetFont( "landys.chatbox_18")
	serverName:SizeToContents()
	serverName:SetPos( 5, 4 )
	
	local label1 = vgui.Create("DLabel", landys.chatbox.frameS)
	label1:SetText( "Time stamps: " )
	label1:SetFont( "landys.chatbox_18")
	label1:SizeToContents()
	label1:SetPos( 10, 40 )
	
	local checkbox1 = vgui.Create("DCheckBox", landys.chatbox.frameS ) 
	checkbox1:SetPos(label1:GetWide() + 15, 42)
	checkbox1:SetValue( landys.chatbox.config.timeStamps )
	
	local label2 = vgui.Create("DLabel", landys.chatbox.frameS)
	label2:SetText( "Fade time: " )
	label2:SetFont( "landys.chatbox_18")
	label2:SizeToContents()
	label2:SetPos( 10, 70 )
	
	local textEntry = vgui.Create("DTextEntry", landys.chatbox.frameS) 
	textEntry:SetSize( 50, 20 )
	textEntry:SetPos( label2:GetWide() + 15, 70 )
	textEntry:SetText( landys.chatbox.config.fadeTime ) 
	textEntry:SetTextColor( color_white )
	textEntry:SetFont("landys.chatbox_18")
	textEntry:SetDrawBorder( false )
	textEntry:SetDrawBackground( false )
	textEntry:SetCursorColor( color_white )
	textEntry:SetHighlightColor( Color(52, 152, 219) )
	textEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end
	
	--[[local checkbox2 = vgui.Create("DCheckBox", landys.chatbox.frameS ) 
	checkbox2:SetPos(label2:GetWide() + 15, 72)
	checkbox2:SetValue( landys.chatbox.config.selandys.chatboxTags )
	
	local label3 = vgui.Create("DLabel", landys.chatbox.frameS)
	label3:SetText( "Use chat tags: " )
	label3:SetFont( "landys.chatbox_18")
	label3:SizeToContents()
	label3:SetPos( 10, 100 )
	
	local checkbox3 = vgui.Create("DCheckBox", landys.chatbox.frameS ) 
	checkbox3:SetPos(label3:GetWide() + 15, 102)
	checkbox3:SetValue( landys.chatbox.config.uslandys.chatboxTag )]]
	
	local save = vgui.Create("DButton", landys.chatbox.frameS)
	save:SetText("Save")
	save:SetFont( "landys.chatbox_18")
	save:SetTextColor( Color( 230, 230, 230, 150 ) )
	save:SetSize( 70, 25 )
	save:SetPos( landys.chatbox.frameS:GetWide()/2 - save:GetWide()/2, landys.chatbox.frameS:GetTall() - save:GetTall() - 10)
	save.Paint = function( self, w, h )
		if self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 200 ) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ) )
		end
	end
	save.DoClick = function( self )
		landys.chatbox.frameS:Close()
		
		landys.chatbox.config.timeStamps = checkbox1:GetChecked() 
		landys.chatbox.config.fadeTime = tonumber(textEntry:GetText()) or landys.chatbox.config.fadeTime
	end
end

--// Panel based blur function by Chessnut from NutScript
local blur = Material( "pp/blurscreen" )
function landys.chatbox.blur( panel, layers, density, alpha )
	-- Its a scientifically proven fact that blur improves a script
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

local oldAddText = chat.AddText

--// Overwrite chat.AddText to detour it into my chatbox
function chat.AddText(...)
	if not landys.chatbox.chatLog then
		landys.chatbox.buildBox()
	end
	
	local msg = vgui.Create( "chatmessage", landys.chatbox.chatLog )
	msg:SetMessage( ... )
	msg:Dock( TOP )
	
	-- Iterate through the strings and colors
	--[[for _, obj in pairs( {...} ) do
		if type(obj) == "table" then
			landys.chatbox.chatLog:InsertColorChange( obj.r, obj.g, obj.b, obj.a )
			table.insert( msg, Color(obj.r, obj.g, obj.b, obj.a) )
		elseif type(obj) == "string"  then
			landys.chatbox.chatLog:AppendText( obj )
			table.insert( msg, obj )
		elseif obj:IsPlayer() then
			local ply = obj
			
			if landys.chatbox.config.timeStamps then
				landys.chatbox.chatLog:InsertColorChange( 130, 130, 130, 255 )
				landys.chatbox.chatLog:AppendText( "["..os.date("%X").."] ")
			end
			
			if landys.chatbox.config.selandys.chatboxTags and ply:GetNWBool("landys.chatbox_tagEnabled", false) then
				local col = ply:GetNWString("landys.chatbox_tagCol", "255 255 255")
				local tbl = string.Explode(" ", col )
				landys.chatbox.chatLog:InsertColorChange( tbl[1], tbl[2], tbl[3], 255 )
				landys.chatbox.chatLog:AppendText( "["..ply:GetNWString("landys.chatbox_tag", "N/A").."] ")
			end
			
			local col = GAMEMODE:GetTeamColor( obj )
			landys.chatbox.chatLog:InsertColorChange( col.r, col.g, col.b, 255 )
			landys.chatbox.chatLog:AppendText( obj:Nick() )
			table.insert( msg, obj:Nick() )
		end
	end]]
	landys.chatbox.chatLog:AppendText("\n")
	
	landys.chatbox.chatLog:SetVisible( true )
	landys.chatbox.lastMessage = CurTime()
	landys.chatbox.chatLog:InsertColorChange( 255, 255, 255, 255 )
	chat.PlaySound()
--	oldAddText(unpack(msg))
end

--// Write any server notifications
hook.Remove( "ChatText", "landys.chatbox_joinleave")
hook.Add( "ChatText", "landys.chatbox_joinleave", function( index, name, text, type )
	if not landys.chatbox.chatLog then
		landys.chatbox.buildBox()
	end
	
	if type != "chat" then
		landys.chatbox.chatLog:InsertColorChange( 0, 128, 255, 255 )
		landys.chatbox.chatLog:AppendText( text.."\n" )
		landys.chatbox.chatLog:SetVisible( true )
		landys.chatbox.lastMessage = CurTime()
		return true
	end
end)

--// Stops the default chat box from being opened
hook.Remove("PlayerBindPress", "landys.chatbox_hijackbind")
hook.Add("PlayerBindPress", "landys.chatbox_hijackbind", function(ply, bind, pressed)
	if string.sub( bind, 1, 11 ) == "messagemode" then
		if bind == "messagemode2" then 
			landys.chatbox.ChatType = "teamchat"
		else
			landys.chatbox.ChatType = ""
		end
		
		if IsValid( landys.chatbox.frame ) then
			landys.chatbox.showBox()
		else
			landys.chatbox.buildBox()
			landys.chatbox.showBox()
		end
		return true
	end
end)

--// Hide the default chat too in case that pops up
hook.Remove("HUDShouldDraw", "landys.chatbox_hidedefault")
hook.Add("HUDShouldDraw", "landys.chatbox_hidedefault", function( name )
	if name == "CHudChat" then
		return false
	end
end)

 --// Modify the Chatbox for align.
local oldGetChatBoxPos = chat.GetChatBoxPos
function chat.GetChatBoxPos()
	return landys.chatbox.frame:GetPos()
end

function chat.GetChatBoxSize()
	return landys.chatbox.frame:GetSize()
end

chat.Open = landys.chatbox.showBox
function chat.Close(...) 
	if IsValid( landys.chatbox.frame ) then 
		landys.chatbox.hideBox(...)
	else
		landys.chatbox.buildBox()
		landys.chatbox.showBox()
	end
end