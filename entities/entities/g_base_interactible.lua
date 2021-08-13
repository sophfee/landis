ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "gBase Interactible Base"
ENT.Category  = "gBase Ents"
ENT.Spawnable = true -- switch to false post dev
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

function ENT:Initialize()
	self:SetModel("models/props_borealis/bluebarrel001.mdl")
	-- init phys
	if SERVER then

	end 
end

if CLIENT then
	function ENT:Use()
		local a = vgui.Create( "gEntityInteractions" )
		a:SetEntity(self)
	end
end

AddCSLuaFile()