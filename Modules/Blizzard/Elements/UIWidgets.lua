local K = KkthnxUI[1]
local Module = K:GetModule("Blizzard")

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local UIParent = UIParent

local function topCenterPosition(self, _, b)
	local holder = TopCenterContainerHolder
	if b and (b ~= holder) then
		self:ClearAllPoints()
		self:SetPoint("CENTER", holder)
		self:SetParent(holder)
	end
end

local function belowMinimapPosition(self, _, b)
	local holder = BelowMinimapContainerHolder
	if b and (b ~= holder) then
		self:ClearAllPoints()
		self:SetPoint("CENTER", holder, "CENTER")
		self:SetParent(holder)
	end
end

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
