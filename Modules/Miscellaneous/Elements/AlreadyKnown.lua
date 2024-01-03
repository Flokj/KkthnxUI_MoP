local K = unpack(KkthnxUI)
local Module = K:GetModule("Tooltip")

-- Sourced: AlreadyKnown (villiv)
-- Edited: KkthnxUI (Kkthnx)

-- Cache global functions
local strmatch = strmatch
local tonumber = tonumber
local ceil = math.ceil
local format = string.format

-- Cache WoW API functions
local GetItemInfo = GetItemInfo
local GetInboxItem = GetInboxItem
local GetInboxItemLink = GetInboxItemLink
local GetLootSlotInfo = GetLootSlotInfo
local GetLootSlotLink = GetLootSlotLink
local GetMerchantNumItems = GetMerchantNumItems
local GetMerchantItemInfo = GetMerchantItemInfo
local GetMerchantItemLink = GetMerchantItemLink
local GetNumQuestRewards = GetNumQuestRewards
local GetNumQuestChoices = GetNumQuestChoices
local GetQuestItemInfo = GetQuestItemInfo
local GetQuestLogItemLink = GetQuestLogItemLink
local GetQuestItemLink = GetQuestItemLink
local GetNumBuybackItems = GetNumBuybackItems
local GetBuybackItemInfo = GetBuybackItemInfo
local GetBuybackItemLink = GetBuybackItemLink
local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local GetGuildBankItemInfo = GetGuildBankItemInfo
local GetGuildBankItemLink = GetGuildBankItemLink
local C_PetJournal_GetNumCollectedInfo = C_PetJournal.GetNumCollectedInfo

-- Cache WoW API objects and constants
local C_TooltipInfo = C_TooltipInfo
local C_AddOns = C_AddOns
local LootFrameElementMixin = LootFrameElementMixin
local COLLECTED = COLLECTED
local ITEM_SPELL_KNOWN = ITEM_SPELL_KNOWN
local ATTACHMENTS_MAX_RECEIVE = ATTACHMENTS_MAX_RECEIVE
local MERCHANT_ITEMS_PER_PAGE = MERCHANT_ITEMS_PER_PAGE
local MAX_GUILDBANK_SLOTS_PER_TAB = MAX_GUILDBANK_SLOTS_PER_TAB or 98
local NUM_SLOTS_PER_GUILDBANK_GROUP = NUM_SLOTS_PER_GUILDBANK_GROUP or 14

-- Cache UI functions
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor
local CreateFrame = CreateFrame

-- Cache global variables

local COLOR = { r = 0.1, g = 1, b = 0.1 }
local knowables = {
	[LE_ITEM_CLASS_CONSUMABLE] = true,
	[LE_ITEM_CLASS_RECIPE] = true,
	[LE_ITEM_CLASS_MISCELLANEOUS] = true,
}
local knowns = {}

local function isPetCollected(speciesID)
	if not speciesID or speciesID == 0 then return end
	local numOwned = C_PetJournal.GetNumCollectedInfo(speciesID)
	if numOwned > 0 then return true end
end

local function IsAlreadyKnown(link, index)
	if not link then return end

	if strmatch(link, "battlepet:") then
		local speciesID = select(2, strsplit(":", link))
		return isPetCollected(speciesID)
	elseif strmatch(link, "item:") then
		local name, _, _, _, _, _, _, _, _, _, _, itemClassID = GetItemInfo(link)
		if not name then return end

		if itemClassID == LE_ITEM_CLASS_BATTLEPET and index then
			local speciesID = K.ScanTooltip:SetGuildBankItem(GetCurrentGuildBankTab(), index)
			return isPetCollected(speciesID)
		else
			if knowns[link] then return true end
			if not knowables[itemClassID] then
				return
			end

			K.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
			K.ScanTooltip:SetHyperlink(link)
			for i = 1, K.ScanTooltip:NumLines() do
				local text = _G["KKUI_ScanTooltipTextLeft" .. i]:GetText() or ""
				if strfind(text, COLLECTED) or text == ITEM_SPELL_KNOWN then
					knowns[link] = true
					return true
				end
			end
			-- Clear the 'knowns' table here, as it's not needed beyond this point.
			knowns = {}
		end
	end
end

-- merchant frame
local function MerchantFrame_UpdateMerchantInfo()
	local numItems = GetMerchantNumItems()
	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
		if index > numItems then return end

		local button = _G["MerchantItem" .. i .. "ItemButton"]
		local isButtonShown = button and button:IsShown()
		if isButtonShown then
			local _, _, _, _, numAvailable, isUsable = GetMerchantItemInfo(index)
			if isUsable and IsAlreadyKnown(GetMerchantItemLink(index)) then
				local r, g, b = COLOR.r, COLOR.g, COLOR.b
				if numAvailable == 0 then
					r, g, b = r * 0.5, g * 0.5, b * 0.5
				end
				SetItemButtonTextureVertexColor(button, r, g, b)
			end
		end
	end
end
hooksecurefunc("MerchantFrame_UpdateMerchantInfo", MerchantFrame_UpdateMerchantInfo)

local function MerchantFrame_UpdateBuybackInfo()
	local numItems = GetNumBuybackItems()
	for index = 1, BUYBACK_ITEMS_PER_PAGE do
		if index > numItems then return end

		local button = _G["MerchantItem" .. index .. "ItemButton"]
		local isButtonShown = button and button:IsShown()
		if isButtonShown then
			local _, _, _, _, _, isUsable = GetBuybackItemInfo(index)
			if isUsable and IsAlreadyKnown(GetBuybackItemLink(index)) then
				SetItemButtonTextureVertexColor(button, COLOR.r, COLOR.g, COLOR.b)
			end
		end
	end
end
hooksecurefunc("MerchantFrame_UpdateBuybackInfo", MerchantFrame_UpdateBuybackInfo)

-- auction frame
local function AuctionFrameBrowse_Update()
	local numItems = GetNumAuctionItems("list")
	local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
	for i = 1, NUM_BROWSE_TO_DISPLAY do
		local index = offset + i
		if index > numItems then return end

		local texture = _G["BrowseButton" .. i .. "ItemIconTexture"]
		if texture and texture:IsShown() then
			local _, _, _, _, canUse = GetAuctionItemInfo("list", index)
			if canUse and IsAlreadyKnown(GetAuctionItemLink("list", index)) then
				texture:SetVertexColor(COLOR.r, COLOR.g, COLOR.b)
			end
		end
	end
end

local function AuctionFrameBid_Update()
	local numItems = GetNumAuctionItems("bidder")
	local offset = FauxScrollFrame_GetOffset(BidScrollFrame)
	for i = 1, NUM_BIDS_TO_DISPLAY do
		local index = offset + i
		if index > numItems then return end

		local texture = _G["BidButton" .. i .. "ItemIconTexture"]
		if texture and texture:IsShown() then
			local _, _, _, _, canUse = GetAuctionItemInfo("bidder", index)
			if canUse and IsAlreadyKnown(GetAuctionItemLink("bidder", index)) then
				texture:SetVertexColor(COLOR.r, COLOR.g, COLOR.b)
			end
		end
	end
end

local function AuctionFrameAuctions_Update()
	local numItems = GetNumAuctionItems("owner")
	local offset = FauxScrollFrame_GetOffset(AuctionsScrollFrame)
	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
		local index = offset + i
		if index > numItems then return end

		local texture = _G["AuctionsButton" .. i .. "ItemIconTexture"]
		if texture and texture:IsShown() then
			local _, _, _, _, canUse, _, _, _, _, _, _, _, saleStatus = GetAuctionItemInfo("owner", index)
			if canUse and IsAlreadyKnown(GetAuctionItemLink("owner", index)) then
				local r, g, b = COLOR.r, COLOR.g, COLOR.b
				if saleStatus == 1 then
					r, g, b = r * 0.5, g * 0.5, b * 0.5
				end
				texture:SetVertexColor(r, g, b)
			end
		end
	end
end

local function GuildBankFrame_Update(self)
	if self.mode ~= "bank" then return end

	local button, index, column, texture, locked, quality
	local currentTab = GetCurrentGuildBankTab()
	for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
		index = (i - 1) % NUM_SLOTS_PER_GUILDBANK_GROUP + 1

		column = ceil(i / NUM_SLOTS_PER_GUILDBANK_GROUP)
		button = self.Columns[column].Buttons[index]
		local isButtonShown = button and button:IsShown()
		if isButtonShown then
			texture, _, locked, _, quality = GetGuildBankItemInfo(currentTab, i)
			if texture and not locked then
				local itemLink = GetGuildBankItemLink(currentTab, i)
				if IsAlreadyKnown(itemLink, i) then
					SetItemButtonTextureVertexColor(button, COLOR.r, COLOR.g, COLOR.b)
				else
					SetItemButtonTextureVertexColor(button, 1, 1, 1)
				end
			end

			if button.bg then
				local color = K.QualityColors[quality or 1]
				button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		end
	end
end

local hookCount = 0
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, addon)
	if addon == "Blizzard_AuctionUI" then
		hooksecurefunc("AuctionFrameBrowse_Update", AuctionFrameBrowse_Update)
		hooksecurefunc("AuctionFrameBid_Update", AuctionFrameBid_Update)
		hooksecurefunc("AuctionFrameAuctions_Update", AuctionFrameAuctions_Update)
		hookCount = hookCount + 1
	elseif addon == "Blizzard_GuildBankUI" then
		if GuildBankFrame then
			hooksecurefunc(GuildBankFrame, "Update", GuildBankFrame_Update)
			hookCount = hookCount + 1
		end
	end

	if hookCount >= 2 then
		frame:UnregisterEvent(event)
	end
end)
