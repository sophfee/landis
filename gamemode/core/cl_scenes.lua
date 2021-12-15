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
landis.Scene.Tween     = nil

function landis.PlayScene(self)
  self.IsPlaying = true
  -- faster inheritence?? idk test the performance of this.
  landis.Scene = table.Inherit(landis.Scene,self)
  landis.Playhead = 0
  landis.Scene.Tween = tween.new(self.Duration, landis.Scene, {"Playhead"=self.Duration}, "outInQuad")
  LocalPlayer():ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.25,0)
end

hook.Add("CalcView","landisPlayScene",function()
    if not landis.Scene.IsPlaying then return end
    landis.Scene.Tween:update(Frametime())
    local scene = landis.Scene
    local view = {}
    view.origin = LerpVector(scene.Playhead/scene.Duration,scene.fromPos,scene.toPos)
    view.angles = LerpAngle(scene.Playhead/scene.Duration,scene.fromAng,scene.toAng)
    return view
end)
