----// landis.chatbox //----
-- Author: Exho (obviously), Tomelyr, LuaTenshi
-- Version: 4/12/15

landis.chatbox = {}
landis.chatbox.isOpen = false
messages = {}
landis.chatbox.config = {
	timeStamps = false,
	position = 1,	
	fadeTime = 12
}
landis.chatbox.CommandColors = {}
landis.chatbox.CommandColors[PERMISSION_LEVEL_USER] = Color(10,132,255,255)
landis.chatbox.CommandColors[PERMISSION_LEVEL_ADMIN] = Color(52,199,89,255)
landis.chatbox.CommandColors[PERMISSION_LEVEL_LEAD_ADMIN] = Color(88,86,214)
landis.chatbox.CommandColors[PERMISSION_LEVEL_SUPERADMIN] = Color(255,69,58)

surface.CreateFont( "landis.chatbox_18", {
	font = "Arial",
	size = 18,
	weight = 3500,
	antialias = true,
	shadow = true,
	extended = true,
} )

surface.CreateFont( "landis.chatbox_16", {
	font = "Arial",
	size = 16,
	weight = 3500,
	antialias = true,
	shadow = true,
	extended = true,
} )


--// Builds the chatbox but doesn't display it
function landis.chatbox.buildBox()
	landis.chatbox.frame = vgui.Create("DFrame")
	landis.chatbox.frame:SetSize( ScrW()*0.375, ScrH()*0.25 )
	landis.chatbox.frame:SetTitle("")
	landis.chatbox.frame:ShowCloseButton( false )
	//landis.chatbox.frame:SetDraggable( true )
	//landis.chatbox.frame:SetSizable( true )
	landis.chatbox.frame:SetPos( ScrW()*0.0116, (ScrH() - landis.chatbox.frame:GetTall()) - ScrH()*0.177)
	landis.chatbox.frame:SetMinWidth( 300 )
	landis.chatbox.frame:SetMinHeight( 100 )
	landis.chatbox.oldPaint = landis.chatbox.frame.Paint
	landis.chatbox.frame.Think = function()
		if input.IsKeyDown( KEY_ESCAPE ) then
			landis.chatbox.hideBox()
		end
	end
	
	local serverName = vgui.Create("DLabel", landis.chatbox.frame)
	serverName:SetText( GetHostName() )
	serverName:SetFont( "landis.chatbox_18")
	serverName:SizeToContents()
	serverName:SetPos( 5, 4 )
	
	landis.chatbox.entry = vgui.Create("DTextEntry", landis.chatbox.frame) 
	landis.chatbox.entry:SetSize( landis.chatbox.frame:GetWide() - 50, 20 )
	landis.chatbox.entry:SetTextColor( color_white )
	landis.chatbox.entry:SetFont("landis.chatbox_18")
	landis.chatbox.entry:SetDrawBorder( false )
	landis.chatbox.entry:SetDrawBackground( false )
	landis.chatbox.entry:SetCursorColor( color_white )
	landis.chatbox.entry:SetHighlightColor( Color(52, 152, 219) )
	landis.chatbox.entry:SetPos( 45, landis.chatbox.frame:GetTall() - landis.chatbox.entry:GetTall() - 5 )
	landis.chatbox.entry.Paint = function( self, w, h )
		draw.RoundedBox( landis.Config.CornerRadius, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end

	landis.chatbox.entry.OnTextChanged = function( self )
		if self and self.GetText then 
			gamemode.Call( "ChatTextChanged", self:GetText() or "" )
		end
	end

	landis.chatbox.entry.OnKeyCodeTyped = function( self, code )
		local types = {"", "teamchat", "console"}

		if code == KEY_ESCAPE then

			landis.chatbox.hideBox()
			gui.HideGameUI()

		elseif code == KEY_TAB then
			
			landis.chatbox.TypeSelector = (landis.chatbox.TypeSelector and landis.chatbox.TypeSelector + 1) or 1
			
			if landis.chatbox.TypeSelector > 3 then landis.chatbox.TypeSelector = 1 end
			if landis.chatbox.TypeSelector < 1 then landis.chatbox.TypeSelector = 3 end
			
			landis.chatbox.ChatType = types[landis.chatbox.TypeSelector]

			timer.Simple(0.001, function() landis.chatbox.entry:RequestFocus() end)

		elseif code == KEY_ENTER then
			-- Replicate the client pressing enter
			
			if string.Trim( self:GetText() ) != "" then
				if landis.chatbox.ChatType == types[2] then
					LocalPlayer():ConCommand("say_team \"" .. (self:GetText() or "") .. "\"")
				elseif landis.chatbox.ChatType == types[3] then
					LocalPlayer():ConCommand(self:GetText() or "")
				else
					LocalPlayer():ConCommand("say \"" .. self:GetText() .. "\"")
				end
			end

			landis.chatbox.TypeSelector = 1
			landis.chatbox.hideBox()
		end
	end

	landis.chatbox.chatLog = vgui.Create("DScrollPanel", landis.chatbox.frame) 
	landis.chatbox.chatLog:SetSize( landis.chatbox.frame:GetWide() - 10, landis.chatbox.frame:GetTall() - 60 )
	landis.chatbox.chatLog:SetPos( 5, 30 )
	landis.chatbox.chatLog.Paint = function( self, w, h )
		draw.RoundedBox( landis.Config.CornerRadius, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
	end
	landis.chatbox.chatLog.Think = function( self )
		if landis.chatbox.lastMessage then
			if CurTime() - landis.chatbox.lastMessage > landis.chatbox.config.fadeTime then
				self:SetVisible( false )
			else
				self:SetVisible( true )
			end
		end
		self:SetSize( landis.chatbox.frame:GetWide() - 10, landis.chatbox.frame:GetTall() - landis.chatbox.entry:GetTall() - serverName:GetTall() - 20 )
		//settings:SetPos( landis.chatbox.frame:GetWide() - settings:GetWide(), 0 )
	end
	landis.chatbox.chatLog.PerformLayout = function( self )
		self:SetFontInternal("landis.chatbox_18")
		self:SetFGColor( color_white )
	end
	landis.chatbox.chatLog.PaintOver = function( self, w, h )
        if not landis.chat then return end
        if not landis.chat.commands then return end
        if landis.chatbox.entry:IsEditing() then
            local typed = landis.chatbox.entry:GetValue()
            if not typed then return end
            typed = string.Split(typed, " ")[1]
            local len   = string.len(typed)
            if string.Left(typed, 1) == "/" then
                blurDerma(self,200,15,10)
                surface.SetDrawColor(30, 30, 30, 200)
                surface.DrawRect(0, 0, w, h)
                local i = 1
                local pLevel = LocalPlayer():GetPermissionLevel()
                for name,data in pairs( landis.chat.commands ) do
                    if string.Left(typed, len) == string.Left(name, len) then
                        if pLevel < data.PermissionLevel then 
                            continue 
                        end 
                        draw.SimpleText(name .. " - " .. data.HelpDescription, "landis.chatbox_18", 5, 5 + ((i-1)*18), landis.chatbox.CommandColors[data.PermissionLevel])
                        i = i + 1
                    end
                end
            end
        end
    end
	landis.chatbox.oldPaint2 = landis.chatbox.chatLog.Paint
	
	local text = "Say :"

	local say = vgui.Create("DLabel", landis.chatbox.frame)
	say:SetText("")
	surface.SetFont( "landis.chatbox_18")
	local w, h = surface.GetTextSize( text )
	say:SetSize( w + 5, 20 )
	say:SetPos( 5, landis.chatbox.frame:GetTall() - landis.chatbox.entry:GetTall() - 5 )
	
	say.Paint = function( self, w, h )
		draw.RoundedBox( landis.Config.CornerRadius, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		draw.DrawText( text, "landis.chatbox_18", 2, 1, color_white )
	end

	say.Think = function( self )
		local types = {"", "teamchat", "console"}
		local s = {}

		if landis.chatbox.ChatType == types[2] then 
			text = "Say (TEAM) :"	
		elseif landis.chatbox.ChatType == types[3] then
			text = "Console :"
		else
			text = "Say :"
			s.pw = 45
			s.sw = landis.chatbox.frame:GetWide() - 50
		end

		if s then
			if not s.pw then s.pw = self:GetWide() + 10 end
			if not s.sw then s.sw = landis.chatbox.frame:GetWide() - self:GetWide() - 15 end
		end

		local w, h = surface.GetTextSize( text )
		self:SetSize( w + 5, 20 )
		self:SetPos( 5, landis.chatbox.frame:GetTall() - landis.chatbox.entry:GetTall() - 5 )

		landis.chatbox.entry:SetSize( s.sw, 20 )
		landis.chatbox.entry:SetPos( s.pw, landis.chatbox.frame:GetTall() - landis.chatbox.entry:GetTall() - 5 )
	end	
	
	landis.chatbox.hideBox()
end

--// Hides the chat box but not the messages
function landis.chatbox.hideBox()
	landis.chatbox.isOpen = false

	landis.chatbox.frame.Paint = function() end
	landis.chatbox.chatLog.Paint = function() end
	
	landis.chatbox.chatLog:SetVerticalScrollbarEnabled( false )
	landis.chatbox.chatLog:GotoTextEnd()
	
	landis.chatbox.lastMessage = landis.chatbox.lastMessage or CurTime() - landis.chatbox.config.fadeTime
	
	-- Hide the chatbox except the log
	local children = landis.chatbox.frame:GetChildren()
	for _, pnl in pairs( children ) do
		if pnl == landis.chatbox.frame.btnMaxim or pnl == landis.chatbox.frame.btnClose or pnl == landis.chatbox.frame.btnMinim then continue end
		
		if pnl != landis.chatbox.chatLog then
			pnl:SetVisible( false )
		end
	end
	
	-- Give the player control again
	landis.chatbox.frame:SetMouseInputEnabled( false )
	landis.chatbox.frame:SetKeyboardInputEnabled( false )
	gui.EnableScreenClicker( false )
	
	-- We are done chatting
	gamemode.Call("FinishChat")
	--hook.Run("landisFinishChat")
	
	-- Clear the text entry
	landis.chatbox.entry:SetText( "" )
	gamemode.Call( "ChatTextChanged", "" )
	landis.chatbox.chatLog:SetVisible(true)
	landis.chatbox.chatLog:GetVBar():SetVisible(false)
end

--// Shows the chat box
function landis.chatbox.showBox()
	landis.chatbox.isOpen = true
	-- Draw the chat box again
	landis.chatbox.frame.Paint = landis.chatbox.oldPaint
	landis.chatbox.chatLog.Paint = landis.chatbox.oldPaint2
	
	landis.chatbox.chatLog:SetVerticalScrollbarEnabled( true )
	landis.chatbox.lastMessage = nil
	
	-- Show any hidden children
	local children = landis.chatbox.frame:GetChildren()
	for _, pnl in pairs( children ) do
		if pnl == landis.chatbox.frame.btnMaxim or pnl == landis.chatbox.frame.btnClose or pnl == landis.chatbox.frame.btnMinim then continue end
		
		pnl:SetVisible( true )
	end
	landis.chatbox.chatLog:SetVisible(true)
	-- MakePopup calls the input functions so we don't need to call those
	landis.chatbox.frame:MakePopup()
	landis.chatbox.entry:RequestFocus()

	landis.chatbox.chatLog:GetVBar():SetVisible(true)
	
	-- Make sure other addons know we are chatting
	gamemode.Call("StartChat") -- this runs too much so we are circumventing this with a custom hook
	--hook.Run("landisStartChat")
end

--// Opens the settings panel
function landis.chatbox.openSettings()
	landis.chatbox.hideBox()
	
	landis.chatbox.frameS = vgui.Create("DFrame")
	landis.chatbox.frameS:SetSize( 400, 300 )
	landis.chatbox.frameS:SetTitle("")
	landis.chatbox.frameS:MakePopup()
	landis.chatbox.frameS:SetPos( ScrW()/2 - landis.chatbox.frameS:GetWide()/2, ScrH()/2 - landis.chatbox.frameS:GetTall()/2 )
	landis.chatbox.frameS:ShowCloseButton( true )
	landis.chatbox.frameS.Paint = function( self, w, h )
		landis.chatbox.blur( self, 10, 20, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 80, 80, 80, 100 ) )
		
		draw.RoundedBox( 0, 0, 25, w, 25, Color( 50, 50, 50, 50 ) )
	end
	
	local serverName = vgui.Create("DLabel", landis.chatbox.frameS)
	serverName:SetText( "landis.chatbox - Settings" )
	serverName:SetFont( "landis.chatbox_18")
	serverName:SizeToContents()
	serverName:SetPos( 5, 4 )
	
	local label1 = vgui.Create("DLabel", landis.chatbox.frameS)
	label1:SetText( "Time stamps: " )
	label1:SetFont( "landis.chatbox_18")
	label1:SizeToContents()
	label1:SetPos( 10, 40 )
	
	local checkbox1 = vgui.Create("DCheckBox", landis.chatbox.frameS ) 
	checkbox1:SetPos(label1:GetWide() + 15, 42)
	checkbox1:SetValue( landis.chatbox.config.timeStamps )
	
	local label2 = vgui.Create("DLabel", landis.chatbox.frameS)
	label2:SetText( "Fade time: " )
	label2:SetFont( "landis.chatbox_18")
	label2:SizeToContents()
	label2:SetPos( 10, 70 )
	
	local textEntry = vgui.Create("DTextEntry", landis.chatbox.frameS) 
	textEntry:SetSize( 50, 20 )
	textEntry:SetPos( label2:GetWide() + 15, 70 )
	textEntry:SetText( landis.chatbox.config.fadeTime ) 
	textEntry:SetTextColor( color_white )
	textEntry:SetFont("landis.chatbox_18")
	textEntry:SetDrawBorder( false )
	textEntry:SetDrawBackground( false )
	textEntry:SetCursorColor( color_white )
	textEntry:SetHighlightColor( Color(52, 152, 219) )
	textEntry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end
	
	--[[local checkbox2 = vgui.Create("DCheckBox", landis.chatbox.frameS ) 
	checkbox2:SetPos(label2:GetWide() + 15, 72)
	checkbox2:SetValue( landis.chatbox.config.selandis.chatboxTags )
	
	local label3 = vgui.Create("DLabel", landis.chatbox.frameS)
	label3:SetText( "Use chat tags: " )
	label3:SetFont( "landis.chatbox_18")
	label3:SizeToContents()
	label3:SetPos( 10, 100 )
	
	local checkbox3 = vgui.Create("DCheckBox", landis.chatbox.frameS ) 
	checkbox3:SetPos(label3:GetWide() + 15, 102)
	checkbox3:SetValue( landis.chatbox.config.uslandis.chatboxTag )]]
	
	local save = vgui.Create("DButton", landis.chatbox.frameS)
	save:SetText("Save")
	save:SetFont( "landis.chatbox_18")
	save:SetTextColor( Color( 230, 230, 230, 150 ) )
	save:SetSize( 70, 25 )
	save:SetPos( landis.chatbox.frameS:GetWide()/2 - save:GetWide()/2, landis.chatbox.frameS:GetTall() - save:GetTall() - 10)
	save.Paint = function( self, w, h )
		if self:IsDown() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 80, 80, 80, 200 ) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 50, 50, 50, 200 ) )
		end
	end
	save.DoClick = function( self )
		landis.chatbox.frameS:Close()
		
		landis.chatbox.config.timeStamps = checkbox1:GetChecked() 
		landis.chatbox.config.fadeTime = tonumber(textEntry:GetText()) or landis.chatbox.config.fadeTime
	end
end

--// Panel based blur function by Chessnut from NutScript
local blur = Material( "pp/blurscreen" )
function landis.chatbox.blur( panel, layers, density, alpha )
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
	if not landis.chatbox.chatLog then
		landis.chatbox.buildBox()
	end
	
	local msg = vgui.Create( "chatmessage", landis.chatbox.chatLog )
	

	msg:SetMessage( ... )
	msg:Dock( TOP )
	landis.chatbox.chatLog:AddItem(msg)
	-- Iterate through the strings and colors
	--[[for _, obj in pairs( {...} ) do
		if type(obj) == "table" then
			landis.chatbox.chatLog:InsertColorChange( obj.r, obj.g, obj.b, obj.a )
			table.insert( msg, Color(obj.r, obj.g, obj.b, obj.a) )
		elseif type(obj) == "string"  then
			landis.chatbox.chatLog:AppendText( obj )
			table.insert( msg, obj )
		elseif obj:IsPlayer() then
			local ply = obj
			
			if landis.chatbox.config.timeStamps then
				landis.chatbox.chatLog:InsertColorChange( 130, 130, 130, 255 )
				landis.chatbox.chatLog:AppendText( "["..os.date("%X").."] ")
			end
			
			if landis.chatbox.config.selandis.chatboxTags and ply:GetNWBool("landis.chatbox_tagEnabled", false) then
				local col = ply:GetNWString("landis.chatbox_tagCol", "255 255 255")
				local tbl = string.Explode(" ", col )
				landis.chatbox.chatLog:InsertColorChange( tbl[1], tbl[2], tbl[3], 255 )
				landis.chatbox.chatLog:AppendText( "["..ply:GetNWString("landis.chatbox_tag", "N/A").."] ")
			end
			
			local col = GAMEMODE:GetTeamColor( obj )
			landis.chatbox.chatLog:InsertColorChange( col.r, col.g, col.b, 255 )
			landis.chatbox.chatLog:AppendText( obj:Nick() )
			table.insert( msg, obj:Nick() )
		end
	end]]
	landis.chatbox.lastMessage = CurTime()
	landis.chatbox.chatLog:SetVisible( true )

	--chat.PlaySound()
	timer.Simple(0.05,function()
		landis.chatbox.chatLog:ScrollToChild(msg)
	end)
--	oldAddText(unpack(msg))
end

--// Write any server notifications
hook.Remove( "ChatText", "landis.chatbox_joinleave")
hook.Add( "ChatText", "landis.chatbox_joinleave", function( index, name, text, type )
	if not landis.chatbox.chatLog then
		landis.chatbox.buildBox()
	end
	
	if type != "chat" then
		landis.chatbox.chatLog:InsertColorChange( 0, 128, 255, 255 )
		landis.chatbox.chatLog:AppendText( text.."\n" )
		landis.chatbox.chatLog:SetVisible( true )
		landis.chatbox.lastMessage = CurTime()
		return true
	end
end)

--// Stops the default chat box from being opened
hook.Remove("PlayerBindPress", "landis.chatbox_hijackbind")
hook.Add("PlayerBindPress", "landis.chatbox_hijackbind", function(ply, bind, pressed)
	if string.sub( bind, 1, 11 ) == "messagemode" then
		if pressed then
			net.Start("landisStartChat")
			net.SendToServer()
		end
		if bind == "messagemode2" then 
			landis.chatbox.ChatType = "teamchat"
		else
			landis.chatbox.ChatType = ""
		end
		
		if IsValid( landis.chatbox.frame ) then
			landis.chatbox.showBox()
		else
			landis.chatbox.buildBox()
			landis.chatbox.showBox()
		end
		return true
	end
end)

--// Hide the default chat too in case that pops up
hook.Remove("HUDShouldDraw", "landis.chatbox_hidedefault")
hook.Add("HUDShouldDraw", "landis.chatbox_hidedefault", function( name )
	if name == "CHudChat" then
		return false
	end
end)

 --// Modify the Chatbox for align.
local oldGetChatBoxPos = chat.GetChatBoxPos
function chat.GetChatBoxPos()
	return landis.chatbox.frame:GetPos()
end

function chat.GetChatBoxSize()
	return landis.chatbox.frame:GetSize()
end

chat.Open = landis.chatbox.showBox
function chat.Close(...) 
	if IsValid( landis.chatbox.frame ) then 
		landis.chatbox.hideBox(...)
	else
		landis.chatbox.buildBox()
		landis.chatbox.showBox()
	end
end