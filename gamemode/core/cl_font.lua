for i=8,256 do
	surface.CreateFont("landis-"..i, {
		font = "Segoe UI Light",
		size = i,
		weight = 3000,
		antialias = true
	})
end

for i=8,256 do
	surface.CreateFont("landis-"..i.."-S", {
		font = "Segoe UI Light",
		size = i,
		weight = 3000,
		antialias = true,
		shadow = true
	})
end

for i=8,256 do
	surface.CreateFont("landis-"..i.."-B", {
		font = "Segoe UI",
		size = i,
		weight = 3000,
		antialias = true,
		shadow = false
	})
end

for i=8,256 do
	surface.CreateFont("landis-"..i.."-S-B", {
		font = "Segoe UI",
		size = i,
		weight = 3000,
		antialias = true,
		shadow = true
	})
end