landis.TaskBar = nil -- Prevent multiple bars existing at once.
function landis.MakeBar(Name, Time, Callback)
  Name = Name or ""
  Time = Time or 3
  if not landis.TaskBar then
    landis.TaskBar = landis.TaskBar or vgui.Create("landisBar",nil,"landisActiveProgressBar")
    landis.TaskBar:SetupBar(Name,Time)
    if Callback then
      landis.TaskBar:SetCallback(Callback)
    end
  end
end
