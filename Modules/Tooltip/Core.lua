local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]
local Module = K:NewModule("Tooltip")

local strfind, format, strupper, strlen, pairs, unpack = string.find, string.format, string.upper, string.len, pairs, unpack
local ICON_LIST = ICON_LIST
local PVP, LEVEL, FACTION_HORDE, FACTION_ALLIANCE = PVP, LEVEL, FACTION_HORDE, FACTION_ALLIANCE
local YOU, TARGET, AFK, DND, DEAD, PLAYER_OFFLINE = YOU, TARGET, AFK, DND, DEAD, PLAYER_OFFLINE
local FOREIGN_SERVER_LABEL, INTERACTIVE_SERVER_LABEL = FOREIGN_SERVER_LABEL, INTERACTIVE_SERVER_LABEL
local LE_REALM_RELATION_COALESCED, LE_REALM_RELATION_VIRTUAL = LE_REALM_RELATION_COALESCED, LE_REALM_RELATION_VIRTUAL
local UnitIsPVP, UnitFactionGroup, UnitRealmRelationship, UnitGUID = UnitIsPVP, UnitFactionGroup, UnitRealmRelationship, UnitGUID
local UnitIsConnected, UnitIsDeadOrGhost, UnitIsAFK, UnitIsDND, UnitReaction = UnitIsConnected, UnitIsDeadOrGhost, UnitIsAFK, UnitIsDND, UnitReaction
local InCombatLockdown, IsShiftKeyDown, GetMouseFocus, GetItemInfo = InCombatLockdown, IsShiftKeyDown, GetMouseFocus, C_Item.GetItemInfo
local GetCreatureDifficultyColor, UnitCreatureType, UnitClassification = GetCreatureDifficultyColor, UnitCreatureType, UnitClassification
local UnitIsPlayer, UnitName, UnitPVPName, UnitClass, UnitRace, UnitLevel = UnitIsPlayer, UnitName, UnitPVPName, UnitClass, UnitRace, UnitLevel
local GetRaidTargetIndex, UnitGroupRolesAssigned, GetGuildInfo, IsInGuild = GetRaidTargetIndex, UnitGroupRolesAssigned, GetGuildInfo, IsInGuild
local GameTooltip_ClearMoney, GameTooltip_ClearStatusBars, GameTooltip_ClearProgressBars, GameTooltip_ClearWidgetSet = GameTooltip_ClearMoney, GameTooltip_ClearStatusBars, GameTooltip_ClearProgressBars, GameTooltip_ClearWidgetSet

local classification = {
	worldboss = format("|cffAF5050 %s|r", BOSS),
	rareelite = format("|cffAF5050+ %s|r", ITEM_QUALITY3_DESC),
	elite = "|cffAF5050+|r",
	rare = format("|cffAF5050 %s|r", ITEM_QUALITY3_DESC),
}
local npcIDstring = "%s " .. K.InfoColor .. "%s"

function Module:GetMouseFocus()
	if GetMouseFoci then
		local frames = GetMouseFoci()
		return frames and frames[1]
	else
		return GetMouseFocus()
	end
end

function Module:GetUnit()
	local _, unit = self:GetUnit()
	if not unit then
		local mFocus = Module:GetMouseFocus()
		unit = mFocus and (mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute("unit")))
	end
	return unit
end

function Module:UpdateFactionLine()
	for i = 3, self:NumLines() do
		local tiptext = _G["GameTooltipTextLeft" .. i]
		local linetext = tiptext:GetText()
		if linetext then
			if linetext == PVP then
				tiptext:SetText("")
				tiptext:Hide()
			elseif linetext == FACTION_HORDE then
				if C["Tooltip"].FactionIcon then
					tiptext:SetText("")
					tiptext:Hide()
				else
					tiptext:SetText("|cffff5040" .. linetext .. "|r")
				end
			elseif linetext == FACTION_ALLIANCE then
				if C["Tooltip"].FactionIcon then
					tiptext:SetText("")
					tiptext:Hide()
				else
					tiptext:SetText("|cff4080ff" .. linetext .. "|r")
				end
			end
		end
	end
end

function Module:GetLevelLine()
   if GetLocale() == "ruRU" then LEVEL = "уров" else LEVEL = LEVEL end
	for i = 2, self:NumLines() do
		local tiptext = _G[self:GetName() .. "TextLeft" .. i]
		if not tiptext then
			break
		end
		
		local linetext = tiptext:GetText()
		if linetext and strfind(linetext, LEVEL) then
			return tiptext
		end
	end
end

function Module:GetTarget(unit)
	if UnitIsUnit(unit, "player") then
		return format("|cffff0000%s|r", ">" .. strupper(YOU) .. "<")
	else
		return K.RGBToHex(K.UnitColor(unit)) .. UnitName(unit) .. "|r"
	end
end

function Module:InsertFactionFrame(faction)
	if not self.factionFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", -10, -10)
		f:SetBlendMode("ADD")

		self.factionFrame = f
	end

	if faction then
		self.factionFrame:SetAtlas("MountJournalIcons-" .. faction, true)
		self.factionFrame:Show()
	end
end

function Module:OnTooltipCleared()
	if self:IsForbidden() then return end

	if self.factionFrame and self.factionFrame:IsShown() then
		self.factionFrame:Hide()
	end

	GameTooltip_ClearMoney(self)
	GameTooltip_ClearStatusBars(self)
	GameTooltip_ClearProgressBars(self)
	GameTooltip_ClearWidgetSet(self)
end

local function ShouldHideInCombat()
	local index = C["Tooltip"].HideInCombat.Value
	if index == 1 then
		return true
	elseif index == 2 then
		return IsAltKeyDown()
	elseif index == 3 then
		return IsShiftKeyDown()
	elseif index == 4 then
		return IsControlKeyDown()
	elseif index == 5 then
		return false
	end
end

function Module:OnTooltipSetUnit()
	if self:IsForbidden() then return end

	if (not ShouldHideInCombat()) and InCombatLockdown() then
		self:Hide()
		return
	end

	Module.UpdateFactionLine(self)

	local unit = Module.GetUnit(self)
	if not unit or not UnitExists(unit) then return end

	local isShiftKeyDown = IsShiftKeyDown()
	local isPlayer = UnitIsPlayer(unit)
	if isPlayer then
		local name, realm = UnitName(unit)
		local pvpName = UnitPVPName(unit)
		local relationship = UnitRealmRelationship(unit)
		if not C["Tooltip"].HideTitle and pvpName then
			name = pvpName
		end

		if realm and realm ~= "" then
			if isShiftKeyDown or not C["Tooltip"].HideRealm then
				name = name .. "-" .. realm
			elseif relationship == LE_REALM_RELATION_COALESCED then
				name = name .. FOREIGN_SERVER_LABEL
			elseif relationship == LE_REALM_RELATION_VIRTUAL then
				name = name .. INTERACTIVE_SERVER_LABEL
			end
		end

		local status = (UnitIsAFK(unit) and AFK) or (UnitIsDND(unit) and DND) or (not UnitIsConnected(unit) and PLAYER_OFFLINE)
		if status then
			status = format(" |cffffcc00[%s]|r", status)
		else
			status = ""
		end
		GameTooltipTextLeft1:SetFormattedText("%s%s", name, status)

		if C["Tooltip"].FactionIcon then
			local faction = UnitFactionGroup(unit)
			if faction and faction ~= "Neutral" then
				Module.InsertFactionFrame(self, faction)
			end
		end

		if C["Tooltip"].LFDRole then
			local unitRole = UnitGroupRolesAssigned(unit)
			if IsInGroup() and (UnitInParty(unit) or UnitInRaid(unit)) and (unitRole ~= "NONE") then
				local roleColors = {
					HEALER = "|cff00ff96", -- RGB: 0, 255, 150
					TANK = "|cff2850a0", -- RGB: 40, 80, 160
					DAMAGER = "|cffc41f3b", -- RGB: 196, 31, 59
				}
				local roleNames = {
					HEALER = HEALER,
					TANK = TANK,
					DAMAGER = DAMAGE,
				}
				local unitColor = roleColors[unitRole]
				local unitRoleName = roleNames[unitRole]

				if unitColor and unitRoleName then
					self:AddLine(ROLE .. ": " .. unitColor .. unitRoleName .. "|r")
				end
			end
		end
		local guildName, rank, rankIndex, guildRealm = GetGuildInfo(unit)
		local hasText = GameTooltipTextLeft2:GetText()
		if guildName and hasText then
			local myGuild, _, _, myGuildRealm = GetGuildInfo("player")
			if IsInGuild() and guildName == myGuild and guildRealm == myGuildRealm then
				GameTooltipTextLeft2:SetTextColor(0.25, 1, 0.25)
			else
				GameTooltipTextLeft2:SetTextColor(0.6, 0.8, 1)
			end

			rankIndex = rankIndex + 1
			if C["Tooltip"].HideRank then
				rank = ""
			end

			if guildRealm and isShiftKeyDown then
				guildName = guildName .. "-" .. guildRealm
			end

			if C["Tooltip"].HideJunkGuild and not isShiftKeyDown then
				if strlen(guildName) > 31 then
					guildName = "..."
				end
			end

			GameTooltipTextLeft2:SetText("<" .. guildName .. "> " .. rank .. "(" .. rankIndex .. ")")
		end
	end

	local r, g, b = K.UnitColor(unit)
	local hexColor = K.RGBToHex(r, g, b)
	local text = GameTooltipTextLeft1:GetText()
	if text then
		local ricon = GetRaidTargetIndex(unit)
		if ricon and ricon > 8 then
			ricon = nil
		end

		ricon = ricon and ICON_LIST[ricon] .. "18|t " or ""
		GameTooltipTextLeft1:SetFormattedText("%s%s%s", ricon, hexColor, text)
	end

	local alive = not UnitIsDeadOrGhost(unit)
	local level = UnitLevel(unit)

	if level then
		local boss
		if level == -1 then
			boss = "|cffff0000??|r"
		end

		local diff = GetCreatureDifficultyColor(level)
		local classify = UnitClassification(unit)
		local textLevel = format("%s%s%s|r", K.RGBToHex(diff), boss or format("%d", level), classification[classify] or "")
		local pvpFlag = isPlayer and UnitIsPVP(unit) and format(" |cffff0000%s|r", PVP) or ""
		local unitClass = isPlayer and format("%s %s", UnitRace(unit) or "", hexColor .. (UnitClass(unit) or "") .. "|r") or UnitCreatureType(unit) or ""
		local levelString = format("%s%s %s %s", textLevel, pvpFlag, unitClass, (not alive and "|cffCCCCCC" .. DEAD .. "|r" or ""))

		local tiptextLevel = Module.GetLevelLine(self)
		if tiptextLevel then
			tiptextLevel:SetText(levelString)
		end
	end

	if UnitExists(unit .. "target") then
		local tarRicon = GetRaidTargetIndex(unit .. "target")
		if tarRicon and tarRicon > 8 then
			tarRicon = nil
		end
		local tar = format("%s%s", (tarRicon and ICON_LIST[tarRicon] .. "10|t") or "", Module:GetTarget(unit .. "target"))
		self:AddLine(TARGET .. ": " .. tar)
	end

	if not isPlayer and isShiftKeyDown then
		local guid = UnitGUID(unit)
		local npcID = guid and K.GetNPCID(guid)
		if npcID then
			local reaction = UnitReaction(unit, "player")
			local standingText = reaction and hexColor .. _G["FACTION_STANDING_LABEL" .. reaction]
			self:AddLine(format(npcIDstring, standingText or "", npcID))
		end
	end

	if isPlayer then
		Module.InspectUnitItemLevel(self, unit)
	end

	if self.StatusBar then
		self.StatusBar:SetStatusBarColor(r, g, b)
	end
end

function Module:RefreshStatusBar(value)
	if self:IsForbidden() or not value then
		return
	end

	local min, max = self:GetMinMaxValues()
	if (value < min) or (value > max) then return end

	if not self.text then
		self.text = K.CreateFontString(self, 11, nil, "")
	end

	if value > 0 and max == 1 then
		self.text:SetFormattedText("%d%%", value * 100)
		self:SetStatusBarColor(0.6, 0.6, 0.6) -- Wintergrasp building
	else
		self.text:SetText(K.ShortValue(value) .. " - " .. K.ShortValue(max))
	end
end

function Module:ReskinStatusBar()
	self.StatusBar:ClearAllPoints()
	self.StatusBar:SetPoint("BOTTOMLEFT", self.bg, "TOPLEFT", 0, 6)
	self.StatusBar:SetPoint("BOTTOMRIGHT", self.bg, "TOPRIGHT", -0, 6)
	self.StatusBar:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
	self.StatusBar:SetHeight(12)
	self.StatusBar:CreateBorder()
end

function Module:GameTooltip_ShowStatusBar()
	if not self or self:IsForbidden() then return end
	if not self.statusBarPool then return end

	local bar = self.statusBarPool:GetNextActive()
	if bar and not bar.styled then
		bar:StripTextures()
		bar:CreateBorder()
		bar:SetStatusBarTexture(K.GetTexture(C["General"].Texture))

		bar.styled = true
	end
end

function Module:GameTooltip_ShowProgressBar()
	if not self or self:IsForbidden() then return end
	if not self.progressBarPool then return end

	local bar = self.progressBarPool:GetNextActive()
	if bar and not bar.styled then
		bar.Bar:StripTextures()
		bar.Bar:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
		bar.Bar:CreateBorder()

		bar.styled = true
	end
end

-- Anchor and mover
local cursorIndex = {
	[1] = "ANCHOR_NONE",
	[2] = "ANCHOR_CURSOR_LEFT",
	[3] = "ANCHOR_CURSOR",
	[4] = "ANCHOR_CURSOR_RIGHT",
}
local anchorIndex = {
	[1] = "TOPLEFT",
	[2] = "TOPRIGHT",
	[3] = "BOTTOMLEFT",
	[4] = "BOTTOMRIGHT",
}

local mover
function Module:GameTooltip_SetDefaultAnchor(parent)
	if self:IsForbidden() then return end
	if not parent then return end

	local mode = C["Tooltip"].CursorMode.Value
	self:SetOwner(parent, cursorIndex[mode])
	if mode == 1 then
		if not mover then
			mover = K.Mover(self, "Tooltip", "GameTooltip", { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 75 }, 100, 100)
		end
		self:ClearAllPoints()
		self:SetPoint(anchorIndex[C["Tooltip"].TipAnchor.Value], mover)
	end
end

-- Fix comparison error on cursor
function Module:GameTooltip_ComparisonFix(anchorFrame, shoppingTooltip1, shoppingTooltip2, _, secondaryItemShown)
	local point = shoppingTooltip1:GetPoint(1) -- Check the first point
	if not point then
		return
	end

	if secondaryItemShown then
		if point and point == "TOPLEFT" then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 2, 0)
			shoppingTooltip2:ClearAllPoints()
			shoppingTooltip2:SetPoint("TOPLEFT", shoppingTooltip1, "TOPRIGHT", 2, 0)
		elseif point and point == "TOPRIGHT" then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -2, 0)
			shoppingTooltip2:ClearAllPoints()
			shoppingTooltip2:SetPoint("TOPRIGHT", shoppingTooltip1, "TOPLEFT", -2, 0)
		end
	else
		if point and point == "TOPLEFT" then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 2, 0)
		elseif point and point == "TOPRIGHT" then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -2, 0)
		end
	end
end

-- Tooltip skin
function Module:ReskinTooltip()
	if not self then
		if K.isDeveloper then
			print("Unknown tooltip spotted.")
		end
		return
	end
	if self:IsForbidden() then return end

	if not self.tipStyled then
		self:HideBackdrop()
		self:DisableDrawLayer("BACKGROUND")
		self.bg = CreateFrame("Frame", nil, self)
		self.bg:ClearAllPoints()
		self.bg:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
		self.bg:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)
		self.bg:SetFrameLevel(self:GetFrameLevel())
		self.bg:CreateBorder()

		if self.StatusBar then
			Module.ReskinStatusBar(self)
		end

		self.tipStyled = true
	end

	K.SetBorderColor(self.bg.KKUI_Border)
	if C["Tooltip"].ItemQuality and self.GetItem then
		local _, item = self:GetItem()
		if item then
			local quality = select(3, GetItemInfo(item))
			local color = K.QualityColors[quality or 1]
			if color then
				self.bg.KKUI_Border:SetVertexColor(color.r, color.g, color.b)
			end
		end
	end
end

function Module:FixRecipeItemNameWidth()
	if not self.GetName then
		return
	end

	local name = self:GetName()
	for i = 1, self:NumLines() do
		local line = _G[name .. "TextLeft" .. i]
		if line and line:GetHeight() > 40 then
			line:SetWidth(line:GetWidth() + 2)
		end
	end
end

function Module:ResetUnit(btn)
	if btn == "LSHIFT" and UnitExists("mouseover") then
		GameTooltip:SetUnit("mouseover")
	end
end

function Module:OnEnable()
	if not C["Tooltip"].Enable then return end

	GameTooltip.StatusBar = GameTooltipStatusBar
	GameTooltip:HookScript("OnTooltipCleared", Module.OnTooltipCleared)
	GameTooltip:HookScript("OnTooltipSetUnit", Module.OnTooltipSetUnit)
	GameTooltip.StatusBar:SetScript("OnValueChanged", Module.RefreshStatusBar)
	hooksecurefunc("GameTooltip_ShowStatusBar", Module.GameTooltip_ShowStatusBar)
	hooksecurefunc("GameTooltip_ShowProgressBar", Module.GameTooltip_ShowProgressBar)
	hooksecurefunc("GameTooltip_SetDefaultAnchor", Module.GameTooltip_SetDefaultAnchor)
	hooksecurefunc("GameTooltip_AnchorComparisonTooltips", Module.GameTooltip_ComparisonFix)

	GameTooltip:HookScript("OnTooltipSetItem", Module.FixRecipeItemNameWidth)
	ItemRefTooltip:HookScript("OnTooltipSetItem", Module.FixRecipeItemNameWidth)
	EmbeddedItemTooltip:HookScript("OnTooltipSetItem", Module.FixRecipeItemNameWidth)

	-- Elements
	local loadTooltipModules = {
		"CreateTooltipID",
		"CreateTooltipIcons",
		"CreateTargetedInfo",
	}

	for _, funcName in ipairs(loadTooltipModules) do
		local func = self[funcName]
		if type(func) == "function" then
			local success, err = pcall(func, self)
			if not success then
				error("Error in function " .. funcName .. ": " .. tostring(err), 2)
			end
		end
	end
	K:RegisterEvent("MODIFIER_STATE_CHANGED", Module.ResetUnit)
end

-- Tooltip Skin Registration
local tipTable = {}
function Module:RegisterTooltips(addon, func)
	tipTable[addon] = func
end
local function addonStyled(_, addon)
	if tipTable[addon] then
		tipTable[addon]()
		tipTable[addon] = nil
	end
end
K:RegisterEvent("ADDON_LOADED", addonStyled)

Module:RegisterTooltips("KkthnxUI", function()
	local tooltips = {
		_G.ChatMenu,
		_G.EmoteMenu,
		_G.LanguageMenu,
		_G.VoiceMacroMenu,
		_G.GameTooltip,
		_G.EmbeddedItemTooltip,
		_G.ItemRefTooltip,
		_G.ItemRefShoppingTooltip1,
		_G.ItemRefShoppingTooltip2,
		_G.ShoppingTooltip1,
		_G.ShoppingTooltip2,
		_G.AutoCompleteBox,
		_G.FriendsTooltip,
		_G.GeneralDockManagerOverflowButtonList,
		_G.NamePlateTooltip,
		_G.WorldMapTooltip,
		_G.IMECandidatesFrame,
		_G.QueueStatusFrame,
	}
	for _, f in pairs(tooltips) do
		f:HookScript("OnShow", Module.ReskinTooltip)
	end

	_G.ItemRefCloseButton:SkinCloseButton()

	-- DropdownMenu
	local dropdowns = { "DropDownList", "L_DropDownList", "Lib_DropDownList" }
	local function reskinDropdown()
		for _, name in pairs(dropdowns) do
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G[name .. i .. "MenuBackdrop"]
				if menu and not menu.styled then
					menu:HookScript("OnShow", Module.ReskinTooltip)
					menu.styled = true
				end
			end
		end
	end
	hooksecurefunc("UIDropDownMenu_CreateFrames", reskinDropdown)

	-- IME
	local r, g, b = K.r, K.g, K.b
	IMECandidatesFrame.selection:SetVertexColor(r, g, b)

	-- Others
	K.Delay(6, function()
		-- Lib minimap icon
		if LibDBIconTooltip then
			Module.ReskinTooltip(LibDBIconTooltip)
		end
		-- TomTom
		if TomTomTooltip then
			Module.ReskinTooltip(TomTomTooltip)
		end
		-- RareScanner
		if RSMapItemToolTip then
			Module.ReskinTooltip(RSMapItemToolTip)
		end
		if LootBarToolTip then
			Module.ReskinTooltip(LootBarToolTip)
		end
		-- Altoholic
		if AltoTooltip then
			Module.ReskinTooltip(AltoTooltip)
		end
	end)
end)

Module:RegisterTooltips("Blizzard_DebugTools", function()
	Module.ReskinTooltip(FrameStackTooltip)
	FrameStackTooltip:SetScale(UIParent:GetScale())
end)

Module:RegisterTooltips("Blizzard_EventTrace", function()
	Module.ReskinTooltip(EventTraceTooltip)
end)

Module:RegisterTooltips("Blizzard_LookingForGroupUI", function()
	Module.ReskinTooltip(LFGBrowseSearchEntryTooltip)
end)