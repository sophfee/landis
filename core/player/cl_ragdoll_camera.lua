local meta = FindMetaTable("Entity")
local hookRunning = false

ragdollCameraTime = 0

function meta:DoRagdollCamera()
	if hookRunning then return end
	if not self:IsPlayer() then return end
	local ragdoll = self:GetRagdollEntity()
	if not IsValid(ragdoll) then return end
	local startPos = self:EyePos()
	ragdollCameraTime = 0
	hookRunning = true
	local ang = self:EyeAngles()
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
		ang = LerpAngle(FrameTime()*1,ang,(ragdoll:GetPos()-startPos):GetNormalized():Angle())
		local camData = {
			origin = startPos, --ragdoll:GetPos() + Vector(0,0,10+(ragdollCameraTime*125)) or Vector(),
			angles = ang,
			fov = math.Clamp(70-(ragdollCameraTime*4),5,70),
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

