AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.IdleSounds = {
	"vo/eli_lab/mo_gowithalyx01.wav",
	"vo/npc/female01/runforyourlife02.wav",
	"vo/npc/female01/runforyourlife01.wav"
}

util.AddNetworkString("landisVendorOpen")
function ENT:SetVendor( class )
	self:SetVendorClass( class )

	local vendorData = landis.Vendor.Data[ class ]
	self:SetNWString( "DisplayName", vendorData.DisplayName )
	self:SetNWString( "Description", vendorData.Description )
end
	
function ENT:Initialize()
	MsgC(Color(10,132,255),"[landis] Created a new vendor @ " .. tostring(self:GetPos()) .. "\n")
	self:SetModel( Model("models/player/impulse_zelpa/female_02.mdl") )
	self:PhysicsInit( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSequence( 2 )
	self:SetUseType( SIMPLE_USE )
end



function ENT:Think()
	if CurTime() > ( self:GetVendorSpeakNext() or 0 ) then
		self:EmitSound( Sound( table.Random( landis.Vendor.Data[ self:GetNWString( "VendorClass", "example_vendor" ) ].Sound.Idle.Paths ) ) )
		self:SetVendorSpeakNext( CurTime() + math.random(180, 360) )
		hook.Run("VendorSpoke",self)
	end 
end

function ENT:Use( caller )

	if IsValid( caller ) then

		if not caller:IsPlayer() then return end

		landis.ConsoleMessage(caller:Nick() .. " has attempted to use Vendor["..self:GetVendorClass().."]")

		hook.Run( "landisOpenVendor", caller, self, self:GetVendorClass() )

	end
	
end

