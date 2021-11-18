for i=8,64 do
	surface.CreateFont("landis-"..i, {
		font = "Arial",
		size = i,
		weight = 500,
		antialias = true
	})
end

for i=8,64 do
	surface.CreateFont("landis-"..i.."-S", {
		font = "Arial",
		size = i,
		weight = 1000,
		antialias = true,
		shadow = true
	})
end

for i=8,64 do
	surface.CreateFont("landis-"..i.."-B", {
		font = "Arial",
		size = i,
		weight = 3000,
		antialias = true,
		shadow = false
	})
end

for i=8,64 do
	surface.CreateFont("landis-"..i.."-S-B", {
		font = "Arial",
		size = i,
		weight = 1000,
		antialias = true,
		shadow = true
	})
end