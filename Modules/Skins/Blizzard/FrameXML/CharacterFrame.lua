-- [[
--  KkthnxUI: Character Frame Skin
--  Purpose: Reskins the player character paper doll, equipment slots, and stats pane.
--  Performance: Optimized ScrollBox iteration and global caching.
--  Maintainer: WoW AddOn Forge
-- ]]

local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Skins")

-- Cache Lua Globals
local _G = _G
local ipairs = ipairs
local select = select
local table_insert = table.insert

-- Cache WoW API
local CreateFrame = CreateFrame
local GetInventoryItemLink = GetInventoryItemLink
local InCombatLockdown = InCombatLockdown
local hooksecurefunc = hooksecurefunc

-- Constants
local SLOT_SIZE = 36
local FONT_SIZE_RANK = 13
local FONT_SIZE_ILVL = 18

-- Colors
local WHITE_COLOR = { r = 1, g = 1, b = 1 }
local ORANGE_COLOR = { r = 1, g = 0.5, b = 0 }
local GOLD_BORDER_COLOR = { 255 / 255, 223 / 255, 0 / 255 }
local GREY_QUALITY_R = K.QualityColors[0].r

-- Paths & Atlases
local DRESSING_ROOM_PATH = "Interface\\AddOns\\KkthnxUI\\Media\\Skins\\DressingRoom"
local MARBLE_TEXTURE = "Interface\\FrameGeneral\\UI-Background-Marble"
local LEAVE_ITEM_TEXTURE = "Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent"

-- ----------------------------------------------------------------------------
-- Helper Functions
-- ----------------------------------------------------------------------------
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

local function UpdateIconBorderColor(slot, r, g, b)
	local border = slot.KKUI_Border
	if not border then
		return
	end

	-- Normalize invalid/grey/white colors to pure white for consistent border styling
	if not r or r == GREY_QUALITY_R or (r > 0.99 and g > 0.99 and b > 0.99) then
		border:SetVertexColor(WHITE_COLOR.r, WHITE_COLOR.g, WHITE_COLOR.b)
	else
		border:SetVertexColor(r, g, b)
	end
end

local function ResetIconBorderColor(slot, texture)
	if not texture and slot.KKUI_Border then
		K.SetBorderColor(slot.KKUI_Border)
	end
end

local function ToggleIconBorder(slot, show)
	if not show and slot.KKUI_Border then
		ResetIconBorderColor(slot)
	end
end

local function StyleEquipmentSlot(slotName)
	local slot = _G[slotName]
	if not slot or slot.KKUI_Styled then
		return
	end

	-- Cache slot elements
	local icon = slot.icon
	local iconBorder = slot.IconBorder
	local cooldown = slot.Cooldown or _G[slotName .. "Cooldown"]
	local ignoreTexture = slot.ignoreTexture

	-- Apply Skin
	slot:StripTextures()
	slot:SetSize(SLOT_SIZE, SLOT_SIZE)

	icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])
	icon:SetAllPoints()

	iconBorder:SetAlpha(0)
	slot:CreateBorder()

	cooldown:SetAllPoints()

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

	if ignoreTexture then
		ignoreTexture:SetTexture(LEAVE_ITEM_TEXTURE)
	end

	-- Hook Overrides
	hooksecurefunc("PaperDollItemSlotButton_Update", PaperDollItemSlotButtonUpdate)

	hooksecurefunc(iconBorder, "SetVertexColor", function(_, r, g, b)
		UpdateIconBorderColor(slot, r, g, b)
	end)

	hooksecurefunc(iconBorder, "Hide", function()
		ResetIconBorderColor(slot)
	end)

	hooksecurefunc(iconBorder, "SetShown", function(_, show)
		ToggleIconBorder(slot, show)
	end)

	slot.KKUI_Styled = true
end

local function StyleSidebarTab(tab)
	if not tab then
		return
	end

	if not tab.bg then
		-- Create background frame
		local bg = CreateFrame("Frame", nil, tab)
		bg:SetAllPoints(tab)
		bg:SetFrameLevel(tab:GetFrameLevel())
		bg:CreateBorder(nil, nil, nil, nil, nil, GOLD_BORDER_COLOR)

		-- Adjust existing elements
		if tab.Icon then
			tab.Icon:SetAllPoints(bg)
		end
		if tab.Hider then
			tab.Hider:SetAllPoints(bg)
			tab.Hider:SetColorTexture(0.3, 0.3, 0.3, 0.4)
		end

		if tab.Highlight then
			tab.Highlight:SetPoint("TOPLEFT", bg, "TOPLEFT", 1, -1)
			tab.Highlight:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -1, 1)
			tab.Highlight:SetColorTexture(1, 1, 1, 0.25)
		end

		if tab.TabBg then
			tab.TabBg:SetAlpha(0)
		end

		tab.bg = bg
	end

	if not tab.regionStyled then
		local region = select(1, tab:GetRegions())
		if region and region:GetObjectType() == "Texture" then
			region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
			tab.regionStyled = true
		end
	end
end

local function UpdateSidebarTabs()
	local index = 1
	local tab = _G["PaperDollSidebarTab" .. index]
	while tab do
		StyleSidebarTab(tab)
		index = index + 1
		tab = _G["PaperDollSidebarTab" .. index]
	end
end

local function StyleTitleManagerPaneChild(child)
	if not child.styled then
		child:DisableDrawLayer("BACKGROUND")
		child.styled = true
	end
end

local function HandleTitleManagerScrollBox(scrollBox)
	if scrollBox and scrollBox.ForEachFrame then
		scrollBox:ForEachFrame(StyleTitleManagerPaneChild)
	end
end

-- ----------------------------------------------------------------------------
-- Main Theme Registration
-- ----------------------------------------------------------------------------

table_insert(C.defaultThemes, function()
	if not C["Skins"].BlizzardFrames then
		return
	end
	if CharacterFrame and CharacterFrame.KKUI_Skinned then
		return
	end

	-- Clean up CharacterModelScene
	if CharacterModelScene then
		K.ReskinModelControl(CharacterModelScene)
		CharacterModelScene:DisableDrawLayer("BACKGROUND")
		CharacterModelScene:DisableDrawLayer("BORDER")
		CharacterModelScene:DisableDrawLayer("OVERLAY")
		CharacterModelScene:StripTextures(true)
	end

	local expandButton = CharacterFrameExpandButton
	expandButton:ClearAllPoints()
	expandButton:SetScale(1.2)
	expandButton:SetPoint("TOP", CharacterTrinket1Slot, "BOTTOM", 0, -10)
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

	-- Style Slots
	local equipmentSlots = {
		"CharacterBackSlot",
		"CharacterChestSlot",
		"CharacterFeetSlot",
		"CharacterFinger0Slot",
		"CharacterFinger1Slot",
		"CharacterHandsSlot",
		"CharacterHeadSlot",
		"CharacterLegsSlot",
		"CharacterMainHandSlot",
		"CharacterNeckSlot",
		"CharacterSecondaryHandSlot",
		"CharacterShirtSlot",
		"CharacterShoulderSlot",
		"CharacterTabardSlot",
		"CharacterTrinket0Slot",
		"CharacterTrinket1Slot",
		"CharacterWaistSlot",
		"CharacterWristSlot",
	}

	for _, slotName in ipairs(equipmentSlots) do
		StyleEquipmentSlot(slotName)
	end

	-- Hooks
	if CharacterFrame and not CharacterFrame.KKUI_Hooks then
		-- Character Frame Size & Background Hook
		local playerClassTexture = DRESSING_ROOM_PATH .. K.Class
		hooksecurefunc(CharacterFrame, "UpdateSize", function()
			local inset = CharacterFrame.Inset
			local bg = inset and inset.Bg

			if CharacterFrame.activeSubframe == "PaperDollFrame" then
				if CharacterFrame.Expanded then
					CharacterFrame:SetSize(640, 431)
				else
					CharacterFrame:SetSize(440, 431)
				end
				if inset then
					inset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 432, 4)
				end

				if bg then
					bg:SetTexture(playerClassTexture)
					bg:SetTexCoord(1 / 512, 479 / 512, 46 / 512, 455 / 512)
					bg:SetHorizTile(false)
					bg:SetVertTile(false)
				end

				if CharacterFrame.Background then
					CharacterFrame.Background:Hide()
				end
			else
				if bg then
					bg:SetTexture(MARBLE_TEXTURE)
					bg:SetTexCoord(0, 1, 0, 1)
					bg:SetHorizTile(true)
					bg:SetVertTile(true)
				end

				if CharacterFrame.Background then
					CharacterFrame.Background:Show()
				end
			end
		end)

		-- Sidebar Tabs Hook
		hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", UpdateSidebarTabs)

		-- Title Pane ScrollBox Hook (Optimized)
		if PaperDollFrame.TitleManagerPane and PaperDollFrame.TitleManagerPane.ScrollBox then
			hooksecurefunc(PaperDollFrame.TitleManagerPane.ScrollBox, "Update", HandleTitleManagerScrollBox)
		end

		CharacterFrame.KKUI_Hooks = true
	end

	-- Adjust Positions (Only if not in combat to be safe, though usually safe during loading)
	if not InCombatLockdown() then
		if CharacterFrame.Inset then
			CharacterHeadSlot:SetPoint("TOPLEFT", CharacterFrame.Inset, "TOPLEFT", 6, -6)
			CharacterHandsSlot:SetPoint("TOPRIGHT", CharacterFrame.Inset, "TOPRIGHT", -6, -6)
			CharacterMainHandSlot:SetPoint("BOTTOMLEFT", CharacterFrame.Inset, "BOTTOMLEFT", 176, 5)
			CharacterSecondaryHandSlot:ClearAllPoints()
			CharacterSecondaryHandSlot:SetPoint("BOTTOMRIGHT", CharacterFrame.Inset, "BOTTOMRIGHT", -176, 5)

			CharacterModelScene:SetSize(300, 360)
			CharacterModelScene:ClearAllPoints()
			CharacterModelScene:SetPoint("TOPLEFT", CharacterFrame.Inset, 64, -3)		
		end

		if CharacterLevelText then
			CharacterLevelText:SetFontObject(K.UIFont)
		end
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

	if CharacterFrame then
		CharacterFrame.KKUI_Skinned = true
	end
end)
