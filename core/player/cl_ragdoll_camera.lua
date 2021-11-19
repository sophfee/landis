local meta = FindMetaTable("Entity")
local hookRunning = false

ragdollCameraTime = 0

function meta:DoRagdollCamera()
	if hookRunning then return end
	if not self:IsPlayer() then return end
	local ragdoll = self:GetRagdollEntity()
	if not IsValid(ragdoll) then return end
	ragdollCameraTime = 0
	hookRunning = true
	surface.PlaySound(Sound("ui/critical_event_1.wav"))
	hook.Add("CalcView", "ragdoll_camera", function(_,origin,__,fov,znear,zfar)
		if not IsValid(ragdoll) then
			hookRunning = false
			hook.Remove("CalcView", "ragdoll_camera") 
			return 
		end
		ragdollCameraTime = ragdollCameraTime + FrameTime()
		local eye = ragdoll:LookupAttachment("eyes")
		local data = ragdoll:GetAttachment(eye)
		local camData = {
			origin = ragdoll:GetPos() + Vector(0,0,10+(ragdollCameraTime*125)) or Vector(),
			angles = Angle(90,(ragdollCameraTime*90),0),
			fov = 70+(ragdollCameraTime*5),
			znear = znear,
			zfar = zfar,
			drawviewer = true
		}
		
		return camData
	end)
end
local ply = LocalPlayer()
hook.Add("Think", "startcam",function()
	if not IsValid(ply) then ply = LocalPlayer() return end
	if not ply:Alive() then
		if not hookRunning then
			ply:DoRagdollCamera()
		end
	else
		hook.Remove("CalcView","ragdoll_camera")
	end
end)

