local K, C = KkthnxUI[1], KkthnxUI[2]

local function colourPopout(self)
	self.arrow:SetVertexColor(0, 0.6, 1)
end

local function clearPopout(self)
	self.arrow:SetVertexColor(1, 1, 1)
end

function K:ReskinModelControl()
	for i = 1, 5 do
		local button = select(i, self.ControlFrame:GetChildren())
		if button.NormalTexture then
			button.NormalTexture:SetAlpha(0)
			button.PushedTexture:SetAlpha(0)
		end
	end
end

tinsert(C.defaultThemes, function()
	if not C["Skins"].BlizzardFrames then return end

	PaperDollFrame:StripTextures()

	K.ReskinModelControl(CharacterModelScene)
	CharacterModelScene:DisableDrawLayer("BACKGROUND")
	CharacterModelScene:DisableDrawLayer("BORDER")
	CharacterModelScene:DisableDrawLayer("OVERLAY")

	local expandButton = CharacterFrameExpandButton
	expandButton:ClearAllPoints()
	expandButton:SetScale(1.2)
	expandButton:SetPoint("TOP", CharacterTrinket1Slot, "BOTTOM", 0, -6)
	if expandButton then
		K.ReskinArrow(expandButton, "right")

		hooksecurefunc(CharacterFrame, "Collapse", function()
			expandButton:SetNormalTexture(0)
			expandButton:SetPushedTexture(0)
			expandButton:SetDisabledTexture(0)
			K.SetupArrow(expandButton.__texture, "right")
		end)
		hooksecurefunc(CharacterFrame, "Expand", function()
			expandButton:SetNormalTexture(0)
			expandButton:SetPushedTexture(0)
			expandButton:SetDisabledTexture(0)
			K.SetupArrow(expandButton.__texture, "left")
		end)
	end

	-- [[ Item buttons ]]

	local function UpdateHighlight(self)
		local highlight = self:GetHighlightTexture()
		highlight:SetColorTexture(1, 1, 1, .25)
		highlight:SetAllPoints()
	end

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard", "Ranged",
	}

	for i = 1, #slots do
		local slot = _G["Character" .. slots[i] .. "Slot"]

		slot:StripTextures()
		slot.icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])

		slot.bg = CreateFrame("Frame", nil, slot)
		slot.bg:SetAllPoints(slot.icon)
		slot.bg:SetFrameLevel(slot:GetFrameLevel())
		slot.bg:CreateBorder()

		local popout = slot.popoutButton
		popout:SetNormalTexture(0)
		popout:SetHighlightTexture(0)

		local arrow = popout:CreateTexture(nil, "OVERLAY")
		arrow:SetSize(14, 14)
		if slot.verticalFlyout then
			K.SetupArrow(arrow, "down")
			arrow:SetPoint("TOP", slot, "BOTTOM", 0, 1)
		else
			K.SetupArrow(arrow, "right")
			arrow:SetPoint("LEFT", slot, "RIGHT", -1, 0)
		end
		popout.arrow = arrow

		colourPopout(popout)
		popout:HookScript("OnEnter", clearPopout)
		popout:HookScript("OnLeave", colourPopout)
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
		UpdateHighlight(button)
	end)

	-- [[ Sidebar tabs ]]
	if PaperDollSidebarTabs.DecorRight then
		PaperDollSidebarTabs.DecorRight:Hide()
	end

	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]

		if i == 1 then
			for i = 1, 4 do
				local region = select(i, tab:GetRegions())
				region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
				region.SetTexCoord = K.Noop
			end
		end

		tab.bg = CreateFrame("Frame", nil, tab)
		tab.bg:SetAllPoints(tab.icon)
		tab.bg:SetFrameLevel(tab:GetFrameLevel())
		tab.bg:CreateBorder()
		tab.bg:SetPoint("TOPLEFT", 2, 1)
		tab.bg:SetPoint("BOTTOMRIGHT", 0, 2)

		tab.Icon:SetAllPoints(tab.bg)
		tab.Hider:SetAllPoints(tab.bg)
		tab.Highlight:SetAllPoints(tab.bg)
		tab.Highlight:SetColorTexture(1, 1, 1, 0.25)
		tab.Hider:SetColorTexture(0.3, 0.3, 0.3, 0.4)
		tab.TabBg:SetAlpha(0)
	end

	CharacterStatsPane:StripTextures()

	for i = 1, 7 do
		local category = _G["CharacterStatsPaneCategory"..i]
		if category then
			for i = 1, 4 do
				select(i, category:GetRegions()):SetAlpha(0)
			end
			category.bg = CreateFrame("Frame", nil, category)
			category.bg:SetAllPoints(category)
			category.bg:SetFrameLevel(category:GetFrameLevel())
			category.bg:CreateBorder()
		end
	end

	for category, statInfo in pairs(PAPERDOLL_STATINFO) do
		hooksecurefunc(statInfo, "updateFunc", function(statFrame)
			if statFrame and not statFrame.styled then
				statFrame.Label:SetFontObject(Number11Font)
				statFrame.Value:SetFontObject(Number11Font)

				statFrame.styled = true
			end
		end)
	end

	hooksecurefunc(PaperDollFrame.TitleManagerPane.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if not child.styled then
				child:DisableDrawLayer("BACKGROUND")
				child.Check:SetAtlas("checkmark-minimal")

				child.styled = true
			end
		end
	end)	
end)
