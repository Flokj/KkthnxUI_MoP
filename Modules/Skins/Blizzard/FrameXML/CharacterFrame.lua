local K, C = KkthnxUI[1], KkthnxUI[2]

local _G = _G
local next = next
local hooksecurefunc = hooksecurefunc

local GetInventoryItemQuality = GetInventoryItemQuality
local GetItemQualityColor = C_Item.GetItemQualityColor

local function replaceBlueColor(bar, r, g, b)
	if r == 0 and g == 0 and b > 0.99 then
		bar:SetStatusBarColor(0, 0.6, 1, 0.5)
	end
end

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

local function PaperDollItemSlotButtonUpdate(frame)
	if not frame.KKUI_Border or not frame.KKUI_Border.SetVertexColor then
		return
	end

	local id = frame:GetID()
	local rarity = id and GetInventoryItemQuality("player", id)
	if rarity and rarity > 1 then
		local r, g, b = GetItemQualityColor(rarity)
		frame.KKUI_Border:SetVertexColor(r, g, b)
		if frame.KKUI_SlotHighlight then
			frame.KKUI_SlotHighlight:SetBackdropBorderColor(r, g, b)
			frame.KKUI_SlotHighlight:Show()
		end
	else
		frame.KKUI_Border:SetVertexColor(1, 1, 1)
		if frame.KKUI_SlotHighlight then
			frame.KKUI_SlotHighlight:Hide()
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
	expandButton:SetPoint("TOP", CharacterTrinket1Slot, "BOTTOM", 10, -5)
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

	for _, slot in next, { _G.PaperDollItemsFrame:GetChildren() } do
		if slot:IsObjectType("Button") and slot.Count then
			local name = slot:GetName()
			local icon = _G[name .. "IconTexture"]

			slot:StripTextures()
			slot:CreateBorder()
			slot:StyleButton()

			if not slot.KKUI_SlotHighlight then
				slot.KKUI_SlotHighlight = CreateFrame("Frame", nil, slot, "BackdropTemplate")
				slot.KKUI_SlotHighlight:SetBackdrop({ edgeFile = C["Media"].Borders.GlowBorder, edgeSize = 8 })
				slot.KKUI_SlotHighlight:SetPoint("TOPLEFT", slot, -4, 4)
				slot.KKUI_SlotHighlight:SetPoint("BOTTOMRIGHT", slot, 4, -4)
				slot.KKUI_SlotHighlight:Hide()
			end

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

			icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])
			icon:SetAllPoints()
		end
	end

	local CharacterHeadSlot = _G.CharacterHeadSlot
	CharacterHeadSlot:ClearAllPoints()
	CharacterHeadSlot:SetPoint('TOPLEFT', _G.PaperDollItemsFrame, 'TOPLEFT', 16, -70)

	local CharacterHandsSlot = _G.CharacterHandsSlot
	CharacterHandsSlot:ClearAllPoints()
	CharacterHandsSlot:SetPoint('LEFT', _G.CharacterHeadSlot, 'RIGHT', 230, 0)

	hooksecurefunc("PaperDollItemSlotButton_Update", PaperDollItemSlotButtonUpdate)

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

	-- Update the appearance of faction reputation bars
	local function UpdateFactionSkins()
		for i = 1, GetNumFactions() do
			local bar = _G["ReputationBar"..i.."ReputationBar"]

			if bar and not bar.styled then
				bar:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
				bar:GetStatusBarTexture():SetDrawLayer("BORDER")

				bar.styled = true
			end
		end
	end

	ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
	ReputationFrame:HookScript("OnEvent", UpdateFactionSkins)

	-- Update the appearance of the skill detail status bar
	SkillDetailStatusBar:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
	hooksecurefunc(SkillDetailStatusBar, "SetStatusBarColor", replaceBlueColor)
	SkillDetailStatusBar:GetStatusBarTexture():SetDrawLayer("BORDER")

	-- Update the appearance of individual skill rank frames
	for i = 1, 12 do
		local name = "SkillRankFrame" .. i
		local bar = _G[name]

		-- Apply custom texture and set the draw layer
		bar:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
		hooksecurefunc(bar, "SetStatusBarColor", replaceBlueColor)
		bar:GetStatusBarTexture():SetDrawLayer("BORDER")
	end
end)
