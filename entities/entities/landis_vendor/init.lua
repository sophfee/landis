AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.IdleSounds = {
	"vo/eli_lab/mo_gowithalyx01.wav",
	"vo/npc/female01/runforyourlife02.wav",
	"vo/npc/female01/runforyourlife01.wav"
}

util.AddNetworkString("landisVendorOpen")

function ENT:Initialize()
	self:SetModel( Model("models/player/impulse_zelpa/female_02.mdl") )
	self:PhysicsInit( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSequence( 2 )
	self:SetUseType( SIMPLE_USE )
end

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"VendorClass")
	self:NetworkVar("Float",1,"VendorSpeakNext")
	self:NetworkVar("String",2,"DisplayName")
	self:NetworkVar("String",3,"Description")

	if SERVER then
		self:SetVendorClass("example_vendor")
		self:SetVendorSpeakNext(CurTime()+300)
	end
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

		net.Start( "landisVendorOpen" )

			net.WriteEntity( self ) -- Entity Reference
			net.WriteString( self:GetVendorClass() or "example_vendor" ) -- Vendor Class

		net.Send( caller )

		hook.Run( "OpenVendor", caller, self, self:GetVendorClass() )

	end
	
end

function ENT:SetVendor( class )
	self:SetVendorClass( class )

	local vendorData = landis.Vendor.Data[ class ]
	self:SetNWString( "DisplayName", vendorData.DisplayName )
	self:SetNWString( "Description", vendorData.Description )
end
	