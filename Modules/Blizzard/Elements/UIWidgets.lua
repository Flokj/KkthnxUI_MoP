local K = KkthnxUI[1]
local Module = K:GetModule("Blizzard")

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local UIParent = UIParent

local function topCenterPosition(self, _, anchor)
	local holder = _G.TopCenterContainerHolder
	if anchor and (anchor ~= holder) then
		self:ClearAllPoints()
		self:SetPoint("CENTER", holder)
		self:SetParent(holder)
	end
end

local function belowMinimapPosition(self, _, anchor)
	local holder = _G.BelowMinimapContainerHolder
	if anchor and (anchor ~= holder) then
		self:ClearAllPoints()
		self:SetPoint("CENTER", holder, "CENTER")
		self:SetParent(holder)
	end
end

-- Reanchor UIWidgets
function Module:CreateUIWidgets()
	local topCenterContainer = _G.UIWidgetTopCenterContainerFrame
	local belowMiniMapcontainer = _G.UIWidgetBelowMinimapContainerFrame

	local topCenterHolder = CreateFrame("Frame", "TopCenterContainerHolder", UIParent)
	topCenterHolder:SetPoint("TOP", UIParent, "TOP", 0, -40)
	topCenterHolder:SetSize(160, 30)

	local belowMiniMapHolder = CreateFrame("Frame", "BelowMinimapContainerHolder", UIParent)
	belowMiniMapHolder:SetPoint("TOP", UIParent, "TOP", 0, -80)
	belowMiniMapHolder:SetSize(160, 30)

	K.Mover(topCenterHolder, "TopCenterContainer", "TopCenterContainer", {"TOP", UIParent, "TOP", 0, -40}, 160, 30)
	K.Mover(belowMiniMapHolder, "BelowMinimapContainer", "BelowMinimapContainer", {"TOP", UIParent, "TOP", 0, -80}, 160, 30)

	topCenterContainer:ClearAllPoints()
	topCenterContainer:SetPoint("CENTER", topCenterHolder)

	belowMiniMapcontainer:ClearAllPoints()
	belowMiniMapcontainer:SetPoint("CENTER", belowMiniMapHolder, "CENTER")

	hooksecurefunc(topCenterContainer, "SetPoint", topCenterPosition)
	hooksecurefunc(belowMiniMapcontainer, "SetPoint", belowMinimapPosition)
end
