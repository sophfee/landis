--[[

Welcome to the Example Vendor class!

]]

print("huh")
local VENDOR = landis.lib.CreateVendorTable()

VENDOR.UniqueID    = "example_vendor"

-- The name that appears at the top when hovering over the entity
VENDOR.DisplayName = "Example Vendor"

-- The whtie text that shows under the top text
VENDOR.Description = "This is an example for the Vendor system."

-- The model that you want to use's path
VENDOR.Model.Path  = "models/player/impulse_zelpa/male_09.mdl"

-- The Selected skin for the model
VENDOR.Model.Skin  = 6

-- Table for each bodygroup you want to use.
VENDOR.Model.Bodygroup[1] = 12
VENDOR.Model.Bodygroup[2] = 5
VENDOR.Model.Bodygroup[3] = 2
VENDOR.Model.Bodygroup[4] = 1
VENDOR.Model.Bodygroup[5] = 1

landis.lib.RegisterVendor( VENDOR )