local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]
local Module = K:GetModule("Miscellaneous")

-- Caching global functions and variables
local math_min, math_floor = math.min, math.floor
local string_format = string.format
local select, pairs = select, pairs

-- Experience
local CurrentXP, XPToLevel, PercentRested, PercentXP, RemainXP, RemainTotal, RemainBars
local RestedXP = 0

-- Reputation
local function RepGetValues(curValue, minValue, maxValue)
	local maximum = maxValue - minValue
	local current, diff = curValue - minValue, maximum

	if diff == 0 then
		diff = 1
	end -- prevent a division by zero

	if current == maximum then
		return 1, 1, 100, true
	else
		return current, maximum, current / diff * 100
	end
end

-- Bar string
local barDisplayString = ""

local function OnExpBarEvent(self, event, unit)
	if not IsPlayerAtEffectiveMaxLevel() then
		CurrentXP, XPToLevel, RestedXP = UnitXP("player"), UnitXPMax("player"), (GetXPExhaustion() or 0)
		
		-- Ensure XPToLevel is not 0 to avoid division by zero
		if XPToLevel <= 0 then
			XPToLevel = 1
		end

		-- Calculate remaining XP and percentage
		local remainXP = XPToLevel - CurrentXP
		local remainPercent = remainXP / XPToLevel
		RemainTotal, RemainBars = remainPercent * 100, remainPercent * 20
		PercentXP, RemainXP = (CurrentXP / XPToLevel) * 100, K.ShortValue(remainXP)

		-- Set status bar colors
		self:SetStatusBarColor(0, 0.4, 1, 0.8)
		self.restBar:SetStatusBarColor(1, 0, 1, 0.4)

		-- Set up main XP bar
		self:SetMinMaxValues(0, XPToLevel)
		self:SetValue(CurrentXP)
		barDisplayString = string_format("%s - %.2f%%", K.ShortValue(CurrentXP), PercentXP)

		-- Check if rested XP exists
		local isRested = RestedXP > 0
		if isRested then
			-- Set up rested XP bar
			self.restBar:SetMinMaxValues(0, XPToLevel)
			self.restBar:SetValue(math_min(CurrentXP + RestedXP, XPToLevel))

			-- Calculate percentage of rested XP
			PercentRested = (RestedXP / XPToLevel) * 100

			-- Update XP display string with rested XP information
			barDisplayString = string_format("%s R:%s [%.2f%%]", barDisplayString, K.ShortValue(RestedXP), PercentRested)
		end

		-- Show experience
		self:Show()

		-- Show or hide rested XP bar based on rested state
		self.restBar:SetShown(isRested)

		-- Update text display with XP information
		self.text:SetText(barDisplayString)
	elseif GetWatchedFactionInfo() then
		local label, rewardPending
		local name, reaction, minValue, maxValue, curValue = GetWatchedFactionInfo()

		if not label then
			label = _G["FACTION_STANDING_LABEL" .. reaction] or UNKNOWN
		end

		local color = (reaction == 9 and { r = 0, g = 0.5, b = 0.9 }) or K.Colors.faction[reaction] -- reaction 9 is Paragon
		self:SetStatusBarColor(color.r, color.g, color.b)
		self:SetMinMaxValues(minValue, maxValue)
		self:SetValue(curValue)
		self:Show()
		self.reward:SetShown(rewardPending)

		local current, _, percent, capped = RepGetValues(curValue, minValue, maxValue)
		if capped then -- show only name and standing on exalted
			self.text:SetText(string_format("%s: [%s]", name, label))
		else
			self.text:SetText(string_format("%s: %s - %d%% [%s]", name, K.ShortValue(current), percent, label))
		end
		self.text:Show()
	else
		self:Hide()
		self.text:Hide()
	end
end

local function OnExpBarEnter(self)
	if GameTooltip:IsForbidden() then return end
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")

	if not IsPlayerAtEffectiveMaxLevel() then
		CurrentXP, XPToLevel, RestedXP = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
		if XPToLevel <= 0 then
			XPToLevel = 1
		end

		local remainXP = XPToLevel - CurrentXP
		local remainPercent = remainXP / XPToLevel
		RemainTotal, RemainBars = remainPercent * 100, remainPercent * 20
		PercentXP, RemainXP = (CurrentXP / XPToLevel) * 100, K.ShortValue(remainXP)

		GameTooltip:AddLine("Experience", 0, 0.4, 1)
		GameTooltip:AddDoubleLine(LEVEL, K.Level, 1, 1, 1)
		GameTooltip:AddDoubleLine("XP:", string_format(" %d / %d (%.2f%%)", CurrentXP, XPToLevel, PercentXP), 1, 1, 1)
		GameTooltip:AddDoubleLine("Remaining:", string_format(" %s (%.2f%% - %d " .. L["Bars"] .. ")", RemainXP, RemainTotal, RemainBars), 1, 1, 1)

		if RestedXP and RestedXP > 0 then
			GameTooltip:AddDoubleLine("Rested:", string_format("%d (%.2f%%)", RestedXP, PercentRested), 1, 1, 1)
		end
	end

	if GetWatchedFactionInfo() then
		local name, reaction, minValue, maxValue, curValue = GetWatchedFactionInfo()

		if name then
			GameTooltip:AddLine(name, K.RGBToHex(0, 0.74, 0.95))

			if reaction ~= _G.MAX_REPUTATION_REACTION then
				local current, maximum, percent = RepGetValues(curValue, minValue, maxValue)
				GameTooltip:AddDoubleLine(REPUTATION .. ":", string_format("%d / %d (%d%%)", current, maximum, percent), 1, 1, 1)
			end
		end
	end

	GameTooltip:Show()
end

local function OnExpBarLeave()
	K.HideTooltip()
end

local ExpRep_EventList = {
	"PLAYER_XP_UPDATE",
	"PLAYER_LEVEL_UP",
	"UPDATE_EXHAUSTION",
	"PLAYER_ENTERING_WORLD",
	"UPDATE_FACTION",
	"UNIT_INVENTORY_CHANGED",
	"ENABLE_XP_GAIN",
	"DISABLE_XP_GAIN",
}

local function SetupExpRepScript(bar)
	for _, event in pairs(ExpRep_EventList) do
		bar:RegisterEvent(event)
	end

	OnExpBarEvent(bar)

	bar:SetScript("OnEvent", OnExpBarEvent)
	bar:SetScript("OnEnter", OnExpBarEnter)
	bar:SetScript("OnLeave", OnExpBarLeave)
end

function Module:CreateExpbar()
	if not C["Misc"].ExpRep then return end

	local bar = CreateFrame("StatusBar", "KKUI_ExpRepBar", MinimapCluster)
	bar:SetPoint("TOP", Minimap, "BOTTOM", 0, -6)
	bar:SetSize(Minimap:GetWidth() or 190, 14)
	bar:SetHitRectInsets(0, 0, 0, -10)
	bar:SetStatusBarTexture(K.GetTexture(C["General"].Texture))

	local spark = bar:CreateTexture(nil, "OVERLAY")
	spark:SetTexture(C["Media"].Textures.Spark16Texture)
	spark:SetHeight(bar:GetHeight() - 2)
	spark:SetBlendMode("ADD")
	spark:SetPoint("CENTER", bar:GetStatusBarTexture(), "RIGHT", 0, 0)
	spark:SetAlpha(0.6)

	local border = CreateFrame("Frame", nil, bar)
	border:SetAllPoints(bar)
	border:SetFrameLevel(bar:GetFrameLevel())
	border:CreateBorder()

	local rest = CreateFrame("StatusBar", nil, bar)
	rest:SetAllPoints()
	rest:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
	rest:SetStatusBarColor(1, 0, 1, 0.4)
	rest:SetFrameLevel(bar:GetFrameLevel() - 1)
	bar.restBar = rest

	local reward = bar:CreateTexture(nil, "OVERLAY")
	reward:SetAtlas("ParagonReputation_Bag")
	reward:SetSize(12, 14)
	bar.reward = reward

	local text = bar:CreateFontString(nil, "OVERLAY")
	text:SetFontObject(K.UIFont)
	text:SetFont(select(1, text:GetFont()), 11, select(3, text:GetFont()))
	text:SetWidth(bar:GetWidth() - 6)
	text:SetWordWrap(false)
	text:SetPoint("LEFT", bar, "RIGHT", -3, 0)
	text:SetPoint("RIGHT", bar, "LEFT", 3, 0)
	bar.text = text

	SetupExpRepScript(bar)

	if not bar.mover then
		bar.mover = K.Mover(bar, "bar", "bar", { "TOP", Minimap, "BOTTOM", 0, -6 })
	else
		bar.mover:SetSize(Minimap:GetWidth() or 190, 14)
	end
end
Module:RegisterMisc("ExpRep", Module.CreateExpbar)
