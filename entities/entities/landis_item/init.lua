include("shared.lua")
util.AddNetworkString("landisPickupItem")

function ENT:SetItem(class)

    if not landis.items.data[class] then
        landis.Error("Invalid item class!")
    end

    local dat = landis.items.data[class]

    self:SetItemClass(class)
    self:SetModel(dat.Model)
    self:SetNWString("DisplayName",dat.DisplayName)
    self:SetNWString("Description",dat.Description)
    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
end


function ENT:Initialize()
	landis.ConsoleMessage("Created a new item @ " .. tostring(self:GetPos()))
	self:SetModel( Model("models/player/impulse_zelpa/female_02.mdl") )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetItem("wep_mp7")
end

function ENT:Think()
end

function ENT:Use(caller)
	if IsValid(caller) then
		if caller:IsPlayer() then
			if caller:CanPickupItem(self:GetItemClass()) then
				net.Start("landisPickupItem")
					net.WriteEntity(caller)
					net.WriteString(self:GetItemClass())
				net.Broadcast()
				caller.Inventory[#caller.Inventory+1] = landis.items.data[self:GetItemClass()]
				self:Remove()
			end
		end
	end
end
