--- Used for shops & NPCs.
-- @module Vendor

-- Use as
-- local VENDOR = landis.lib.CreateVendorTable()

landis.Vendor = {}
landis.Vendor.Data = {} -- Registered Vendors

-- Rest of the funcs are added into the lib table

--- Creates a basic structure for a new vendor.
-- See the file itself for each value.
-- @return Vendor Struct
function landis.CreateVendorTable()
	local class = {
		UniqueID = "INVALID_VENDOR_CLASS", -- FUCKING CHANGE THIS DUMBASS 
		Model = {
			Path = "",
			Skin = 0,
			Bodygroup = {}
		},
		DisplayName = "Unset Name!",
		Description = "", -- Leave blank in-case you don't need it, name should be used though.
		Selling = {},
		Buying = {},
		Sound = {
			Idle = {
				Paths = {
					"vo/npc/male01/doingsomething.wav",
					"vo/npc/male01/question23.wav",
					"vo/npc/male01/question29.wav",
					"vo/npc/male01/question06.wav"
				},
				Interval = {
					Minimum = 180,
					Maximum = 600
				},
				Enabled = true
			},
			Greet = {
				Paths = {
					"vo/npc/male01/hi01.wav",
					"vo/npc/male01/hi02.wav"
				},
				Enabled = true
			}
		}
	}
	return class 
end

--- Register a new vendor.
-- Supply a proper Vendor Struct to this and it will allow it to be used
-- @param meta The structure for the vendor. 
function landis.RegisterVendor( meta )

	landis.Vendor.Data[meta.UniqueID] = meta

	local ent = {} -- Create new entity data for this!!!

	ent.Type = "anim"
	ent.Base = "landis_vendor"
	ent.PrintName = meta.DisplayName
	ent.Vendor = meta.UniqueID
end

function landis.GetVendor( class )
	return landis.Vendor.Data[ class ]
end
