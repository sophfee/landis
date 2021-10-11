ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.DisplayName = "f"
ENT.Description = "fart"
ENT.PrintName = "Vendor Base"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.HeightOffset = -20
ENT.Vendor = "example_vendor"

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"VendorClass")
	self:NetworkVar("Float",1,"VendorSpeakNext")
	self:NetworkVar("String",2,"DisplayName")
	self:NetworkVar("String",3,"Description")

	if SERVER then
		self:SetVendor(self.Vendor)
		self:SetVendorSpeakNext(CurTime()+300)
	end
end
