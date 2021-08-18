--[[

cinematic sequence camera system inspired by re7's cinematic sequences

]]

landys.interactions = landys.interactions or {}
landys.interactions.registered = landys.interactions.registered or {}

landys.interactions.interactKey = KEY_E

--[[
custom class
------------
used for cine cam sequences
]]
function key( pos, ang, time )
	return { p = pos, a = ang, t = time }
end
--language.Add("interact.test", "cum fart")
local baseStruct = {
	forceFov = nil, -- set to num to force
	camKeyframes = {
		key( Vector(), Angle(), 0 ),
		key( Vector(5,0,5), Angle(), 1.5 )
	},
	time = 3,
	caption = "#interact.test",
	noDraw = false,
	pos    = Vector()
}

function landys.interactions.register( id, data )

	local sequence = {}

	sequence.meta = table.Inherit( data, baseStruct )
	sequence.alpha = 0
	if CLIENT then sequence.seqPos = 0 end 

	-- setup meta
	function sequence:GetPos()
		return self.meta.pos
	end

	if CLIENT then

		function sequence:GetStartKey()
			for v,k in ipairs(self.meta.camKeyframes) do
				if k.t >= self.meta.time then return k,v end
			end
			return self.meta.camKeyframes[1],1
		end

		function sequence:Run()
			self.seqPos = 0
			hook.Add( "CalcView", "SequencePlayer", function( ply, origin, angles, fov, znear, zfar )
				local curkey,index = self:GetStartKey()
				print(self.seqPos)
				if not curkey or self.seqPos > self.meta.time then hook.Remove( "CalcView", "SequencePlayer" ) return end
				self.seqPos = self.seqPos + FrameTime()
				local nextKey = self.meta.camKeyframes[index+1]
				local nexttime = nextKey["t"] or 0
				if not nextKey then
					nexttime = self.meta.time
				end

				local camdata = {
					origin = LerpVector( (curkey.t-self.seqPos)/nexttime, curkey.p+ply:EyePos(), ply:EyePos() ),
					angles = angles,
					fov    = fov,
					znear  = znear,
					zfar   = zfar,
					drawviewer = true
				}
				return camdata, true
			end)
		end

		function sequence:CanSee()
			local pos  = self:GetPos()
			local info = pos:ToScreen()
			local base = info.visible and (((info.x/ScrW()) > 0.2 or (info.x/ScrW()) < 0.8) or ((info.y/ScrH()) > 0.2 or (info.y/ScrH()) < 0.8)) or false
			if base then
				return LocalPlayer():GetPos():Distance( pos ) < 150, info.x, info.y
			end
			return false, info.x, info.y
		end

		function sequence:IncrementVis()
			self.alpha = math.Clamp( self.alpha + ( FrameTime() * 512 ), 0, 255 )
		end

		function sequence:DecrementVis()
			self.alpha = math.Clamp( self.alpha - ( FrameTime() * 512 ), 0, 255 )
		end

		function sequence:Draw()
			if self.noDraw then return end
			--print(self.alpha)
			local canSee, x, y = self:CanSee()
			if canSee then
				self:IncrementVis()
				draw.RoundedBox(0, x-15, y-15, 30, 30, Color( 255, 255, 255, self.alpha ))
			else
				self:DecrementVis()
				draw.RoundedBox(0, x-15, y-15, 30, 30, Color( 255, 255, 255, self.alpha ))
			end
		end

	end
	landys.interactions.registered[id] = sequence

end


if CLIENT then 

	hook.Add( "HUDPaint", "interactionsDraw", function()

		for v,k in pairs( landys.interactions.registered ) do

			k:Draw()

		end

	end)

	hook.Add( "PlayerButtonDown", "landysBaseInteractionTrigger", function( _, btn )

		if btn == KEY_E then

			for v,k in pairs( landys.interactions.registered ) do

				local canSee = k:CanSee()

				if canSee then

					k:Run()

					hook.Run( "InteractionTriggered", v, k )

					break

				end

			end

		end

	end)

	local ply = LocalPlayer()
	landys.interactions.register("test",{
		camKeyframes = {
			key( Vector(10,10,10), Angle(), 0 ),
			key( Vector(-10,-10,10), Angle(), 4.5 ),
			key( Vector(10,18,10), Angle(), 8 )
		},
		time = 10
	})

end