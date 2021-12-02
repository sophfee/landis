--[[

Welcome to the Merchant Vendor class!

]]

local VENDOR = landis.lib.CreateVendorTable()

VENDOR.UniqueID    = "example_merchant"
VENDOR.Behavior    = "merchant"
-- The name that appears at the top when hovering over the entity
VENDOR.DisplayName = "Nick \"the j\" Landis"

-- The whtie text that shows under the top text
VENDOR.Description = "He looks at you and seems to offer something..."

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

VENDOR.Shop = {}
VENDOR.Shop.StockTime = 900 -- 15 minutes
VENDOR.Shop.Buying = {} -- not buying anything
-- to note: there is no item system atm, there will be soon so this just displays text
VENDOR.Shop.Selling = {
	{
		itemname= "test",
		cost    = 15,
		stock   = 2
	}
}


VENDOR.Panel = "merchantbase"

landis.lib.RegisterVendor( VENDOR )