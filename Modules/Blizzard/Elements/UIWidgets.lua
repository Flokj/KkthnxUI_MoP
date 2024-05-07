local K = KkthnxUI[1]
local Module = K:GetModule("Blizzard")

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local UIParent = UIParent

-- Reanchor UIWidgets
function Module:CreateUIWidgets()
	-- Create a frame to move the UIWidgetFrame to a more desirable location
	local frame = CreateFrame("Frame", "KKUI_WidgetMover", UIParent)
	frame:SetSize(200, 50)
	K.Mover(frame, "UIWidgetFrame", "UIWidgetFrame", { "TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -28 })

	-- Hook the SetPoint method of UIWidgetBelowMinimapContainerFrame to make sure it's always positioned correctly
	hooksecurefunc(UIWidgetBelowMinimapContainerFrame, "SetPoint", function(self, _, parent)
		if parent == "MinimapCluster" or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint("TOPRIGHT", frame)
		end
	end)
end
