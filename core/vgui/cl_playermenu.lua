-- The hub for most things a player will need.

local PANEL = {}

local pWidth = LOW_RES and 400 or 600
local pHeight = LOW_RES and 320 or 500

function PANEL:Init()
	self:SetTitle("player menu")
	self:SetBackgroundBlur(true)
	self:SetSize(pWidth,pHeight)
	self:Center()
	self:SetDraggable(false)
	self:MakePopup()

	self.EconTabButton = vgui.Create("DButton", self)
	self.EconTabButton:SetPos(15,40)
	self.EconTabButton:SetSize(100,30)
	self.EconTabButton:SetText("Economy")
	self.EconTabButton:SetIcon("icon16/coins.png")

	
	self.EconTab = vgui.Create("DFrame", self)
	self.EconTab:SetPos(130,40)
	self.EconTab:SetTitle("Economy")
	self.EconTab:SetSize(pWidth-145,pHeight-65)
	self.EconTab:SetDraggable(false)
	self.EconTab:ShowCloseButton(false)
	self.TeamPanels = {}
	self.TeamTabButton = vgui.Create("DButton", self)
	self.TeamTabButton:SetPos(15,75)
	self.TeamTabButton:SetSize(100,30)
	self.TeamTabButton:SetText("Teams")
	self.TeamTabButton:SetIcon("icon16/group.png")

	self.TeamTab = vgui.Create("DFrame", self)
	self.TeamTab:SetPos(130,40)
	self.TeamTab:SetTitle("Teams")
	self.TeamTab:SetSize(pWidth-145,pHeight-65)
	self.TeamTab:SetDraggable(false)
	self.TeamTab:ShowCloseButton(false)
	

	local teamPanel = vgui.Create("DScrollPanel", self.TeamTab)
	teamPanel:Dock(FILL)
	--self.TeamPanels.teamPanel.Paint = function() end
	
	for v,k in ipairs(landis.Teams.Data) do
		local a = vgui.Create("landisTeam", self.TeamTab)
		a:SetTeam(v)
		teamPanel:AddItem(a)
		a:Dock(TOP)
	end 

	self.TeamTab:SetVisible(false)

	self.HelpTabButton = vgui.Create("DButton", self)
	self.HelpTabButton:SetPos(15,110)
	self.HelpTabButton:SetSize(100,30)
	self.HelpTabButton:SetText("Help")
	self.HelpTabButton:SetIcon("icon16/information.png")

	self.HelpTab = vgui.Create("DFrame", self)
	self.HelpTab:SetPos(130,40)
	self.HelpTab:SetTitle("Help & Information")
	self.HelpTab:SetSize(pWidth-145,pHeight-65)
	self.HelpTab:SetDraggable(false)
	self.HelpTab:ShowCloseButton(false)
	self.HelpTab:SetVisible(false)

	self.EconTabButton.DoClick = function()
		self.EconTab:SetVisible(true)
		self.TeamTab:SetVisible(false)
		
		self.HelpTab:SetVisible(false)
	end

	self.TeamTabButton.DoClick = function()
		self.EconTab:SetVisible(false)
		self.TeamTab:SetVisible(true)
		self.HelpTab:SetVisible(false)
	end

	self.HelpTabButton.DoClick = function()
		self.EconTab:SetVisible(false)
		self.TeamTab:SetVisible(false)
		self.HelpTab:SetVisible(true)
	end

end

function PANEL:OnClose()
	PLAYER_MENU = nil
end
vgui.Register("landisPlayerMenu", PANEL, "DFrame")
PLAYER_MENU = PLAYER_MENU or nil

hook.Add("PlayerButtonDown", "landisPlayerMenuOpen", function(_,btn)
	if btn == KEY_F4 then
		PLAYER_MENU = PLAYER_MENU or vgui.Create("landisPlayerMenu")
	end
end)

concommand.Add("landis_debug_fix_playermenu", function()
	PLAYER_MENU = nil
end)

