
util.AddNetworkString("settings-send-to-client")

local settings = {}

for class,data in pairs(settings) do
	Setting(class,data)
end

net.Start("settings-send-to-client")
	net.WriteTable(settings)
net.Broadcast()
