local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]
local Module = K:GetModule("DataText")

local math_floor = math.floor
local string_gsub = string.gsub
local string_format = string.format
local table_sort = table.sort

local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemTexture = GetInventoryItemTexture

local DurabilityDataText
local repairCostString = string_gsub(REPAIR_COST, HEADER_COLON, ":")
local lowDurabilityCap = 0.25

local localSlots = {
	[1] = { 1, INVTYPE_HEAD, 1000 },
	[2] = { 3, INVTYPE_SHOULDER, 1000 },
	[3] = { 5, INVTYPE_CHEST, 1000 },
	[4] = { 6, INVTYPE_WAIST, 1000 },
	[5] = { 9, INVTYPE_WRIST, 1000 },
	[6] = { 10, INVTYPE_HAND, 1000 },
	[7] = { 7, INVTYPE_LEGS, 1000 },
	[8] = { 8, INVTYPE_FEET, 1000 },
	[9] = { 16, INVTYPE_WEAPONMAINHAND, 1000 },
	[10] = { 17, INVTYPE_WEAPONOFFHAND, 1000 },
	[11] = { 18, INVTYPE_RANGED, 1000 },
}

local function sortSlots(a, b)
	if a and b then
		return (a[3] == b[3] and a[1] < b[1]) or (a[3] < b[3])
	end
end

local function UpdateAllSlots()
	local numSlots = 0
	for i = 1, #localSlots do
		localSlots[i][3] = 1000
		local index = localSlots[i][1]
		if GetInventoryItemLink("player", index) then
			local current, max = GetInventoryItemDurability(index)
			if current then
				localSlots[i][3] = current / max
				numSlots = numSlots + 1
			end
			local iconTexture = GetInventoryItemTexture("player", index) or 134400
			localSlots[i][4] = ("|T" .. iconTexture .. ":13:15:0:0:50:50:4:46:4:46|t ") or ""
		end
	end
	table_sort(localSlots, sortSlots)

	return numSlots
end

local function isLowDurability()
	for i = 1, #localSlots do
		if localSlots[i][3] < lowDurabilityCap then
			return true
		end
	end
end

local function getDurabilityColor(cur, max)
	local r, g, b = K.oUF:RGBColorGradient(cur, max, 1, 0, 0, 1, 1, 0, 0, 1, 0)
	return r, g, b
end

local function NewSetLevelFunction()
	local total, equipped = GetAverageItemLevel()
	local r, g, b = K.GetILvlTextColor(equipped)
	CharacterLevelText:SetFont("Fonts\\FRIZQT__.TTF", 16)
	CharacterLevelText:SetFormattedText(string.format("|cff%02x%02x%02x" .. "Ilvl" .. ": %d|r", r * 255, g * 255, b * 255, math.floor(equipped)))
end

local eventList = {
	"UPDATE_INVENTORY_DURABILITY",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_EQUIPMENT_CHANGED",
	"PLAYER_AVG_ITEM_LEVEL_UPDATE",
}

local function OnEvent(event)
	if event == "PLAYER_ENTERING_WORLD" then
		DurabilityDataText:UnregisterEvent(event)
		-- Stop animation when zoning in to prevent stuck animations
		if lowDurabilityFrame.animGroup and lowDurabilityFrame.animGroup:IsPlaying() then
			lowDurabilityFrame.animGroup:Stop()
		end
	end

	if event == "PLAYER_EQUIPMENT_CHANGED" or event == "PLAYER_AVG_ITEM_LEVEL_UPDATE" then
		NewSetLevelFunction()
	end

	local numSlots = UpdateAllSlots()
	local isLow = isLowDurability()

	if event == "PLAYER_REGEN_ENABLED" then
		DurabilityDataText:UnregisterEvent(event)
		DurabilityDataText:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
		-- Stop animation when combat ends
		if lowDurabilityFrame.animGroup and lowDurabilityFrame.animGroup:IsPlaying() then
			lowDurabilityFrame.animGroup:Stop()
		end
	else
		if numSlots > 0 then
			local r, g, b = getDurabilityColor(math_floor(localSlots[1][3] * 100), 100)
			DurabilityDataText.Text:SetFormattedText("%s%%|r %s", K.RGBToHex(r, g, b) .. math.floor(localSlots[1][3] * 100), K.GreyColor .. DURABILITY)
		else
			DurabilityDataText.Text:SetText(DURABILITY .. ": " .. K.MyClassColor .. NONE)
		end
	end

	-- Show or hide the low durability warning based on the config setting
	if isLow and C["Misc"].SlotDurabilityWarning then
		Module:ShowLowDurabilityWarning()
	else
		Module:HideLowDurabilityWarning()
	end
end

local function OnEnter()
	GameTooltip:SetOwner(DurabilityDataText, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", DurabilityDataText, "TOPRIGHT", 0, 0)
	GameTooltip:AddDoubleLine(DURABILITY, " ", 0.4, 0.6, 1, 0.4, 0.6, 1)
	GameTooltip:AddLine(" ")

	local totalCost = 0
	for i = 1, #localSlots do
		if localSlots[i][3] ~= 1000 then
			local slot = localSlots[i][1]
			local cur = math_floor(localSlots[i][3] * 100)
			local slotIcon = localSlots[i][4]
			GameTooltip:AddDoubleLine(slotIcon .. localSlots[i][2], cur .. "%", 1, 1, 1, getDurabilityColor(cur, 100))

			K.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
			totalCost = totalCost + select(3, K.ScanTooltip:SetInventoryItem("player", slot))
		end
	end

	if totalCost > 0 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(repairCostString, K.FormatMoney(totalCost), 0.4, 0.6, 1, 1, 1, 1)
	end

	GameTooltip:Show()
end

local function OnLeave()
	GameTooltip:Hide()
end

-- Create a frame for the low durability warning
local lowDurabilityFrame = CreateFrame("Frame", "KKUI_DurabilityWarningFrame", UIParent)
lowDurabilityFrame:SetSize(400, 100)
lowDurabilityFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 300)
lowDurabilityFrame:Hide()

lowDurabilityFrame.text = lowDurabilityFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
lowDurabilityFrame.text:SetPoint("CENTER", lowDurabilityFrame, "CENTER", 0, 0)

-- Function to show the low durability warning
function Module:ShowLowDurabilityWarning()
	if not C["Misc"].SlotDurabilityWarning then
		return
	end

	local lowestDurability = math_floor(localSlots[1][3] * 100)
	lowDurabilityFrame.text:SetFormattedText("|A:services-icon-warning:16:16|a |cffff0000Low Durability!|r |cffffff00Please repair your gear.|r (|cff00ff00%d%%|r)", lowestDurability)
	lowDurabilityFrame:Show()

	-- Stop any ongoing animations
	if lowDurabilityFrame.animGroup and lowDurabilityFrame.animGroup:IsPlaying() then
		lowDurabilityFrame.animGroup:Stop()
	end

	-- Create animation group
	if not lowDurabilityFrame.animGroup then
		lowDurabilityFrame.animGroup = lowDurabilityFrame:CreateAnimationGroup()

		-- Create fade out animation
		local fadeOut = lowDurabilityFrame.animGroup:CreateAnimation("Alpha")
		fadeOut:SetFromAlpha(1)
		fadeOut:SetToAlpha(0)
		fadeOut:SetDuration(1)
		fadeOut:SetStartDelay(5)
		fadeOut:SetSmoothing("OUT")

		lowDurabilityFrame.animGroup:SetScript("OnFinished", function()
			lowDurabilityFrame:Hide()
			if isLowDurability() then
				C_Timer.After(60, Module.ShowLowDurabilityWarning) -- Remind again after 60 seconds if still low
			end
		end)
	end

	lowDurabilityFrame.animGroup:Play()
end

-- Function to hide the low durability warning
function Module:HideLowDurabilityWarning()
	if not C["Misc"].SlotDurabilityWarning then
		return -- Ensure the feature respects the config setting
	end
	lowDurabilityFrame:Hide()
end

function Module:CreateDurabilityDataText()
	if not C["Misc"].SlotDurability then return end

	_G.hooksecurefunc("PaperDollFrame_SetLevel", NewSetLevelFunction)

	DurabilityDataText = DurabilityDataText or CreateFrame("Frame", nil, UIParent)
	DurabilityDataText:CreateBackdrop(-4, 4, 4, -4, nil, nil, nil, nil, nil, K.UnitColor)

	DurabilityDataText.Text = DurabilityDataText.Text or DurabilityDataText:CreateFontString(nil, "ARTWORK")
	DurabilityDataText.Text:SetPoint("LEFT", UIParent, "LEFT", 0, -280)
	DurabilityDataText.Text:SetFontObject(K.UIFont)
	DurabilityDataText.Text:SetFont(select(1, DurabilityDataText.Text:GetFont()), 12, select(3, DurabilityDataText.Text:GetFont()))

	DurabilityDataText:SetAllPoints(DurabilityDataText.Text)

	for _, event in pairs(eventList) do
		DurabilityDataText:RegisterEvent(event)
	end

	DurabilityDataText:SetScript("OnEvent", OnEvent)
	DurabilityDataText:SetScript("OnEnter", OnEnter)
	DurabilityDataText:SetScript("OnLeave", OnLeave)

	-- Initial update
	NewSetLevelFunction()

	K.Mover(DurabilityDataText.Text, "DurabilityDataText", "DurabilityDataText", { "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 450, 6 }, 100, 18)
end

-- Manually update slots after repair to ensure data reflects changes
hooksecurefunc("RepairAllItems", function()
	UpdateAllSlots()
	OnEvent("UPDATE_INVENTORY_DURABILITY")
end)
