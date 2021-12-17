-- big table
landis.Scene = landis.Scene or {}

-- properties
landis.Scene.IsPlaying = false
landis.Scene.Duration  = nil -- How long the scene is
landis.Scene.Playhead  = nil -- Current time position of the scene
landis.Scene.fromPos   = nil
landis.Scene.fromAng   = nil
landis.Scene.toPos     = nil
landis.Scene.toAng     = nil
landis.Scene.Fading    = false
landis.Scene.Tween     = nil

function landis.PlayScene(self)
  self.IsPlaying = true
  -- faster inheritence?? idk test the performance of this.
  landis.Scene = table.Inherit(landis.Scene,self)
  landis.Scene.IsPlaying = true
  landis.Scene.Fading = false
  landis.Scene.Playhead = 0
  landis.Scene.Tween = tween.new(self.Duration, landis.Scene, {["Playhead"]=self.Duration}, "outInQuad")
  landis.Scene.Tween:set(0)
  hook.Run("CalcView",LocalPlayer(),self.fromPos,self.fromAng)
  LocalPlayer():ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.25,0)
end

hook.Add("CalcView","landisPlayScene",function(ply,origin,angle)
    if not landis.Scene.IsPlaying then return end
    landis.Scene.Tween:update(FrameTime())
    local scene = landis.Scene
    local view = {}
    view.origin = LerpVector(scene.Playhead/scene.Duration,scene.fromPos,scene.toPos)
    view.angles = LerpAngle(scene.Playhead/scene.Duration,scene.fromAng,scene.toAng)
    if scene.Playhead > (scene.Duration - 0.25) and not scene.Fading then
      landis.Scene.Fading = true
      LocalPlayer():ScreenFade(SCREENFADE.IN,Color(0,0,0,255),.25,0)
      timer.Simple(0.25, function()
          landis.Scene.IsPlaying = false
          LocalPlayer():ScreenFade(SCREENFADE.OUT,Color(0,0,0,255),.75,0)
      end)
    end
    return view
end)
