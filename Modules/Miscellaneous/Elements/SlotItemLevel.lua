local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Miscellaneous")

-- Basic Lua functions
local pairs = pairs
local select = select
local next = next
local wipe = wipe

-- Unit and item information functions
local UnitGUID = UnitGUID
local GetItemInfo = GetItemInfo
local GetContainerItemLink = C_Container.GetContainerItemLink
local GetInventoryItemLink = GetInventoryItemLink
local GetTradePlayerItemLink = GetTradePlayerItemLink
local GetTradeTargetItemLink = GetTradeTargetItemLink

local inspectSlots = {
	"Head",
	"Neck",
	"Shoulder",
	"Shirt",
	"Chest",
	"Waist",
	"Legs",
	"Feet",
	"Wrist",
	"Hands",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand",
	"SecondaryHand",
	"Ranged",
}

function Module:GetSlotAnchor(index)
	if not index then return end

	if index <= 5 or index == 9 or index == 15 then
		return "BOTTOMLEFT", 40, 20
	elseif index == 16 then
		return "BOTTOMRIGHT", -40, 2
	elseif index == 17 then
		return "BOTTOMLEFT", 40, 2
	else
		return "BOTTOMRIGHT", -40, 20
	end
end

function Module:CreateItemTexture(slot, relF, x, y)
	local icon = slot:CreateTexture()
	icon:SetPoint(relF, x, y)
	icon:SetSize(14, 14)
	icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])

	icon.bg = CreateFrame("Frame", nil, slot)
	icon.bg:SetAllPoints(icon)
	icon.bg:SetFrameLevel(3)
	icon.bg:CreateBorder()
	icon.bg:Hide()

	return icon
end

function Module:CreateColorBorder()
	local frame = CreateFrame("Frame", nil, self)
	frame:SetAllPoints()

	self.colorBG = CreateFrame("Frame", nil, frame)
	self.colorBG:StripTextures(4)
	self.colorBG:SetFrameLevel(3)
	self.colorBG:CreateBorder()
end

function Module:CreateItemString(frame, strType)
	if frame.fontCreated then return end

	for index, slot in pairs(inspectSlots) do
		--if index ~= 4 then	-- need color border for some shirts
		local slotFrame = _G[strType .. slot .. "Slot"]
		slotFrame.iLvlText = K.CreateFontString(slotFrame, 12, "", "OUTLINE", false, "BOTTOMLEFT", 2, 2)
		slotFrame.iLvlText:ClearAllPoints()
		slotFrame.iLvlText:SetPoint("BOTTOMLEFT", slotFrame, 1, 1)
		
		local relF, x = Module:GetSlotAnchor(index)
		slotFrame.enchantText = K.CreateFontString(slotFrame, 12, "", "OUTLINE")
		slotFrame.enchantText:ClearAllPoints()
		slotFrame.enchantText:SetPoint("TOPRIGHT", slotFrame, 1, 1)
		slotFrame.enchantText:SetTextColor(0, 1, 0)
		for i = 1, 5 do
			local offset = (i - 1) * 20 + 5
			local iconX = x > 0 and x + offset or x - offset
			local iconY = index > 15 and 20 or 2
			slotFrame["textureIcon" .. i] = Module:CreateItemTexture(slotFrame, relF, iconX, iconY)
		end
		Module.CreateColorBorder(slotFrame)
		--end
	end

	frame.fontCreated = true
end

function Module:ItemBorderSetColor(slotFrame, r, g, b)
	if slotFrame.colorBG then
		slotFrame.colorBG.KKUI_Border:SetVertexColor(r, g, b)
	end
	if slotFrame.bg then
		slotFrame.bg.KKUI_Border:SetVertexColor(r, g, b)
	end
end

local pending = {}

local gemSlotBlackList = {
	[16] = true,
	[17] = true,
	[18] = true, -- ignore weapons, until I find a better way
}
function Module:ItemLevel_UpdateGemInfo(link, unit, index, slotFrame)
	if C["Misc"].GemEnchantInfo then
		local info = K.GetItemLevel(link, unit, index, true)
		if info then
			if not gemSlotBlackList[index] then
				local gemStep = 1
				for i = 1, 5 do
					local texture = slotFrame["textureIcon" .. i]
					local bg = texture.bg
					local gem = info.gems and info.gems[gemStep]
					if gem then
						texture:SetTexture(gem)
						bg.KKUI_Border:SetVertexColor(1, 1, 1)
						bg:Show()

						gemStep = gemStep + 1
					end
				end
			end

			local enchant = info.enchantText
			if enchant then
				slotFrame.enchantText:SetText(enchant)
			end
		end
	end
end

function Module:RefreshButtonInfo()
	local unit = InspectFrame and InspectFrame.unit
	if unit then
		for index, slotFrame in pairs(pending) do
			local link = GetInventoryItemLink(unit, index)
			if link then
				local quality, level = select(3, GetItemInfo(link))
				if quality then
					local color = K.QualityColors[quality]
					Module:ItemBorderSetColor(slotFrame, color.r, color.g, color.b)
					if C["Misc"].ItemLevel and level and level > 1 and quality > 1 then
						slotFrame.iLvlText:SetText(level)
						slotFrame.iLvlText:SetTextColor(color.r, color.g, color.b)
					end
					Module:ItemLevel_UpdateGemInfo(link, unit, index, slotFrame)
					Module:UpdateInspectILvl()

					pending[index] = nil
				end
			end
		end

		if not next(pending) then
			self:Hide()
			return
		end
	else
		wipe(pending)
		self:Hide()
	end
end

function Module:ItemLevel_SetupLevel(frame, strType, unit)
	if not UnitExists(unit) then return end

	Module:CreateItemString(frame, strType)

	for index, slot in pairs(inspectSlots) do
		--if index ~= 4 then
		local slotFrame = _G[strType .. slot .. "Slot"]
		slotFrame.iLvlText:SetText("")
		slotFrame.enchantText:SetText("")
		for i = 1, 5 do
			local texture = slotFrame["textureIcon" .. i]
			texture:SetTexture(nil)
			texture.bg:Hide()
		end
		Module:ItemBorderSetColor(slotFrame, 1, 1, 1)

		local itemTexture = GetInventoryItemTexture(unit, index)
		if itemTexture then
			local link = GetInventoryItemLink(unit, index)
			if link then
				local quality, level = select(3, GetItemInfo(link))
				if quality then
					local color = K.QualityColors[quality]
					Module:ItemBorderSetColor(slotFrame, color.r, color.g, color.b)
					if C["Misc"].ItemLevel and level and level > 1 and quality > 1 then
						slotFrame.iLvlText:SetText(level)
						slotFrame.iLvlText:SetTextColor(color.r, color.g, color.b)
					end

					Module:ItemLevel_UpdateGemInfo(link, unit, index, slotFrame)
				else
					pending[index] = slotFrame
					Module.QualityUpdater:Show()
				end
			else
				pending[index] = slotFrame
				Module.QualityUpdater:Show()
			end
		end
		--end
	end
end

local function GetItemSlotLevel(unit, index)
	local level
	local itemLink = GetInventoryItemLink(unit, index)
	if itemLink then
		level = select(4, GetItemInfo(itemLink))
	end
	return tonumber(level) or 0
end

-- P1 174,187,200,213
-- P2 200,213,226,239
-- P3 200,226,239,252
-- P4 200,246,259,272
local function GetILvlTextColor(level)
	if level >= 272 then
		return 1, .5, 0
	elseif level >= 259 then
		return .63, .2, .93
	elseif level >= 246 then
		return 0, .43, .87
	elseif level >= 226 then
		return .12, 1, 0
	else
		return 1, 1, 1
	end
end

function Module:UpdateUnitILvl(unit, text)
	if not text then return end

	local total = 0
	local level
	for index = 1, 15 do
		if index ~= 4 then
			level = GetItemSlotLevel(unit, index)
			if level > 0 then
				total = total + level
			end
		end
	end

	local mainhand = GetItemSlotLevel(unit, 16)
	local offhand = GetItemSlotLevel(unit, 17)
	local ranged = GetItemSlotLevel(unit, 18)

	--[[
 		Note: We have to unify iLvl with others who use MerInspect,
		 although it seems incorrect for Hunter with two melee weapons.
	]]
	if mainhand > 0 and offhand > 0 then
		total = total + mainhand + offhand
	elseif offhand > 0 and ranged > 0 then
		total = total + offhand + ranged
	else
		total = total + max(mainhand, offhand, ranged) * 2
	end

	local average = K.Round(total / 16, 1)
	text:SetText(average)
	text:SetTextColor(GetILvlTextColor(average))
end

function Module:ItemLevel_UpdatePlayer()
	Module:ItemLevel_SetupLevel(CharacterFrame, "Character", "player")
end

function Module:UpdateInspectILvl()
	if not Module.InspectILvl then return end

	Module:UpdateUnitILvl(InspectFrame.unit, Module.InspectILvl)
	Module.InspectILvl:SetFormattedText("iLvl %s", Module.InspectILvl:GetText())
end

local anchored
local function AnchorInspectRotate()
	if anchored then return end
	InspectModelFrameRotateRightButton:ClearAllPoints()
	InspectModelFrameRotateRightButton:SetPoint("BOTTOMLEFT", InspectFrameTab1, "TOPLEFT", 0, 2)

	Module.InspectILvl = K.CreateFontString(InspectPaperDollFrame, 12, "", "")
	Module.InspectILvl:ClearAllPoints()
	Module.InspectILvl:SetPoint("TOP", InspectLevelText, "BOTTOM", 0, -8)

	anchored = true
end

function Module:ItemLevel_UpdateInspect(...)
	local guid = ...
	if InspectFrame and InspectFrame.unit and UnitGUID(InspectFrame.unit) == guid then
		AnchorInspectRotate()
		Module:ItemLevel_SetupLevel(InspectFrame, "Inspect", InspectFrame.unit)
		Module:UpdateInspectILvl()
	end
end

local function GetItemQualityAndLevel(link)
	local _, _, quality, level, _, _, _, _, _, _, _, classID = GetItemInfo(link)
	if quality and quality > 1 and level and level > 1 and K.iLvlClassIDs[classID] then
		return quality, level
	end
end

function Module:ItemLevel_UpdateMerchant(link)
	if not self.iLvl then
		self.iLvl = K.CreateFontString(_G[self:GetName() .. "ItemButton"], 12, "", "OUTLINE", false, "BOTTOMLEFT", 2, 2)
	end
	self.iLvl:SetText("")
	if link then
		local quality, level = GetItemQualityAndLevel(link)
		if quality and level then
			local color = K.QualityColors[quality]
			self.iLvl:SetText(level)
			self.iLvl:SetTextColor(color.r, color.g, color.b)
		end
	end
end

function Module.ItemLevel_UpdateTradePlayer(index)
	local button = _G["TradePlayerItem" .. index]
	local link = GetTradePlayerItemLink(index)
	Module.ItemLevel_UpdateMerchant(button, link)
end

function Module.ItemLevel_UpdateTradeTarget(index)
	local button = _G["TradeRecipientItem" .. index]
	local link = GetTradeTargetItemLink(index)
	Module.ItemLevel_UpdateMerchant(button, link)
end

local itemCache = {}
local CHAT = K:GetModule("Chat")

function Module.ItemLevel_ReplaceItemLink(link, name)
	if not link then return end

	local modLink = itemCache[link]
	if not modLink then
		local itemLevel = select(4, GetItemInfo(link))
		if itemLevel then
			modLink = gsub(link, "|h%[(.-)%]|h", "|h("..itemLevel..CHAT.IsItemHasGem(link)..")"..name.."|h")
			itemCache[link] = modLink
		end
	end
	return modLink
end

function Module:GuildNewsButtonOnClick(btn)
	if self.isEvent or not self.playerName then return end
	if btn == "LeftButton" and IsShiftKeyDown() then
		if MailFrame:IsShown() then
			MailFrameTab_OnClick(nil, 2)
			SendMailNameEditBox:SetText(self.playerName)
			SendMailNameEditBox:HighlightText()
		else
			local editBox = ChatEdit_ChooseBoxForSend()
			local hasText = (editBox:GetText() ~= "")
			ChatEdit_ActivateChat(editBox)
			editBox:Insert(self.playerName)
			if not hasText then editBox:HighlightText() end
		end
	end
end

function Module:ItemLevel_ReplaceGuildNews(_, _, playerName)
	self.playerName = playerName

	local newText = gsub(self.text:GetText(), "(|Hitem:%d+:.-|h%[(.-)%]|h)", Module.ItemLevel_ReplaceItemLink)
	if newText then
		self.text:SetText(newText)
	end

	if not self.hooked then
		self.text:SetFontObject(Game13Font)
		self:HookScript("OnClick", Module.GuildNewsButtonOnClick) -- copy name by key shift
		self.hooked = true
	end
end

function Module:ItemLevel_FlyoutUpdate(bag, slot, quality)
	if not self.iLvl then
		self.iLvl = K.CreateFontString(self, 12, "", "OUTLINE", false, "BOTTOMLEFT", 2, 2)
	end

	if quality and quality <= 1 then return end

	local link
	if bag then
		link = GetContainerItemLink(bag, slot)
	else
		link = GetInventoryItemLink("player", slot)
	end
	local quality, level = select(3, GetItemInfo(link))

	local color = K.QualityColors[quality or 0]
	self.iLvl:SetText(level)
	self.iLvl:SetTextColor(color.r, color.g, color.b)
	Module:ItemBorderSetColor(self, color.r, color.g, color.b)
end

function Module:ItemLevel_FlyoutUpdateByID(id)
	if not self.iLvl then
		self.iLvl = K.CreateFontString(self, 12, "", "OUTLINE", false, "BOTTOMLEFT", 2, 2)
	end

	local quality, level = select(3, GetItemInfo(id))
	if quality and quality <= 1 then return end

	local color = K.QualityColors[quality or 0]
	self.iLvl:SetText(level)
	self.iLvl:SetTextColor(color.r, color.g, color.b)
	Module:ItemBorderSetColor(self, color.r, color.g, color.b)
end

function Module:ItemLevel_FlyoutSetup()
	if self.iLvl then self.iLvl:SetText("") end

	local location = self.location
	if not location then return end

	if tonumber(location) then
		if location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then return end

		local _, _, bags, slot, bag = EquipmentManager_UnpackLocation(location)
		local itemLocation = self:GetItemLocation()

		local quality = itemLocation and C_Item.GetItemQuality(itemLocation)
		if bags then
			Module.ItemLevel_FlyoutUpdate(self, bag, slot, quality)
		else
			Module.ItemLevel_FlyoutUpdate(self, nil, slot, quality)
		end
	else
		local itemLocation = self:GetItemLocation()
		local quality = itemLocation and C_Item.GetItemQuality(itemLocation)
		if itemLocation:IsBagAndSlot() then
			local bag, slot = itemLocation:GetBagAndSlot()
			Module.ItemLevel_FlyoutUpdate(self, bag, slot, quality)
		elseif itemLocation:IsEquipmentSlot() then
			local slot = itemLocation:GetEquipmentSlot()
			Module.ItemLevel_FlyoutUpdate(self, nil, slot, quality)
		end
	end
end

function Module:CreateSlotItemLevel()
	if not C["Misc"].ItemLevel then return end

	-- iLvl on CharacterFrame
	CharacterFrame:HookScript("OnShow", Module.ItemLevel_UpdatePlayer)
	K:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", Module.ItemLevel_UpdatePlayer)

	hooksecurefunc("PaperDollFrame_SetItemLevel", function(statFrame, unit)
		if unit ~= "player" then return end

		local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel()
		avgItemLevel = format("%.1f", avgItemLevel)
		avgItemLevelEquipped = format("%.1f", avgItemLevelEquipped)

		local text = _G[statFrame:GetName().."StatText"]
		if text then
			text:SetText(avgItemLevelEquipped.."/"..avgItemLevel)
		end
	end)

	-- iLvl on InspectFrame
	K:RegisterEvent("INSPECT_READY", Module.ItemLevel_UpdateInspect)

	-- iLvl on FlyoutButtons
	hooksecurefunc("EquipmentFlyout_UpdateItems", function()
		for _, button in pairs(EquipmentFlyoutFrame.buttons) do
			if button:IsShown() then
				Module.ItemLevel_FlyoutSetup(button)
			end
		end
	end)

	-- Update item quality
	Module.QualityUpdater = CreateFrame("Frame")
	Module.QualityUpdater:Hide()
	Module.QualityUpdater:SetScript("OnUpdate", Module.RefreshButtonInfo)

	-- iLvl on MerchantFrame
	hooksecurefunc("MerchantFrameItem_UpdateQuality", Module.ItemLevel_UpdateMerchant)

	-- iLvl on TradeFrame
	hooksecurefunc("TradeFrame_UpdatePlayerItem", Module.ItemLevel_UpdateTradePlayer)
	hooksecurefunc("TradeFrame_UpdateTargetItem", Module.ItemLevel_UpdateTradeTarget)

	-- iLvl on GuildNews
	hooksecurefunc("GuildNewsButton_SetText", Module.ItemLevel_ReplaceGuildNews)
end
Module:RegisterMisc("SlotItemLevel", Module.CreateSlotItemLevel)
