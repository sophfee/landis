-- Use as
-- local VENDOR = landis.lib.CreateVendorTable()

landis.Vendor = {}
landis.Vendor.Data = {} -- Registered Vendors

-- Rest of the funcs are added into the lib table

function landis.lib.CreateVendorTable()
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

function landis.lib.RegisterVendor( meta )

	print("uhh")

	landis.Vendor.Data[meta.UniqueID] = meta

	PrintTable(landis.Vendor)

end