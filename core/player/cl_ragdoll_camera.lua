local meta = FindMetaTable("Entity")
local hookRunning = false

function meta:DoRagdollCamera()
	if hookRunning then return end
	if not self:IsPlayer() then return end
	local ragdoll = self:GetRagdollEntity()
	if not IsValid(ragdoll) then return end
	hookRunning = true
	hook.Add("CalcView", "ragdoll_camera", function(_,__,__,fov,znear,zfar)
		if not IsValid(ragdoll) then
			hookRunning = false
			hook.Remove("CalcView", "ragdoll_camera") 
			return 
		end
		local eye = ragdoll:LookupAttachment("eyes")
		local data = ragdoll:GetAttachment(eye)
		local camData = {
			origin = data.Pos or Vector(),
			angles = data.Ang or Angle(),
			fov = 120,
			znear = znear,
			zfar = zfar,
			drawviewer = false
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
