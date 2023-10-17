local K, C = unpack(KkthnxUI)

local _G = _G
local table_insert = _G.table.insert

tinsert(C.defaultThemes, function()

	--[[local WorldMapFrame = _G.WorldMapFrame
	
	-- Hide border frame
	WorldMapFrame.BorderFrame:Hide()

	-- Hide dropdown menus
	WorldMapZoneDropDown:Hide()
	WorldMapContinentDropDown:Hide()
	WorldMapZoneMinimapDropDown:Hide()

	-- Hide zoom out button
	WorldMapZoomOutButton:Hide()

	-- Hide right-click to zoom out text
	WorldMapMagnifyingGlassButton:Hide()

	-- Move close button inside scroll container
	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapFrame.ScrollContainer, "TOPRIGHT", -2, 1)
	WorldMapFrameCloseButton:SetSize(34, 34)
	WorldMapFrameCloseButton:SetFrameLevel(10)
	WorldMapFrameCloseButton:SkinCloseButton()

	-- Function to set world map clickable area
	WorldMapFrame:SetHitRectInsets(-20, -20, 38, 0)
	WorldMapFrame:SetClampedToScreen(false)

	-- Create KkthnxUI border around map
	local border = CreateFrame("Frame", nil, WorldMapFrame.ScrollContainer)
	border:SetPoint("TOPLEFT", 6, -6)
	border:SetPoint("BOTTOMRIGHT", -6, 6)
	border:CreateBorder(nil, nil, C["General"].BorderStyle.Value ~= "KkthnxUI_Pixel" and 24 or nil, nil, nil, nil, nil, nil, nil, "", nil, nil, nil, nil, nil, nil, nil, false)]]
end)
