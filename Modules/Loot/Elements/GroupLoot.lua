local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]
local Module = K:GetModule("Loot")

-- Lua functions
local pairs, unpack, tonumber = pairs, unpack, tonumber

local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GameTooltip_ShowCompareItem = GameTooltip_ShowCompareItem
local GameTooltip_Hide = GameTooltip_Hide
local GetLootRollItemInfo = GetLootRollItemInfo
local GetLootRollItemLink = GetLootRollItemLink
local GetLootRollTimeLeft = GetLootRollTimeLeft
local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS
local IsModifiedClick = IsModifiedClick
local IsShiftKeyDown = IsShiftKeyDown
local GREED, NEED, PASS = GREED, NEED, PASS
local ROLL_DISENCHANT = ROLL_DISENCHANT
local RollOnLoot = RollOnLoot
local C_LootHistoryGetItem = C_LootHistory.GetItem
local C_LootHistoryGetPlayerInfo = C_LootHistory.GetPlayerInfo

-- Constants for roll dimensions and direction
local RollWidth, RollHeight, RollDirection = 328, 26, 2

-- Cache for roll data to improve performance
local cachedRolls, cachedIndex = {}, {}
Module.RollBars = {}

-- Parent frame for rolls
local parentFrame

-- Roll type definitions for clarity
local rolltypes = { [1] = "need", [2] = "greed", [3] = "disenchant", [0] = "pass" }

-- Function to handle click on roll button
local function ClickRoll(frame)
	RollOnLoot(frame.parent.rollID, frame.rolltype)
end

-- Function to set tooltip for a button
local function SetTip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	GameTooltip:SetText(frame.tiptext)

	for name, tbl in pairs(frame.parent.rolls) do
		if rolltypes[tbl[1]] == rolltypes[frame.rolltype] then
			local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[tbl[2]] or RAID_CLASS_COLORS[tbl[2]]
			GameTooltip:AddLine(name, classColor.r, classColor.g, classColor.b)
		end
	end

	GameTooltip:Show()
end

local function SetItemTip(frame, event)
	if not frame.link or (event == "MODIFIER_STATE_CHANGED" and not frame:IsMouseOver()) then return end
	GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT")
	GameTooltip:SetHyperlink(frame.link)
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
end

local function LootClick(frame)
	if IsModifiedClick() then
		_G.HandleModifiedItemClick(frame.link)
	end
end

local function StatusUpdate(frame, elapsed)
	local bar = frame.parent
	if not bar.rollID then
		if not bar.isTest then bar:Hide() end
		return
	end

	frame.elapsed = (frame.elapsed or 0) + elapsed
	if frame.elapsed > 0.1 then
		local timeLeft = GetLootRollTimeLeft(bar.rollID)
		if timeLeft <= 0 then
			Module.LootRoll_Cancel(bar, nil, bar.rollID)
		else
			frame:SetValue(timeLeft)
			frame.elapsed = 0
		end
	end
end

local function CreateRollButton(parent, ntex, ptex, htex, rolltype, tiptext, ...)
	local f = CreateFrame("Button", nil, parent)
	f:SetPoint(...)
	f:SetSize(RollHeight - 4, RollHeight - 4)
	f:SetNormalTexture(ntex)

	if ptex then f:SetPushedTexture(ptex) end

	f:SetHighlightTexture(htex)
	f:SetScript("OnEnter", SetTip)
	f:SetScript("OnLeave", GameTooltip_Hide)
	f:SetScript("OnClick", ClickRoll)
	f:SetMotionScriptsWhileDisabled(true)
	f:SetHitRectInsets(3, 3, 3, 3)

	f.rolltype = rolltype
	f.parent = parent
	f.tiptext = tiptext

	-- Centering text depending on roll type
	local yOffset = rolltype == 2 and 1 or rolltype == 0 and -1.2 or 0
	local txt = f:CreateFontString(nil, nil)
	txt:SetFontObject(K.UIFontOutline)
	txt:SetPoint("CENTER", 0, yOffset)

	return f, txt
end

function Module:CreateRollFrame(name)
	local frame = CreateFrame("Frame", name or "KKUI_LootRollFrame", UIParent)
	frame:SetSize(RollWidth, RollHeight)
	frame:SetFrameStrata("MEDIUM")
	frame:SetFrameLevel(10)
	frame:SetScript("OnEvent", Module.LootRoll_Cancel)
	frame:RegisterEvent("CANCEL_LOOT_ROLL")
	frame:Hide()

	local button = CreateFrame("Button", nil, frame)
	button:SetPoint("RIGHT", frame, "LEFT", -6, 0)
	button:SetSize(frame:GetHeight(), frame:GetHeight())
	button:CreateBorder()
	button:SetScript('OnEvent', SetItemTip)
	button:SetScript("OnEnter", SetItemTip)
	button:SetScript("OnLeave", GameTooltip_Hide)
	button:SetScript("OnClick", LootClick)
	frame.button = button

	-- Initialization of icon, stack, and item level
	local icon, stack, ilvl = button:CreateTexture(nil, "OVERLAY"), button:CreateFontString(nil, "OVERLAY"), button:CreateFontString(nil, "OVERLAY")
	icon:SetAllPoints()
	icon:SetTexCoord(unpack(K.TexCoords))
	button.icon = icon

	stack:SetPoint("BOTTOMRIGHT", -1, 2)
	stack:SetFontObject(K.UIFontOutline)
	button.stack = stack

	ilvl:SetPoint("BOTTOMLEFT", 1, 1)
	ilvl:SetFontObject(K.UIFontOutline)
	button.ilvl = ilvl

	-- Status bar creation and configuration
	local status = CreateFrame("StatusBar", nil, frame)
	status:SetAllPoints(frame)
	status:SetScript("OnUpdate", StatusUpdate)
	status:SetFrameLevel(status:GetFrameLevel() - 1)
	status:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
	status:SetFrameLevel(status:GetFrameLevel() - 1)
	status:CreateBorder()
	status:SetStatusBarColor(0.8, 0.8, 0.8, 0.9)
	status.parent = frame
	frame.status = status

	-- Spark for status bar
	local spark = status:CreateTexture(nil, "ARTWORK", nil, 1)
	spark:SetSize(128, RollHeight)
	spark:SetTexture(C["Media"].Textures.Spark128Texture)
	spark:SetPoint("CENTER", status:GetStatusBarTexture(), "RIGHT", 0, 0)
	spark:SetBlendMode("BLEND")
	spark:SetAlpha(0.8)
	status.spark = spark

	local need, needtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Dice-Up", "Interface\\Buttons\\UI-GroupLoot-Dice-Highlight", "Interface\\Buttons\\UI-GroupLoot-Dice-Down", 1, NEED, "LEFT", frame.button, "RIGHT", 6, -1)
	local greed, greedtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Coin-Up", "Interface\\Buttons\\UI-GroupLoot-Coin-Highlight", "Interface\\Buttons\\UI-GroupLoot-Coin-Down", 2, GREED, "LEFT", need, "RIGHT", 3, -1)
	local de, detext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-DE-Up", "Interface\\Buttons\\UI-GroupLoot-DE-Highlight", "Interface\\Buttons\\UI-GroupLoot-DE-Down", 3, ROLL_DISENCHANT, "LEFT", greed, "RIGHT", 3, -1)
	local pass, passtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Pass-Up", nil, "Interface\\Buttons\\UI-GroupLoot-Pass-Down", 0, PASS, "LEFT", de or greed, "RIGHT", 3, 2)
	frame.needbutt, frame.greedbutt, frame.disenchantbutt = need, greed, de
	frame.need, frame.greed, frame.pass, frame.disenchant = needtext, greedtext, passtext, detext

	-- Binding and loot text
	local bind, loot = frame:CreateFontString(), frame:CreateFontString(nil, "ARTWORK")
	bind:SetPoint("LEFT", pass, "RIGHT", 3, 0)
	bind:SetFontObject(K.UIFontOutline)
	frame.fsbind = bind

	loot:SetFontObject(K.UIFontOutline)
	loot:SetPoint("LEFT", bind, "RIGHT", 0, 0)
	loot:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
	loot:SetSize(200, 10)
	loot:SetJustifyH("LEFT")
	frame.fsloot = loot

	frame.rolls = {}

	return frame
end

local function GetFrame()
	for _, f in next, Module.RollBars do
		if not f.rollID then return f end
	end

	local f = Module:CreateRollFrame()
	if next(Module.RollBars) then
		if RollDirection == 2 then
			f:SetPoint("TOP", Module.RollBars[#Module.RollBars], "BOTTOM", 0, -6)
		else
			f:SetPoint("BOTTOM", Module.RollBars[#Module.RollBars], "TOP", 0, 6)
		end
	else
		f:SetPoint("TOP", parentFrame, "TOP", 0, -20)
	end

	table.insert(Module.RollBars, f)

	return f
end

function Module.START_LOOT_ROLL(_, rollID, time)
	local texture, name, count, quality, bop, canNeed, canGreed, canDisenchant, _, _, _, _, canTransmog = GetLootRollItemInfo(rollID)
	if not name then
		for _, rollBar in next, Module.RollBars do
			if rollBar.rollID == rollID then
				Module.LootRoll_Cancel(rollBar, nil, rollID)
			end
		end
		return
	end

	local f = GetFrame()
	if not f then return end

	for i in pairs(f.rolls) do 
		f.rolls[i] = nil 
	end

	local itemLink = GetLootRollItemLink(rollID)
	local _, _, _, itemLevel, _, _, _, _, _, _, _, _, _, bindType = GetItemInfo(itemLink)

	if not bop then bop = bindType == 1 end -- recheck sometimes, we need this from bindType

	f.rollID = rollID
	f.time = time

	f.button.link = itemLink
	f.button.rollID = rollID
	f.button.icon:SetTexture(texture)
	f.button.stack:SetShown(count > 1)
	f.button.stack:SetText(count)
	f.button.ilvl:SetText(itemLevel or "")

	f.need:SetText(0)
	f.greed:SetText(0)
	f.pass:SetText(0)
	f.disenchant:SetText(0)

	if canNeed then f.needbutt:Enable() else f.needbutt:Disable() end
	if canGreed then f.greedbutt:Enable() else f.greedbutt:Disable() end
	if canDisenchant then f.disenchantbutt:Enable() else f.disenchantbutt:Disable() end

	if canNeed then f.needbutt:SetAlpha(1) else f.needbutt:SetAlpha(0.2) end
	if canGreed then f.greedbutt:SetAlpha(1) else f.greedbutt:SetAlpha(0.2) end
	if canDisenchant then f.disenchantbutt:SetAlpha(1) else f.disenchantbutt:SetAlpha(0.2) end

	f.fsbind:SetText(bop and L["BoP"] or L["BoE"])
	f.fsbind:SetVertexColor(bop and 1 or 0.3, bop and 0.3 or 1, bop and 0.1 or 0.3)

	local color = ITEM_QUALITY_COLORS[quality]
	f.fsloot:SetText(name)
	f.status:SetStatusBarColor(color.r, color.g, color.b, 0.7)
	f.button.ilvl:SetTextColor(color.r, color.g, color.b)

	f.status:SetMinMaxValues(0, time)
	f.status:SetValue(time)

	f:Show()

	-- Add cached roll info, if any
	for rollid, rollTable in pairs(cachedRolls) do
		if f.rollID == rollid then -- rollid matches cached rollid
			for rollerName, rollerInfo in pairs(rollTable) do
				local rollType, class = rollerInfo[1], rollerInfo[2]
				f.rolls[rollerName] = {rollType, class}
				f[rolltypes[rollType]]:SetText(tonumber(f[rolltypes[rollType]]:GetText()) + 1)
			end
			break
		end
	end
end

function Module.LOOT_HISTORY_ROLL_CHANGED(_, itemIdx, playerIdx)
	local rollID = C_LootHistoryGetItem(itemIdx)
	local name, class, rollType = C_LootHistoryGetPlayerInfo(itemIdx, playerIdx)

	local rollIsHidden = true
	if name and rollType then
		for _, f in next, Module.RollBars do
			if f.rollID == rollID then
				f.rolls[name] = { rollType, class }
				f[rolltypes[rollType]]:SetText(tonumber(f[rolltypes[rollType]]:GetText()) + 1)
				rollIsHidden = false
				break
			end
		end

		-- History changed for a loot roll that hasn"t popped up for the player yet, so cache it for later
		if rollIsHidden then
			cachedRolls[rollID] = cachedRolls[rollID] or {}
			if not cachedRolls[rollID][name] then
				cachedRolls[rollID][name] = { rollType, class }
			end
		end
	end
end

-- Function to cancel a loot roll
function Module:LootRoll_Cancel(_, rollID)
	if self.rollID == rollID then
		self.rollID, self.time = nil, nil
		if cachedRolls[rollID] then
			wipe(cachedRolls[rollID])
		end
	end
end

local completedRolls = {}
function Module.LOOT_HISTORY_ROLL_COMPLETE()
	-- Remove completed rolls from cache
	for rollID in pairs(completedRolls) do
		cachedRolls[rollID] = nil
		completedRolls[rollID] = nil
	end
end
Module.LOOT_ROLLS_COMPLETE = Module.LOOT_HISTORY_ROLL_COMPLETE

function Module:CreateGroupLoot()
	if not C["Loot"].GroupLoot then return end

	K:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED", self.LOOT_HISTORY_ROLL_CHANGED)
	K:RegisterEvent("LOOT_HISTORY_ROLL_COMPLETE", self.LOOT_HISTORY_ROLL_COMPLETE)	
	K:RegisterEvent("LOOT_ROLLS_COMPLETE", self.LOOT_ROLLS_COMPLETE)
	K:RegisterEvent("START_LOOT_ROLL", self.START_LOOT_ROLL)

	_G.UIParent:UnregisterEvent("START_LOOT_ROLL")
	_G.UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")
end