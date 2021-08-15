ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "gBase Interactible Base (dont use)"
ENT.Category  = "gBase Ents"
ENT.Spawnable = true -- switch to false post dev
ENT.AdminOnly = true
ENT.Author    = "nick"
ENT.Contact   = "@nick#3715"
ENT.Purpose   = "A base for interactible entities."

-- should be edited, but this shows all the different functions of the interaction system
ENT.Interactions = {
	{
		name = "Use", -- what the player sees when hovering over it.
		type = "button", -- A button will appear w/ the text drawn over it.
		func = "pickup", -- this will be an item to pickup.
		item = "none", -- name a valid registered item.
		quan = 1
	},
	{
		name = "Info",
		type = "button",
		func = "custom",
		doCustom = function(self,activator)
			print("Wow! I have been pressed!")
		end
	}
}

if SERVER then
	util.AddNetworkString("g_openMenu_entityInteract")

	local meta = FindMetaTable( "Player" )

	function meta:OpenEntityInteraction( ent )
		if !( IsValid( ent ) ) then return end
		if !( self:Alive() ) then return end

		net.Start( "g_openMenu_entityInteract" )
			net.WriteEntity( ent )
		net.Send( self )
	end
end

if CLIENT then

	net.Receive( "g_openMenu_entityInteract", function()
		local ent = net.ReadEntity()

		if IsValid( ent ) then
			local P = vgui.Create( "gEntityInteractions" )
			P:SetSize(400,400)
			P:Center()
			P:SetEntity( ent )
			//P:MakePopup()
		end
	end)

	function ENT:Draw(f)
		self:DrawModel(f)
		cam.Start3D2D( self:LocalToWorld( self:OBBCenter() ), self:GetAngles() + Angle(-180`,-90,-90), 0.07)
			surface.SetDrawColor(255, 255, 255)
			surface.SetTextPos(200, 0)
			surface.DrawText("test")
		cam.End3D2D()
		
	end

end

function ENT:Use( ply )
	if ply:IsPlayer() then ply:OpenEntityInteraction( self ) end
end

function ENT:Initialize()
	self:SetModel("models/props_borealis/bluebarrel001.mdl")
	-- init phys
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

	end 
end

if CLIENT then
	function ENT:Use()
		local a = vgui.Create( "gEntityInteractions" )
		a:SetEntity(self)
	end
end

AddCSLuaFile()