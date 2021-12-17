PANEL = {}

function PANEL:Init()
    local bar = self:GetVBar()

	self.barPaint = bar.Paint
	self.btnUpPaint = bar.btnUp.Paint
	self.btnDownPaint = bar.btnDown.Paint
	self.btnGripPaint = bar.btnGrip.Paint
end

function PANEL:SetScrollbarVisible(display)
    local bar = self:GetVBar()

	if visible == true then
		bar.btnUp.Paint = self.btnUpPaint
		bar.btnDown.Paint = self.btnDownPaint
		bar.btnGrip.Paint = self.btnGripPaint
		bar.Paint = self.barPaint
	else
		bar.btnUp.Paint = function() end
		bar.btnDown.Paint = function() end
		bar.btnGrip.Paint = function() end
		bar.Paint = function() end
	end
end

vgui.Register("landisScroll",PANEL,"DScrollPanel")