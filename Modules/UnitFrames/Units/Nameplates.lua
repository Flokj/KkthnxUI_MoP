local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Unitframes")

-- Lua functions
local math_rad = math.rad
local floor = math.floor
local pairs = pairs
local ipairs = ipairs
local string_format = string.format
local strmatch = string.match
local table_wipe = table.wipe
local tonumber = tonumber
local unpack = unpack

-- WoW API
local Ambiguate = Ambiguate
local GetCVar = GetCVar
local GetCVarBool = GetCVarBool
local IsInInstance = IsInInstance
local UnitCanAttack = UnitCanAttack
local C_NamePlate_GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local C_NamePlate_GetNamePlates = C_NamePlate.GetNamePlates
local CreateFrame = CreateFrame
local GetNumGroupMembers = GetNumGroupMembers
local GetNumSubgroupMembers = GetNumSubgroupMembers
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local INTERRUPTED = INTERRUPTED
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local SetCVar = SetCVar
local UnitClassification = UnitClassification
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsConnected = UnitIsConnected
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName
local UnitNameplateShowsWidgetsOnly = UnitNameplateShowsWidgetsOnly
local UnitPlayerControlled = UnitPlayerControlled
local UnitReaction = UnitReaction
local UnitThreatSituation = UnitThreatSituation
local hooksecurefunc = hooksecurefunc
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax

-- Custom data
local customUnits = {} -- Custom unit data
local groupRoles = {} -- Group roles for players
local showPowerList = {} -- List of players who have their power displayed
local isInGroup = false -- Boolean to track if the player is in a group
local isInInstance = false -- Boolean to track if the player is in an instance

-- Unit classification
local NPClassifies = {
	elite = { 1, 1, 1 },
	rare = { 1, 1, 1, true },
	rareelite = { 1, 0.1, 0.1 },
	worldboss = { 0, 1, 0 },
}

-- Init
function Module:UpdatePlateCVars()
	if InCombatLockdown() then
		return
	end

	local curTop, curBottom = GetCVar("nameplateOtherTopInset"), GetCVar("nameplateOtherBottomInset")
	if C["Nameplate"].InsideView then
		if curTop ~= "0.10" then
			SetCVar("nameplateOtherTopInset", 0.10)
		end
		if curBottom ~= "0.12" then
			SetCVar("nameplateOtherBottomInset", 0.12)
		end
	else
		if curTop == "0.12" then
			SetCVar("nameplateOtherTopInset", -1)
		end
		if curBottom == "0.12" then
			SetCVar("nameplateOtherBottomInset", -1)
		end
	end

	local settings = {
		namePlateMinScale = C["Nameplate"].MinScale,
		namePlateMaxScale = C["Nameplate"].MinScale,
		nameplateMinAlpha = C["Nameplate"].MinAlpha,
		nameplateMaxAlpha = C["Nameplate"].MinAlpha,
		nameplateOverlapV = C["Nameplate"].VerticalSpacing,
		nameplateNotSelectedAlpha = 1,
		nameplateShowOnlyNames =  0,
		nameplateShowFriendlyNPCs = 1,
		ClampTargetNameplateToScreen = 1,
	}

	for cvar, value in pairs(settings) do
		local cur = GetCVar(cvar)
		local want = tostring(value)
		if cur ~= want then
			SetCVar(cvar, value)
		end
	end
end

function Module:UpdateClickableSize()
	if InCombatLockdown() then
		return
	end

	local hitInset = 10000 -- some large number that will ensure we have full coverage
	local enemyInset = C["Nameplate"].EnemyThru and hitInset or -hitInset
	C_NamePlateManager.SetNamePlateHitTestInsets(Enum.NamePlateType.Enemy, enemyInset, enemyInset, enemyInset, enemyInset)
	local friendlyInset = C["Nameplate"].FriendlyThru and hitInset or -hitInset
	C_NamePlateManager.SetNamePlateHitTestInsets(Enum.NamePlateType.Friendly, friendlyInset, friendlyInset, friendlyInset, friendlyInset)

end

function Module:SetupCVars()
	Module:UpdatePlateCVars()
	local settings = {
		nameplateOverlapH = 0.8,
		nameplateSelectedAlpha = 1,
		nameplateSelectedScale = C["Nameplate"].SelectedScale,
		nameplateLargerScale = 1,
		nameplateGlobalScale = 1,
		nameplateMaxDistance = C["Nameplate"].Distance,
	}

	for cvar, value in pairs(settings) do
		local cur = GetCVar(cvar)
		local want = tostring(value)
		if cur ~= want then
			SetCVar(cvar, value)
		end
	end

	Module:UpdateClickableSize()
end

function Module:CreateUnitTable()
	table_wipe(customUnits)
	if not C["Nameplate"].CustomUnitColor then
		return
	end

	K.CopyTable(C.NameplateCustomUnits, customUnits)
	K.SplitList(customUnits, C["Nameplate"].CustomUnitList)
end

function Module:CreatePowerUnitTable()
	table_wipe(showPowerList)
	K.CopyTable(C.NameplateShowPowerList, showPowerList)
	K.SplitList(showPowerList, C["Nameplate"].PowerUnitList)
end

function Module:UpdateUnitPower()
	local unitName = self.unitName
	local npcID = self.npcID
	local shouldShowPower = showPowerList[unitName] or showPowerList[npcID]
	self.powerText:SetShown(shouldShowPower)
end

-- Off-tank threat color
-- Function to refresh the group roles
local function refreshGroupRoles()
	-- Check if player is in raid or group
	local isInRaid = IsInRaid()
	isInGroup = isInRaid or IsInGroup()

	-- Wipe the groupRoles table
	table_wipe(groupRoles)

	-- If player is in group
	if isInGroup then
		-- Get the number of players in group
		local numPlayers = (isInRaid and GetNumGroupMembers()) or GetNumSubgroupMembers()

		-- Define the unit prefix (raid or party)
		local unit = (isInRaid and "raid") or "party"

		-- Loop through each player in the group
		for i = 1, numPlayers do
			-- Define the unit index (e.g. raid1, party2)
			local index = unit .. i

			-- If the unit exists, add their name and role to the groupRoles table
			if UnitExists(index) then
				groupRoles[UnitName(index)] = UnitGroupRolesAssigned(index)
			end
		end
	end
end

local function resetGroupRoles()
	isInGroup = IsInRaid() or IsInGroup()
	table_wipe(groupRoles)
end

function Module:UpdateGroupRoles()
	refreshGroupRoles()

	-- Unregister existing events first to prevent duplicates
	K:UnregisterEvent("GROUP_ROSTER_UPDATE", refreshGroupRoles)
	K:UnregisterEvent("GROUP_LEFT", resetGroupRoles)

	-- Register events
	K:RegisterEvent("GROUP_ROSTER_UPDATE", refreshGroupRoles)
	K:RegisterEvent("GROUP_LEFT", resetGroupRoles)
end

function Module:CheckThreatStatus(unit)
	if not UnitExists(unit) then
		return
	end

	local unitTarget = unit .. "target"
	local unitRole = isInGroup and UnitExists(unitTarget) and not UnitIsUnit(unitTarget, "player") and groupRoles[UnitName(unitTarget)] or "NONE"

	if K.Role == "Tank" and unitRole == "TANK" then
		return true, UnitThreatSituation(unitTarget, unit)
	else
		return false, UnitThreatSituation("player", unit)
	end
end

-- Update unit color
function Module:UpdateColor(_, unit)
	if not unit or self.unit ~= unit then
		return
	end

	local element = self.Health
	local name = self.unitName
	local npcID = self.npcID
	local isCustomUnit = customUnits[name] or customUnits[npcID]
	local isPlayer = self.isPlayer
	local isFriendly = self.isFriendly
	local isOffTank, status = Module:CheckThreatStatus(unit)

	local customColor = C["Nameplate"].CustomColor
	local targetColor = C["Nameplate"].TargetColor
	local insecureColor = C["Nameplate"].InsecureColor
	local offTankColor = C["Nameplate"].OffTankColor
	local revertThreat = C["Nameplate"].DPSRevertThreat
	local secureColor = C["Nameplate"].SecureColor
	local transColor = C["Nameplate"].TransColor
	local dotColor = C["Nameplate"].DotColor

	local executeRatio = C["Nameplate"].ExecuteRatio
	local healthPerc = UnitHealth(unit) / (UnitHealthMax(unit) + 0.0001) * 100

	local r, g, b
	if not UnitIsConnected(unit) then
		r, g, b = 0.7, 0.7, 0.7
	else
		if C["Nameplate"].ColoredTarget and UnitIsUnit(unit, "target") then
			r, g, b = targetColor[1], targetColor[2], targetColor[3]
		elseif isCustomUnit then
			r, g, b = customColor[1], customColor[2], customColor[3]
		elseif self.Auras.hasTheDot then
			r, g, b = dotColor[1], dotColor[2], dotColor[3]
		elseif isPlayer and isFriendly then
			if C["Nameplate"].FriendlyCC then
				local ur, ug, ub = K.UnitColor(unit)
				r, g, b = ur, ug, ub
			else
				r, g, b = K.Colors.power["MANA"][1], K.Colors.power["MANA"][2], K.Colors.power["MANA"][3]
			end
		elseif isPlayer and not isFriendly and C["Nameplate"].HostileCC then
			local ur, ug, ub = K.UnitColor(unit)
			r, g, b = ur, ug, ub
		elseif UnitIsTapDenied(unit) and not UnitPlayerControlled(unit) or C.NameplateTrashUnits[npcID] then
			r, g, b = 0.6, 0.6, 0.6
		else
			r, g, b = K.UnitColor(unit)
			if status and (C["Nameplate"].TankMode or K.Role == "Tank") then
				if status == 3 then
					if K.Role ~= "Tank" and revertThreat then
						r, g, b = insecureColor[1], insecureColor[2], insecureColor[3]
					else
						if isOffTank then
							r, g, b = offTankColor[1], offTankColor[2], offTankColor[3]
						else
							r, g, b = secureColor[1], secureColor[2], secureColor[3]
						end
					end
				elseif status == 2 or status == 1 then
					r, g, b = transColor[1], transColor[2], transColor[3]
				elseif status == 0 then
					if K.Role ~= "Tank" and revertThreat then
						r, g, b = secureColor[1], secureColor[2], secureColor[3]
					else
						r, g, b = insecureColor[1], insecureColor[2], insecureColor[3]
					end
				end
			end
		end
	end

	if r or g or b then
		element:SetStatusBarColor(r, g, b)
	end

	self.ThreatIndicator:Hide()
	if status and (isCustomUnit or (not C["Nameplate"].TankMode and K.Role ~= "Tank")) then
		if status == 3 then
			self.ThreatIndicator:SetBackdropBorderColor(1, 0, 0)
			self.ThreatIndicator:Show()
		elseif status == 2 or status == 1 then
			self.ThreatIndicator:SetBackdropBorderColor(1, 1, 0)
			self.ThreatIndicator:Show()
		end
	end

	local useExecuteColor = executeRatio > 0 and healthPerc <= executeRatio
	if useExecuteColor ~= self._lastExecuteColor then
		self._lastExecuteColor = useExecuteColor
		if useExecuteColor then
			self.nameText:SetTextColor(1, 0, 0)
		else
			self.nameText:SetTextColor(1, 1, 1)
		end
	end
end

function Module:UpdateThreatColor(_, unit)
	if unit ~= self.unit then
		return
	end

	Module.UpdateColor(self, _, unit)
end

-- Backdrop shadow
function Module:CreateThreatColor(self)
	local threatIndicator = self:CreateShadow()
	threatIndicator:SetPoint("TOPLEFT", self.Health.backdrop, "TOPLEFT", -1, 1)
	threatIndicator:SetPoint("BOTTOMRIGHT", self.Health.backdrop, "BOTTOMRIGHT", 1, -1)
	threatIndicator:Hide()

	self.ThreatIndicator = threatIndicator
	self.ThreatIndicator.Override = Module.UpdateThreatColor
end

-- Target indicator
function Module:UpdateTargetChange()
	local element = self.TargetIndicator
	local unit = self.unit

	if C["Nameplate"].TargetIndicator ~= 1 then
		local isTarget = UnitIsUnit(unit, "target") and not UnitIsUnit(unit, "player")
		element:SetShown(isTarget)

		local shouldPlayAnim = isTarget and not element.TopArrowAnim:IsPlaying()
		local shouldStopAnim = not isTarget and element.TopArrowAnim:IsPlaying()

		if shouldPlayAnim then
			element.TopArrowAnim:Play()
		elseif shouldStopAnim then
			element.TopArrowAnim:Stop()
		end
	end

	if C["Nameplate"].ColoredTarget then
		Module.UpdateThreatColor(self, _, unit)
	end
end

function Module:UpdateTargetIndicator()
	local style = C["Nameplate"].TargetIndicator
	local element = self.TargetIndicator
	local isNameOnly = self.plateType == "NameOnly"

	if style == 1 then
		element:Hide()
		return
	end

	local showTopArrow = style == 2 or style == 5
	local showRightArrow = style == 3 or style == 6
	local showGlow = (style == 4 or style == 5 or style == 6) and not isNameOnly
	local showNameGlow = (style == 4 or style == 5 or style == 6) and isNameOnly

	element.TopArrow:SetShown(showTopArrow)
	element.RightArrow:SetShown(showRightArrow)
	element.Glow:SetShown(showGlow)
	element.nameGlow:SetShown(showNameGlow)
	element:Show()
end

local points = { -15, -5, 0, 5, 0 }

function Module:AddTargetIndicator(self)
	local TargetIndicator = CreateFrame("Frame", nil, self)
	TargetIndicator:SetAllPoints()
	TargetIndicator:SetFrameLevel(0)
	TargetIndicator:Hide()

	-- Function to create and configure arrows
	local function CreateArrow(parent, point, x, y, rotation)
		local arrow = parent:CreateTexture(nil, "BACKGROUND", nil, -5)
		arrow:SetSize(64, 64) -- 128 / 2 simplified
		arrow:SetTexture(C["Nameplate"].TargetIndicatorTexture)
		arrow:SetPoint(point, parent, point, x, y)
		if rotation then
			arrow:SetRotation(rotation)
		end
		return arrow
	end

	-- Top arrow
	TargetIndicator.TopArrow = CreateArrow(TargetIndicator, "BOTTOM", 0, 40)
	local animGroup = TargetIndicator.TopArrow:CreateAnimationGroup()
	animGroup:SetLooping("REPEAT")
	local anim = animGroup:CreateAnimation("Path")
	anim:SetDuration(1)

	for i, offset in ipairs(points) do
		local point = anim:CreateControlPoint()
		point:SetOrder(i)
		point:SetOffset(0, offset)
	end

	TargetIndicator.TopArrowAnim = animGroup

	-- Right arrow
	TargetIndicator.RightArrow = CreateArrow(TargetIndicator, "LEFT", 3, 0, math_rad(-90))

	-- Glow
	TargetIndicator.Glow = CreateFrame("Frame", nil, TargetIndicator, "BackdropTemplate")
	TargetIndicator.Glow:SetPoint("TOPLEFT", self.Health.backdrop, -2, 2)
	TargetIndicator.Glow:SetPoint("BOTTOMRIGHT", self.Health.backdrop, 2, -2)
	TargetIndicator.Glow:SetBackdrop({ edgeFile = C["Media"].Textures.GlowTexture, edgeSize = 4 })
	TargetIndicator.Glow:SetBackdropBorderColor(unpack(C["Nameplate"].TargetIndicatorColor))
	TargetIndicator.Glow:SetFrameLevel(0)

	-- Name glow
	TargetIndicator.nameGlow = TargetIndicator:CreateTexture(nil, "BACKGROUND", nil, -5)
	TargetIndicator.nameGlow:SetSize(150, 80)
	TargetIndicator.nameGlow:SetTexture("Interface\\GLUES\\Models\\UI_Draenei\\GenericGlow64")
	TargetIndicator.nameGlow:SetVertexColor(102 / 255, 157 / 255, 255 / 255)
	TargetIndicator.nameGlow:SetBlendMode("ADD")
	TargetIndicator.nameGlow:SetPoint("CENTER", self, "BOTTOM")

	self.TargetIndicator = TargetIndicator
	self:RegisterEvent("PLAYER_TARGET_CHANGED", Module.UpdateTargetChange, true)
	Module.UpdateTargetIndicator(self)
end

local isInInstance
local function CheckInstanceStatus()
	isInInstance = IsInInstance()
end

function Module:QuestIconCheck()
	CheckInstanceStatus()
	K:RegisterEvent("PLAYER_ENTERING_WORLD", CheckInstanceStatus)
end

function Module:UpdateQuestUnit(_, unit)
	if not C["Nameplate"].QuestIndicator then
		return
	end

	if isInInstance then
		self.questIcon:Hide()
		self.questCount:SetText("")
		return
	end

	unit = unit or self.unit

	local isLootQuest, questProgress
	K.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	K.ScanTooltip:SetUnit(unit)

	for i = 2, K.ScanTooltip:NumLines() do
		local textLine = _G["KKUI_ScanTooltipTextLeft"..i]
		local text = textLine:GetText()
		if textLine and text then
			local r, g, b = textLine:GetTextColor()
			local unitName, progressText = strmatch(text, "^ ([^ ]-) ?%- (.+)$")
			if r > 0.99 and g > 0.82 and b == 0 then
				isLootQuest = true
			elseif unitName and progressText then
				isLootQuest = false
				if unitName == "" or unitName == DB.MyName then
					local current, goal = strmatch(progressText, "(%d+)/(%d+)")
					local progress = strmatch(progressText, "([%d%.]+)%%")
					if current and goal then
						if tonumber(current) < tonumber(goal) then
							questProgress = goal - current
							break
						end
					elseif progress then
						progress = tonumber(progress)
						if progress and progress < 100 then
							questProgress = progress.."%"
							break
						end
					else
						isLootQuest = true
						break
					end
				end
			end
		end
	end

	if questProgress then
		self.questCount:SetText(questProgress)
		self.questIcon:SetAtlas("UI-HUD-MicroMenu-Questlog-Up")
		self.questIcon:Show()
	else
		self.questCount:SetText("")
		if isLootQuest then
			self.questIcon:SetAtlas("adventureguide-microbutton-alert")
			self.questIcon:Show()
		else
			self.questIcon:Hide()
		end
	end
end

function Module:AddQuestIcon(self)
	if not C["Nameplate"].QuestIndicator then
		return
	end

	local qicon = self:CreateTexture(nil, "OVERLAY", nil, 2)
	qicon:SetPoint("LEFT", self, "RIGHT", 4, 0)
	qicon:SetSize(32, 32)
	qicon:SetAtlas("adventureguide-microbutton-alert")
	qicon:Hide()

	local count = K.CreateFontString(self, 20, "", nil, "LEFT", 0, 0)
	count:SetPoint("LEFT", qicon, "RIGHT", -4, 0)
	count:SetTextColor(0.6, 0.8, 1)

	self.questIcon = qicon
	self.questCount = count
	self:RegisterEvent("QUEST_LOG_UPDATE", Module.UpdateQuestUnit, true)
	self:RegisterEvent("UNIT_NAME_UPDATE", Module.UpdateQuestUnit, true)
end

function Module:AddClassIcon(self)
	if not C["Nameplate"].ClassIcon then
		return
	end

	self.Class = CreateFrame("Frame", nil, self)
	self.Class:SetSize(self:GetHeight() * 2 + 3, self:GetHeight() * 2 + 3)
	self.Class:SetPoint("BOTTOMLEFT", self.Castbar, "BOTTOMRIGHT", 3, 0)
	self.Class:CreateShadow(true)

	self.Class.Icon = self.Class:CreateTexture(nil, "OVERLAY")
	self.Class.Icon:SetAllPoints()
	self.Class.Icon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
	self.Class.Icon:SetTexCoord(0, 0, 0, 0)
end

function Module:UpdateClassIcon(self, unit)
	if not C["Nameplate"].ClassIcon then
		return
	end

	local reaction = UnitReaction(unit, "player")
	if UnitIsPlayer(unit) and (reaction and reaction <= 4) then
		local _, class = UnitClass(unit)

		if class and CLASS_ICON_TCOORDS[class] then
			local texcoord = CLASS_ICON_TCOORDS[class]
			self.Class.Icon:SetTexCoord(texcoord[1] + 0.015, texcoord[2] - 0.02, texcoord[3] + 0.018, texcoord[4] - 0.02)
			self.Class:Show()
		else
			self.Class.Icon:SetTexCoord(0, 0, 0, 0)
			self.Class:Hide()
		end
	else
		self.Class.Icon:SetTexCoord(0, 0, 0, 0)
		self.Class:Hide()
	end
end

function Module:AddCreatureIcon(self)
	local ClassifyIndicator = self:CreateTexture(nil, "ARTWORK")
	ClassifyIndicator:SetTexture(K.MediaFolder .. "Nameplates\\star")
	ClassifyIndicator:SetPoint("RIGHT", self.nameText, "LEFT")
	ClassifyIndicator:SetSize(16, 16)
	ClassifyIndicator:Hide()

	self.ClassifyIndicator = ClassifyIndicator
end

function Module:UpdateUnitClassify(unit)
	if not self.ClassifyIndicator then
		return
	end

	if not unit then
		unit = self.unit
	end

	self.ClassifyIndicator:Hide()

	local class = UnitClassification(unit)
	local classify = class and NPClassifies[class]
	if classify then
		local r, g, b, desature = unpack(classify)
		self.ClassifyIndicator:SetVertexColor(r, g, b)
		self.ClassifyIndicator:SetDesaturated(desature)
		self.ClassifyIndicator:Show()
	end
end

-- Mouseover indicator
function Module:IsMouseoverUnit()
	if not self or not self.unit then
		return
	end

	if self:IsVisible() and UnitExists("mouseover") then
		return UnitIsUnit("mouseover", self.unit)
	end

	return false
end

function Module:UpdateMouseoverShown()
	if not self or not self.unit then
		return
	end

	if self:IsShown() and UnitIsUnit("mouseover", self.unit) then
		self.HighlightIndicator:Show()
		self.HighlightUpdater:Show()
	else
		self.HighlightUpdater:Hide()
	end
end

function Module:HighlightOnUpdate(elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.1 then
		if not Module.IsMouseoverUnit(self.__owner) then
			self:Hide()
		end
		self.elapsed = 0
	end
end

function Module:HighlightOnHide()
	self.__owner.HighlightIndicator:Hide()
end

function Module:MouseoverIndicator(self)
	local highlight = CreateFrame("Frame", nil, self.Health)
	highlight:SetAllPoints(self)
	highlight:Hide()

	local texture = highlight:CreateTexture(nil, "ARTWORK")
	texture:SetAllPoints()
	texture:SetColorTexture(1, 1, 1, 0.25)

	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", Module.UpdateMouseoverShown, true)

	local updater = CreateFrame("Frame", nil, self)
	updater.__owner = self
	updater:SetScript("OnUpdate", Module.HighlightOnUpdate)
	updater:HookScript("OnHide", Module.HighlightOnHide)

	self.HighlightIndicator = highlight
	self.HighlightUpdater = updater
end

-- Interrupt info on castbars
function Module:UpdateSpellInterruptor(...)
	local _, _, sourceGUID, sourceName, _, _, destGUID = ...
	if destGUID == self.unitGUID and sourceGUID and sourceName and sourceName ~= "" then
		local _, class = GetPlayerInfoByGUID(sourceGUID)
		local r, g, b = K.ColorClass(class)
		local color = K.RGBToHex(r, g, b)
		local sourceName = Ambiguate(sourceName, "short")
		self.Castbar.Text:SetText(INTERRUPTED .. " > " .. color .. sourceName)
		self.Castbar.Time:SetText("")
	end
end

function Module:SpellInterruptor(self)
	if not self.Castbar then
		return
	end

	self:RegisterCombatEvent("SPELL_INTERRUPT", Module.UpdateSpellInterruptor)
end

local function updateSpellTarget(self, _, unit)
	Module.PostCastUpdate(self.Castbar, unit)
end

-- Create Nameplates
local platesList = {}
function Module:CreatePlates()
	self.mystyle = "nameplate"

	self:SetSize(C["Nameplate"].PlateWidth, C["Nameplate"].PlateHeight)
	self:SetPoint("CENTER")
	--self:SetScale(C["General"].UIScale)

	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetAllPoints()
	self.Health:SetStatusBarTexture(K.GetTexture(C["General"].Texture))

	self.Overlay = CreateFrame("Frame", nil, self) -- We will use this to overlay onto our special borders.
	self.Overlay:SetAllPoints(self.Health)
	self.Overlay:SetFrameLevel(4)

	self.Health.backdrop = self.Health:CreateShadow(true) -- don't mess up with libs
	self.Health.backdrop:SetPoint("TOPLEFT", self.Health, "TOPLEFT", -3, 3)
	self.Health.backdrop:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", 3, -3)
	self.Health.backdrop:SetFrameLevel(self.Health:GetFrameLevel())

	self.Health.frequentUpdates = true
	self.Health.UpdateColor = Module.UpdateColor

	if C["Nameplate"].Smooth then
		K:SmoothBar(self.Health)
	end

	self.nameText = K.CreateFontString(self, C["Nameplate"].NameTextSize, "", "", false)
	self.nameText:SetJustifyH("CENTER")
	self.nameText:ClearAllPoints()
	self.nameText:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -3, 4)
	self.nameText:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -3, 4)

	self.npcTitle = K.CreateFontString(self, C["Nameplate"].NameTextSize - 1)
	self.npcTitle:ClearAllPoints()
	self.npcTitle:SetPoint("TOP", self.nameText, "BOTTOM", 0, -4)
	self.npcTitle:Hide()
	self:Tag(self.npcTitle, "[npctitle]")

	self.tarName = K.CreateFontString(self, C["Nameplate"].NameTextSize + 2)
	self.tarName:ClearAllPoints()
	self.tarName:SetPoint("TOP", self, "BOTTOM", 0, -10)
	self.tarName:Hide()
	self:Tag(self.tarName, "[tarname]")

	self.healthValue = K.CreateFontString(self.Overlay, C["Nameplate"].HealthTextSize, "", "", false, "CENTER", 0, 0)
	self.healthValue:SetPoint("CENTER", self.Overlay, 0, 0)
	self:Tag(self.healthValue, "[nphp]")

	self.Castbar = CreateFrame("StatusBar", "oUF_CastbarNameplate", self)
	self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -3)
	self.Castbar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -3)
	self.Castbar:SetHeight(self:GetHeight())
	self.Castbar:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
	self.Castbar:SetFrameLevel(10)
	self.Castbar:CreateShadow(true)
	self.Castbar.castTicks = {}

	self.Castbar.Spark = self.Castbar:CreateTexture(nil, "OVERLAY", nil, 2)
	self.Castbar.Spark:SetSize(64, self.Castbar:GetHeight() - 2)
	self.Castbar.Spark:SetTexture(C["Media"].Textures.Spark128Texture)
	self.Castbar.Spark:SetBlendMode("ADD")
	self.Castbar.Spark:SetAlpha(0.8)

	self.Castbar.Time = K.CreateFontString(self.Castbar, 12, "", "", false, "RIGHT", 0, -1)
	self.Castbar.Text = K.CreateFontString(self.Castbar, 12, "", "", false, "LEFT", 0, -1)
	self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time, "LEFT", -5, 0)
	self.Castbar.Text:SetJustifyH("LEFT")

	self.Castbar.Icon = self.Castbar:CreateTexture(nil, "ARTWORK")
	self.Castbar.Icon:SetSize(self:GetHeight() * 2 + 5, self:GetHeight() * 2 + 5)
	self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar, "BOTTOMLEFT", -3, 0)
	self.Castbar.Icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])

	self.Castbar.Button = CreateFrame("Frame", nil, self.Castbar)
	self.Castbar.Button:CreateShadow(true)
	self.Castbar.Button:SetAllPoints(self.Castbar.Icon)
	self.Castbar.Button:SetFrameLevel(self.Castbar:GetFrameLevel())

	self.Castbar.glowFrame = CreateFrame("Frame", nil, self.Castbar)
	self.Castbar.glowFrame:SetPoint("CENTER", self.Castbar.Icon)
	self.Castbar.glowFrame:SetSize(self:GetHeight() * 2 + 5, self:GetHeight() * 2 + 5)

	self.Castbar.spellTarget = K.CreateFontString(self.Castbar, C["Nameplate"].NameTextSize + 2)
	self.Castbar.spellTarget:ClearAllPoints()
	self.Castbar.spellTarget:SetJustifyH("LEFT")
	self.Castbar.spellTarget:SetPoint("TOPLEFT", self.Castbar.Text, "BOTTOMLEFT", 0, -6)
	self:RegisterEvent("UNIT_TARGET", updateSpellTarget)

	self.Castbar.timeToHold = 0.5
	self.Castbar.decimal = "%.1f"
	self.Castbar.OnUpdate = Module.OnCastbarUpdate
	self.Castbar.PostCastStart = Module.PostCastStart
	self.Castbar.PostCastUpdate = Module.PostCastUpdate
	self.Castbar.PostCastStop = Module.PostCastStop
	self.Castbar.PostCastFail = Module.PostCastFailed
	self.Castbar.PostCastInterruptible = Module.PostUpdateInterruptible

	self.RaidTargetIndicator = self:CreateTexture(nil, "OVERLAY")
	self.RaidTargetIndicator:SetPoint("TOPRIGHT", self, "TOPLEFT", -8, 25)
	self.RaidTargetIndicator:SetSize(40, 40)

	self.Auras = CreateFrame("Frame", nil, self)
	self.Auras:SetFrameLevel(self:GetFrameLevel() + 2)
	self.Auras.spacing = 8
	self.Auras.initdialAnchor = "BOTTOMLEFT"
	self.Auras["growth-y"] = "UP"
	if C["Nameplate"].NameplateClassPower then
		self.Auras:SetPoint("BOTTOMLEFT", self.nameText, "TOPLEFT", 0, 6 + C["Nameplate"].PlateHeight)
		self.Auras:SetPoint("BOTTOMRIGHT", self.nameText, "TOPRIGHT", 0, 6 + C["Nameplate"].PlateHeight)
	else
		self.Auras:SetPoint("BOTTOMLEFT", self.nameText, "TOPLEFT", 0, 6)
		self.Auras:SetPoint("BOTTOMRIGHT", self.nameText, "TOPRIGHT", 0, 6)
	end
	self.Auras.numTotal = C["Nameplate"].MaxAuras
	self.Auras.size = C["Nameplate"].AuraSize
	self.Auras.gap = false
	self.Auras.disableMouse = true
	self.Auras.CustomFilter = Module.CustomFilter

	Module:UpdateAuraContainer(self:GetWidth(), self.Auras, self.Auras.numTotal)

	self.Auras.showStealableBuffs = true
	self.Auras.PostCreateIcon = Module.PostCreateIcon
	self.Auras.PostUpdateIcon = Module.PostUpdateIcon
	self.Auras.PostUpdateInfo = Module.AurasPostUpdateInfo

	Module:CreateThreatColor(self)

	self.PvPClassificationIndicator = self:CreateTexture(nil, "ARTWORK")
	self.PvPClassificationIndicator:SetSize(18, 18)
	self.PvPClassificationIndicator:ClearAllPoints()
	if C["Nameplate"].ClassIcon then
		self.PvPClassificationIndicator:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, 20)
	else
		self.PvPClassificationIndicator:SetPoint("LEFT", self, "RIGHT", 6, 0)
	end

	self.powerText = K.CreateFontString(self, 15)
	self.powerText:ClearAllPoints()
	self.powerText:SetPoint("TOP", self.Castbar, "BOTTOM", 0, -4)
	self:Tag(self.powerText, "[nppp]")

	Module:MouseoverIndicator(self)
	Module:AddTargetIndicator(self)
	Module:AddCreatureIcon(self)
	Module:AddQuestIcon(self)
	Module:SpellInterruptor(self)
	Module:AddClassIcon(self)

	platesList[self] = self:GetName()
end

function Module:ToggleNameplateAuras()
	if C["Nameplate"].PlateAuras then
		if not self:IsElementEnabled("Auras") then
			self:EnableElement("Auras")
		end
	else
		if self:IsElementEnabled("Auras") then
			self:DisableElement("Auras")
		end
	end
end

function Module:UpdateNameplateAuras()
	Module.ToggleNameplateAuras(self)

	if not C["Nameplate"].PlateAuras then
		return
	end

	local element = self.Auras
	if C["Nameplate"].NameplateClassPower then
		element:SetPoint("BOTTOMLEFT", self.nameText, "TOPLEFT", 0, 6 + C["Nameplate"].PlateHeight)
	else
		element:SetPoint("BOTTOMLEFT", self.nameText, "TOPLEFT", 0, 5)
	end

	element.numTotal = C["Nameplate"].MaxAuras
	element.size = C["Nameplate"].AuraSize
	element.showDebuffType = true
	element:SetWidth(self:GetWidth())
	element:SetHeight((element.size + element.spacing) * 2)

	element:ForceUpdate()
end

function Module:UpdateNameplateSize()
	if self.plateType == "NameOnly" then
		self:Tag(self.nameText, "[nprare][color][name] [nplevel]")
		self.npcTitle:UpdateTag()
	else
		self.nameText:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
		self.nameText:SetPoint("BOTTOMRIGHT", self.levelText, "TOPRIGHT", -21, 4)
		self:Tag(self.nameText, "[nprare][name]")
		self.healthValue:UpdateTag()

		self:SetSize(C["Nameplate"].PlateWidth, C["Nameplate"].PlateHeight)
	end

	self.nameText:UpdateTag()
end

function Module:RefreshNameplats()
	for nameplate in pairs(platesList) do
		--Module.UpdateNameplateSize(nameplate)
		Module.UpdateUnitClassify(nameplate)
		Module.UpdateNameplateAuras(nameplate)
		Module.UpdateTargetIndicator(nameplate)
		Module.UpdateTargetChange(nameplate)
	end
	Module:UpdateClickableSize()
end

function Module:RefreshAllPlates()
	Module:RefreshNameplats()
	Module:ResizeTargetPower()
end

local DisabledElements = {
	"Health",
	"Castbar",
	"HealthPrediction",
	"ThreatIndicator",
}
function Module:UpdatePlateByType()
	local name = self.nameText
	local hpval = self.healthValue
	local title = self.npcTitle
	local raidtarget = self.RaidTargetIndicator
	local questIcon = self.questIcon

	name:SetShown(not self.widgetsOnly)
	name:ClearAllPoints()
	self:Tag(self.nameText, "[nprare][color][name] [nplevel]")
	self.npcTitle:UpdateTag()
	raidtarget:ClearAllPoints()

	if self.plateType == "NameOnly" then
		for _, element in ipairs(DisabledElements) do
			if self:IsElementEnabled(element) then
				self:DisableElement(element)
			end
		end

		name:SetJustifyH("CENTER")
		name:SetPoint("CENTER", self, "BOTTOM")

		hpval:Hide()
		title:Hide()

		raidtarget:SetPoint("BOTTOM", name, "TOP", 0, 5)
		raidtarget:SetParent(self)

		if questIcon then questIcon:SetPoint("LEFT", name, "RIGHT", -6, 0) end

		if self.widgetContainer then
			self.widgetContainer:ClearAllPoints()
			self.widgetContainer:SetPoint("TOP", title, "BOTTOM", 0, -5)
		end
	else
		for _, element in ipairs(DisabledElements) do
			if not self:IsElementEnabled(element) then
				self:EnableElement(element)
			end
		end

		name:SetJustifyH("CENTER")
		name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -3, 4)
		name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -3, 4)
		self:Tag(self.nameText, "[name]")

		hpval:Show()
		title:Hide()

		raidtarget:SetPoint("TOPRIGHT", self, "TOPLEFT", -8, 25)

		if questIcon then
			questIcon:SetPoint("LEFT", self, "RIGHT", 1, 0)
		end

		if self.widgetContainer then
			self.widgetContainer:ClearAllPoints()
			self.widgetContainer:SetPoint("TOP", self.Castbar, "BOTTOM", 0, -5)
		end
	end
	
	--Module.UpdateNameplateSize(self)
	Module.UpdateTargetIndicator(self)
	Module.ToggleNameplateAuras(self)
end

function Module:RefreshPlateType(unit)
	self.reaction = UnitReaction(unit, "player")
	self.isFriendly = self.reaction and self.reaction >= 4 and not UnitCanAttack("player", unit)
	if C["Nameplate"].NameOnly and self.isFriendly or self.widgetsOnly then
		self.plateType = "NameOnly"
	elseif C["Nameplate"].FriendPlate and self.isFriendly then
		self.plateType = "FriendPlate"
	else
		self.plateType = "None"
	end

	if self.previousType == nil or self.previousType ~= self.plateType then
		Module.UpdatePlateByType(self)
		self.previousType = self.plateType
	end
end

function Module:OnUnitFactionChanged(unit)
	local nameplate = C_NamePlate_GetNamePlateForUnit(unit, issecure())
	local unitFrame = nameplate and nameplate.unitFrame
	if unitFrame and unitFrame.unitName then
		Module.RefreshPlateType(unitFrame, unit)
	end
end

function Module:RefreshPlateOnFactionChanged()
	K:RegisterEvent("UNIT_FACTION", Module.OnUnitFactionChanged)
end

function Module:PostUpdatePlates(event, unit)
	if not self then
		return
	end

	if event == "NAME_PLATE_UNIT_ADDED" then
		self.unitName = UnitName(unit)
		self.unitGUID = UnitGUID(unit)
		self.isPlayer = UnitIsPlayer(unit)
		self.npcID = K.GetNPCID(self.unitGUID)

		Module.RefreshPlateType(self, unit)
		-- Mitigate intermittent delayed name availability
		if self.nameText and self.plateType == "NameOnly" then
			C_Timer.After(0.25, function()
				if self.nameText and self:IsShown() then
					self.nameText:UpdateTag()
				end
			end)
		end
	elseif event == "NAME_PLATE_UNIT_REMOVED" then
		self.npcID = nil
	end

	if event ~= "NAME_PLATE_UNIT_REMOVED" then
		Module.UpdateUnitPower(self)
		Module.UpdateTargetChange(self)
		Module.UpdateQuestUnit(self, event, unit)
		Module.UpdateUnitClassify(self, unit)
		Module:UpdateClassIcon(self, unit)
		Module:UpdateTargetClassPower()

		self.tarName:SetShown(self.plateType ~= "NameOnly" and C["Nameplate"].TarName)
	end
end

-- Player Nameplate
function Module:PlateVisibility(event)
	if (event == "PLAYER_REGEN_DISABLED" or InCombatLockdown()) and UnitIsUnit("player", self.unit) then
		K.UIFrameFadeIn(self.Health, 0.2, self.Health:GetAlpha(), 1)
		K.UIFrameFadeIn(self.Power, 0.2, self.Power:GetAlpha(), 1)
		K.UIFrameFadeIn(self.Auras, 0.2, self.Power:GetAlpha(), 1)
	else
		K.UIFrameFadeOut(self.Health, 0.2, self.Health:GetAlpha(), 0)
		K.UIFrameFadeOut(self.Power, 0.2, self.Power:GetAlpha(), 0)
		K.UIFrameFadeOut(self.Auras, 0.2, self.Power:GetAlpha(), 0)
	end
end

function Module:CreatePlayerPlate()
	self.mystyle = "PlayerPlate"

	local iconSize, margin = C["Nameplate"].PPIconSize, 2
	self:SetSize(iconSize * 5 + margin * 4, C["Nameplate"].PPHeight)
	self:EnableMouse(false)
	self.iconSize = iconSize

	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetAllPoints()
	self.Health:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
	self.Health:SetStatusBarColor(0.1, 0.1, 0.1)
	self.Health:CreateShadow(true)

	self.Health.colorClass = true

	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
	self.Power:SetHeight(C["Nameplate"].PPPHeight)
	self.Power:SetWidth(self:GetWidth())
	self.Power:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -3)
	self.Power:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -3)
	self.Power:CreateShadow(true)

	self.Power.colorPower = true
	self.Power.frequentUpdates = true

	Module:CreateClassPower(self)
	Module:CreateEclipseBar(self)

	if K.Class == "MONK" then
		self.Stagger = CreateFrame("StatusBar", self:GetName() .. "Stagger", self)
		self.Stagger:SetPoint("TOPLEFT", self.Health, 0, 8)
		self.Stagger:SetSize(self:GetWidth(), self:GetHeight())
		self.Stagger:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
		self.Stagger:CreateShadow(true)

		self.Stagger.Value = self.Stagger:CreateFontString(nil, "OVERLAY")
		self.Stagger.Value:SetFontObject(K.UIFont)
		self.Stagger.Value:SetPoint("CENTER", self.Stagger, "CENTER", 0, 0)
		self:Tag(self.Stagger.Value, "[monkstagger]")
	end

	local textFrame = CreateFrame("Frame", nil, self.Power)
	textFrame:SetAllPoints()
	self.powerText = K.CreateFontString(textFrame, 12, "")
	self:Tag(self.powerText, "[pppower]")
	Module:TogglePlatePower()

	Module:CreateGCDTicker(self)
	Module:UpdateTargetClassPower()
	Module:TogglePlateVisibility()
end

function Module:TogglePlayerPlate()
	local plate = oUF_PlayerPlate
	if not plate then
		return
	end

	if C["Nameplate"].ShowPlayerPlate then
		plate:Enable()
	else
		plate:Disable()
	end
end

function Module:TogglePlatePower()
	local plate = oUF_PlayerPlate
	if not plate then
		return
	end

	plate.powerText:SetShown(C["Nameplate"].PPPowerText)
end

function Module:TogglePlateVisibility()
	local plate = oUF_PlayerPlate
	if not plate then
		return
	end

	if C["Nameplate"].PPHideOOC then
		plate:RegisterEvent("UNIT_EXITED_VEHICLE", Module.PlateVisibility)
		plate:RegisterEvent("UNIT_ENTERED_VEHICLE", Module.PlateVisibility)
		plate:RegisterEvent("PLAYER_REGEN_ENABLED", Module.PlateVisibility, true)
		plate:RegisterEvent("PLAYER_REGEN_DISABLED", Module.PlateVisibility, true)
		plate:RegisterEvent("PLAYER_ENTERING_WORLD", Module.PlateVisibility, true)
		Module.PlateVisibility(plate)
	else
		plate:UnregisterEvent("UNIT_EXITED_VEHICLE", Module.PlateVisibility)
		plate:UnregisterEvent("UNIT_ENTERED_VEHICLE", Module.PlateVisibility)
		plate:UnregisterEvent("PLAYER_REGEN_ENABLED", Module.PlateVisibility)
		plate:UnregisterEvent("PLAYER_REGEN_DISABLED", Module.PlateVisibility)
		plate:UnregisterEvent("PLAYER_ENTERING_WORLD", Module.PlateVisibility)
		Module.PlateVisibility(plate, "PLAYER_REGEN_DISABLED")
	end
end

-- Target nameplate
function Module:CreateTargetPlate()
	self.mystyle = "targetplate"
	self:EnableMouse(false)
	self:SetSize(10, 10)

	Module:CreateClassPower(self)
end

function Module:UpdateTargetClassPower()
	local plate = oUF_TargetPlate
	if not plate then
		return
	end

	local bar = plate.ClassPowerBar
	local nameplate = C_NamePlate_GetNamePlateForUnit("target")
	if nameplate and nameplate.unitFrame then
		bar:SetParent(nameplate.unitFrame)
		bar:ClearAllPoints()
		bar:SetPoint("BOTTOM", nameplate.unitFrame, "TOP", 0, 20)
		bar:Show()
	else
		bar:Hide()
		-- Reset parent back to the original holder to avoid dangling references on recycled plates
		bar:SetParent(plate)
		bar:ClearAllPoints()
	end
end

function Module:ToggleTargetClassPower()
	local plate = oUF_TargetPlate
	if not plate then
		return
	end

	local playerPlate = oUF_PlayerPlate
	if C["Nameplate"].NameplateClassPower then
		plate:Enable()
		if plate.ClassPower then
			if not plate:IsElementEnabled("ClassPower") then
				plate:EnableElement("ClassPower")
				plate.ClassPower:ForceUpdate()
			end
			if playerPlate then
				if playerPlate:IsElementEnabled("ClassPower") then
					playerPlate:DisableElement("ClassPower")
				end
			end
		end

		if plate.Runes then
			if not plate:IsElementEnabled("Runes") then
				plate:EnableElement("Runes")
				plate.Runes:ForceUpdate()
			end
			if playerPlate then
				if playerPlate:IsElementEnabled("Runes") then
					playerPlate:DisableElement("Runes")
				end
			end
		end
	else
		plate:Disable()
		if plate.ClassPower then
			if plate:IsElementEnabled("ClassPower") then
				plate:DisableElement("ClassPower")
			end
			if playerPlate then
				if not playerPlate:IsElementEnabled("ClassPower") then
					playerPlate:EnableElement("ClassPower")
					playerPlate.ClassPower:ForceUpdate()
				end
			end
		end
		if plate.Runes then
			if plate:IsElementEnabled("Runes") then
				plate:DisableElement("Runes")
			end
			if playerPlate then
				if not playerPlate:IsElementEnabled("Runes") then
					playerPlate:EnableElement("Runes")
					playerPlate.Runes:ForceUpdate()
				end
			end
		end
	end
end

function Module:ResizeTargetPower()
	local plate = oUF_TargetPlate
	if not plate then
		return
	end

	local barWidth = C["Nameplate"].PlateWidth
	local barHeight = C["Nameplate"].PlateHeight
	local bars = plate.ClassPower or plate.Runes
	if bars then
		plate.ClassPowerBar:SetSize(barWidth, barHeight)
		local max = bars.__max
		for i = 1, max do
			bars[i]:SetHeight(barHeight)
			bars[i]:SetWidth((barWidth - (max - 1) * 6) / max)
		end
	end
end

function Module:CreateGCDTicker(self)
	if not C["Nameplate"].PPGCDTicker then
		return
	end

	local GCD = CreateFrame("Frame", "oUF_PlateGCD", self.Power)
	GCD:SetWidth(self:GetWidth())
	GCD:SetHeight(C["Nameplate"].PPPHeight)
	GCD:SetPoint("LEFT", self.Power, "LEFT", 0, 0)

	GCD.Color = { 1, 1, 1, 0.6 }
	GCD.Texture = C["Media"].Textures.Spark128Texture
	GCD.Height = C["Nameplate"].PPPHeight
	GCD.Width = 128 / 2

	self.GCD = GCD
end
