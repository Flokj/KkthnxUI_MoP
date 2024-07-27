local K = KkthnxUI[1]
local Module = K:GetModule("Blizzard")

local function topCenterPosition(self, _, anchor)
	local holder = _G.TopCenterContainerHolder
	if anchor and (anchor ~= holder) then
		self:ClearAllPoints()
		self:SetPoint("CENTER", holder)
	end
end

local function belowMinimapPosition(self, _, anchor)
	local holder = _G.BelowMinimapContainerHolder
	if anchor and (anchor ~= holder) then
		self:ClearAllPoints()
		self:SetPoint("CENTER", holder)
	end
end

-- Reanchor UIWidgets
function Module:CreateUIWidgets()
	local topCenterContainer = _G.UIWidgetTopCenterContainerFrame
	local belowMinimapContainer = _G.UIWidgetBelowMinimapContainerFrame

	local topCenterHolder = CreateFrame("Frame", "TopCenterContainerHolder", UIParent)
	topCenterHolder:SetPoint("TOP", UIParent, "TOP", 0, -40)
	topCenterHolder:SetSize(160, 30)

	local belowMiniMapHolder = CreateFrame("Frame", "BelowMinimapContainerHolder", UIParent)
	belowMiniMapHolder:SetPoint("TOP", UIParent, "TOP", 0, -80)
	belowMiniMapHolder:SetSize(160, 30)

	K.Mover(topCenterHolder, "TopCenterContainer", "TopCenterContainer", {"TOP", UIParent, "TOP", 0, -40}, 160, 30)
	K.Mover(belowMiniMapHolder, "BelowMinimapContainer", "BelowMinimapContainer", {"TOP", UIParent, "TOP", 0, -80}, 160, 30)

	hooksecurefunc(topCenterContainer, "SetPoint", topCenterPosition)
	hooksecurefunc(belowMinimapContainer, "SetPoint", belowMinimapPosition)
end
