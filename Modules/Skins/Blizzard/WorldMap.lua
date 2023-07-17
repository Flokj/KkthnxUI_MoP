local K, C = unpack(KkthnxUI)

local _G = _G
local table_insert = _G.table.insert

tinsert(C.defaultThemes, function()

	local WorldMapFrame = _G.WorldMapFrame
	
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
	border:CreateBorder(nil, nil, C["General"].BorderStyle.Value ~= "KkthnxUI_Pixel" and 24 or nil, nil, nil, nil, nil, nil, nil, "", nil, nil, nil, nil, nil, nil, nil, false)

	--[[C_Timer.After(10, function()
		if Questie_Toggle then
			-- Hide original toggle button
			Questie_Toggle:Hide()

			-- Create our own button
			local QuestButton = CreateFrame("Button", nil, WorldMapFrame)
			QuestButton:SetSize(18, 18)
			QuestButton:SetPoint("TOPRIGHT", -50, -76)
			QuestButton:SetFrameLevel(WorldMapFrameCloseButton:GetFrameLevel())

			QuestButton:SetScript("OnClick", function()
				PlaySound(825)
				Questie_Toggle:Click()
			end)

			QuestButton:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", -1, 5)
				GameTooltip:AddLine("Toggle Questie")
				GameTooltip:Show()
			end)

			QuestButton:SetScript("OnLeave", K.HideTooltip)

			QuestButton:SkinButton()

			QuestButton.Texture = QuestButton.Texture or QuestButton:CreateTexture(nil, "OVERLAY")
			QuestButton.Texture:SetSize(18, 18)
			QuestButton.Texture:SetPoint("CENTER")]]
			--QuestButton.Texture:SetTexture([[Interface\AddOns\Questie\Icons\available]])
		--end
	--end)
end)
