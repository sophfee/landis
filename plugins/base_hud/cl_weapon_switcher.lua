-- Made this an entirely separate script due to lots of complexity
local curSlot = 0
local curTab  = 0
local selecting = false
local weps = {}

local slotAlpha = {}
slotAlpha.a = 0

local easingIn = false

local slotTweenIn = tween.new(0.07,slotAlpha,{a=1},"inQuad")
local slotTweenOut = tween.new(0.07,slotAlpha,{a=0},"outQuad")

hook.Add("HUDPaint", "landisDrawWepSelect", function()
	local slots = {}
	if weps[curSlot] and selecting then
		if easingIn then
			slotTweenIn:update(FrameTime())
		else
			slotTweenOut:update(FrameTime())
		end
		local c = table.Copy(landis.Config.MainColor)
		c.a = math.floor(slotAlpha.a *255)
		draw.SimpleText(weps[curSlot]:GetPrintName(), "landis-24-S-B", ScrW()/2+24, ScrH()/2, c,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color( 1, 1, 1, math.floor(slotAlpha.a *255) ))
		draw.DrawText((weps[curSlot].Instructions or "") .. (weps[curSlot].Purpose or ""), "landis-20-S", ScrW()/2+24, ScrH()/2+17, Color( 255, 255, 255, math.floor(slotAlpha.a *255) ))
		if #weps == 1 then return end
		c.a = math.floor(slotAlpha.a *80)
		draw.SimpleText(weps[(curSlot-1) == 0 and #weps or curSlot-1]:GetPrintName(), "landis-18-S", ScrW()/2+24, ScrH()/2-160, c)
		draw.SimpleText(weps[(curSlot+1) == #weps+1 and 1 or curSlot+1]:GetPrintName(), "landis-18-S", ScrW()/2+24, ScrH()/2+160, c)
	end
end)
local function updateTable(slot)
	weps = {}
	for v,k in ipairs(LocalPlayer():GetWeapons()) do
		if k:GetSlot() == slot then
			weps[#weps+1]=k
		end
	end
end
hook.Add("PlayerBindPress", "landisWepSelBind", function(ply,bind,pressed)
	for i=1,6 do
		if (string.sub(bind, 0, 5) == "slot"..i) and pressed then
			slotTweenOut:set(0)
			selecting = true
			easingIn = false
			
			surface.PlaySound("landis/ui/scroll.mp3")
			timer.Simple(0.07, function()
				if not (curTab == i) then
					updateTable(i-1)
					curTab = i
					curSlot = 1
				else
					if curSlot + 1 > #weps then
						curSlot = 1
					else
						curSlot = curSlot + 1
					end
				end
				slotTweenIn:set(0)
				easingIn = true
			end)
			return true
		end
	end
	if (string.sub(bind, 0, 7) == "+attack") then
		if selecting then
			if weps[curSlot] then
				input.SelectWeapon(weps[curSlot])
				surface.PlaySound("landis/ui/click.wav")
			end
			selecting = false
			return true
		end
	end
end)