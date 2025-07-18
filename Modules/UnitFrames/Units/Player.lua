local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Unitframes")

-- Lua functions
local select = select
local string_format = string.format

-- WoW API
local CreateFrame = CreateFrame

function Module.PostUpdateAddPower(element, _, cur, max)
	if element.Text and max > 0 then
		local perc = cur / max * 100
		if perc == 100 then
			perc = ""
			element:SetAlpha(0)
		else
			perc = string_format("%d%%", perc)
			element:SetAlpha(1)
		end

		element.Text:SetText(perc)
	end
end

function Module:CreatePlayer()
	self.mystyle = "player"

	local playerWidth = C["Unitframe"].PlayerHealthWidth
	local playerHeight = C["Unitframe"].PlayerHealthHeight
	local playerPortraitStyle = C["Unitframe"].PortraitStyle.Value

	local UnitframeTexture = K.GetTexture(C["General"].Texture)
	local HealPredictionTexture = K.GetTexture(C["General"].Texture)

	if not self then return end

	-- Create Overlay
	local Overlay = CreateFrame("Frame", nil, self) -- We will use this to overlay onto our special borders.
	Overlay:SetFrameStrata(self:GetFrameStrata())
	Overlay:SetFrameLevel(5)
	Overlay:SetAllPoints()
	Overlay:EnableMouse(false)
	self.Overlay = Overlay

	-- Create Header
	Module.CreateHeader(self)

	-- Create Health
	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetHeight(playerHeight)
	Health:SetPoint("TOPLEFT")
	Health:SetPoint("TOPRIGHT")
	Health:SetStatusBarTexture(UnitframeTexture)
	Health:CreateBorder()
	self.Health = Health

	Health.colorDisconnected = true
	Health.frequentUpdates = true

	if C["Unitframe"].Smooth then
		K:SmoothBar(Health)
	end

	if C["Unitframe"].HealthbarColor.Value == "Value" then
		Health.colorSmooth = true
		Health.colorClass = false
		Health.colorReaction = false
	elseif C["Unitframe"].HealthbarColor.Value == "Dark" then
		Health.colorSmooth = false
		Health.colorClass = false
		Health.colorReaction = false
		Health:SetStatusBarColor(0.31, 0.31, 0.31)
	else
		Health.colorSmooth = false
		Health.colorClass = true
		Health.colorReaction = true
	end

	Health.Value = Health:CreateFontString(nil, "OVERLAY")
	Health.Value:SetFontObject(K.UIFont)
	Health.Value:SetPoint("CENTER", Health, "CENTER", 0, 0)
	self:Tag(Health.Value, "[hp]")

	-- Create Power
	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetHeight(C["Unitframe"].PlayerPowerHeight)
	Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -6)
	Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -6)
	Power:SetStatusBarTexture(UnitframeTexture)
	Power:CreateBorder()
	self.Power = Power

	Power.colorPower = true
	Power.frequentUpdates = true

	if C["Unitframe"].Smooth then
		K:SmoothBar(Power)
	end

	Power.Value = Power:CreateFontString(nil, "OVERLAY")
	Power.Value:SetPoint("CENTER", Power, "CENTER", 0, 0)
	Power.Value:SetFontObject(K.UIFont)
	Power.Value:SetFont(select(1, Power.Value:GetFont()), 11, select(3, Power.Value:GetFont()))
	self:Tag(Power.Value, "[power]")

	-- Create Portrait conditionally
	if playerPortraitStyle ~= "NoPortraits" then
		local Portrait
		if playerPortraitStyle == "OverlayPortrait" then
			Portrait = CreateFrame("PlayerModel", "KKUI_PlayerPortrait", self)
			Portrait:SetFrameStrata(self:GetFrameStrata())
			Portrait:SetPoint("TOPLEFT", Health, "TOPLEFT", 1, -1)
			Portrait:SetPoint("BOTTOMRIGHT", Health, "BOTTOMRIGHT", -1, 1)
			Portrait:SetAlpha(0.6)
		elseif playerPortraitStyle == "ThreeDPortraits" then
			Portrait = CreateFrame("PlayerModel", "KKUI_PlayerPortrait", Health)
			Portrait:SetFrameStrata(self:GetFrameStrata())
			Portrait:SetSize(Health:GetHeight() + Power:GetHeight() + 6, Health:GetHeight() + Power:GetHeight() + 6)
			Portrait:SetPoint("TOPRIGHT", self, "TOPLEFT", -6, 0)
			Portrait:CreateBorder()
		else
			Portrait = Health:CreateTexture("KKUI_PlayerPortrait", "BACKGROUND", nil, 1)
			Portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
			Portrait:SetSize(Health:GetHeight() + Power:GetHeight() + 6, Health:GetHeight() + Power:GetHeight() + 6)
			Portrait:SetPoint("TOPRIGHT", self, "TOPLEFT", -6, 0)

			Portrait.Border = CreateFrame("Frame", nil, self)
			Portrait.Border:SetAllPoints(Portrait)
			Portrait.Border:CreateBorder()

			if playerPortraitStyle == "ClassPortraits" or playerPortraitStyle == "NewClassPortraits" then
				Portrait.PostUpdate = Module.UpdateClassPortraits
			end
		end
		self.Portrait = Portrait
	end

	-- Class Resources
	if C["Unitframe"].ClassResources and not C["Nameplate"].ShowPlayerPlate then
		Module:CreateClassPower(self)
		Module:CreateEclipseBar(self)
	end

	-- Player Debuffs
	if C["Unitframe"].PlayerDebuffs then -- and C["Unitframe"].TargetDebuffsTop
		local Debuffs = CreateFrame("Frame", nil, self)
		Debuffs.spacing = 6
		Debuffs.initialAnchor = "BOTTOMLEFT"
		Debuffs["growth-x"] = "RIGHT"
		Debuffs["growth-y"] = "UP"
		Debuffs:SetPoint("BOTTOMLEFT", Health, "TOPLEFT", 0, 6)
		Debuffs:SetPoint("BOTTOMRIGHT", Health, "TOPRIGHT", 0, 6)
		Debuffs.num = 14
		Debuffs.iconsPerRow = C["Unitframe"].PlayerDebuffsPerRow

		Module:UpdateAuraContainer(playerWidth, Debuffs, Debuffs.num)

		Debuffs.PostCreateIcon = Module.PostCreateIcon
		Debuffs.PostUpdateIcon = Module.PostUpdateIcon

		self.Debuffs = Debuffs
	end

	-- Player Buffs
	if C["Unitframe"].PlayerBuffs then -- and C["Unitframe"].TargetDebuffsTop
		local Buffs = CreateFrame("Frame", nil, self)
		Buffs:SetPoint("TOPLEFT", Power, "BOTTOMLEFT", 0, -6)
		Buffs:SetPoint("TOPRIGHT", Power, "BOTTOMRIGHT", 0, -6)
		Buffs.initialAnchor = "TOPLEFT"
		Buffs["growth-x"] = "RIGHT"
		Buffs["growth-y"] = "DOWN"
		Buffs.num = 20
		Buffs.spacing = 6
		Buffs.iconsPerRow = C["Unitframe"].PlayerBuffsPerRow
		Buffs.onlyShowPlayer = false

		Module:UpdateAuraContainer(playerWidth, Buffs, Buffs.num)

		Buffs.PostCreateIcon = Module.PostCreateIcon
		Buffs.PostUpdateIcon = Module.PostUpdateIcon

		self.Buffs = Buffs
	end

	-- Player Castbar
	if C["Unitframe"].PlayerCastbar then
		local Castbar = CreateFrame("StatusBar", "oUF_CastbarPlayer", self)
		Castbar:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
		Castbar:SetFrameLevel(10)
		Castbar:SetSize(C["Unitframe"].PlayerCastbarWidth, C["Unitframe"].PlayerCastbarHeight)
		Castbar:CreateBorder()
		Castbar.castTicks = {}

		Castbar.Spark = Castbar:CreateTexture(nil, "OVERLAY", nil, 2)
		Castbar.Spark:SetSize(64, Castbar:GetHeight() - 2)
		Castbar.Spark:SetTexture(C["Media"].Textures.Spark128Texture)
		Castbar.Spark:SetBlendMode("ADD")
		Castbar.Spark:SetAlpha(0.8)

		local timer = K.CreateFontString(Castbar, 12, "", "", false, "RIGHT", -3, 0)
		local name = K.CreateFontString(Castbar, 12, "", "", false, "LEFT", 3, 0)
		name:SetPoint("RIGHT", timer, "LEFT", -5, 0)
		name:SetJustifyH("LEFT")

		Castbar.Icon = Castbar:CreateTexture(nil, "ARTWORK")
		Castbar.Icon:SetSize(Castbar:GetHeight(), Castbar:GetHeight())
		Castbar.Icon:SetPoint("BOTTOMRIGHT", Castbar, "BOTTOMLEFT", -6, 0)
		Castbar.Icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])

		Castbar.Button = CreateFrame("Frame", nil, Castbar)
		Castbar.Button:CreateBorder()
		Castbar.Button:SetAllPoints(Castbar.Icon)
		Castbar.Button:SetFrameLevel(Castbar:GetFrameLevel())

		local safeZone = Castbar:CreateTexture(nil, "OVERLAY")
		safeZone:SetTexture(K.GetTexture(C["General"].Texture))
		safeZone:SetVertexColor(0.69, 0.31, 0.31, 0.75)
		safeZone:SetPoint("TOPRIGHT")
		safeZone:SetPoint("BOTTOMRIGHT")
		Castbar:SetFrameLevel(10)
		Castbar.SafeZone = safeZone

		local lagStr = K.CreateFontString(Castbar, 11)
		lagStr:ClearAllPoints()
		lagStr:SetPoint("BOTTOM", Castbar, "TOP", 0, 4)
		Castbar.LagString = lagStr

		Module:ToggleCastBarLatency(self)

		Castbar.decimal = "%.2f"

		Castbar.Time = timer
		Castbar.Text = name
		Castbar.OnUpdate = Module.OnCastbarUpdate
		Castbar.PostCastStart = Module.PostCastStart
		Castbar.PostCastUpdate = Module.PostCastUpdate
		Castbar.PostCastStop = Module.PostCastStop
		Castbar.PostCastFail = Module.PostCastFailed
		Castbar.PostCastInterruptible = Module.PostUpdateInterruptible

		local mover = K.Mover(Castbar, "Player Castbar", "PlayerCB", { "BOTTOM", UIParent, "BOTTOM", 25, 385 }, Castbar:GetHeight() + Castbar:GetWidth() + 3, Castbar:GetHeight() + 3)
		Castbar:ClearAllPoints()
		Castbar:SetPoint("RIGHT", mover)
		Castbar.mover = mover

		self.Castbar = Castbar
	end

	-- Heal Prediction
	if C["Unitframe"].ShowHealPrediction then
		local frame = CreateFrame("Frame", nil, self)
		frame:SetAllPoints(Health)

		local myBar = frame:CreateTexture(nil, "BORDER", nil, 5)
		myBar:SetWidth(1)
		myBar:SetTexture(HealPredictionTexture)
		myBar:SetVertexColor(0, 1, 0, 0.5)

		local otherBar = frame:CreateTexture(nil, "BORDER", nil, 5)
		otherBar:SetWidth(1)
		otherBar:SetTexture(HealPredictionTexture)
		otherBar:SetVertexColor(0, 1, 1, 0.5)

		self.HealPredictionAndAbsorb = {
			myBar = myBar,
			otherBar = otherBar,
			maxOverflow = 1,
		}
		self.predicFrame = frame
	end

	-- Level
	if C["Unitframe"].ShowPlayerLevel then
		local Level = self:CreateFontString(nil, "OVERLAY")
		if playerPortraitStyle ~= "NoPortraits" and playerPortraitStyle ~= "OverlayPortrait" then
			Level:Show()
			Level:SetPoint("TOP", self.Portrait, 0, 15)
		else
			Level:Hide()
		end
		Level:SetFontObject(K.UIFont)
		self:Tag(Level, "[fulllevel]")
		self.Level = Level
	end

	-- Additional Power for Druids
	if C["Unitframe"].AdditionalPower and K.Class == "DRUID" then
		local AdditionalPower = CreateFrame("StatusBar", self:GetName() .. "AdditionalPower", Health)
		AdditionalPower:SetWidth(12)
		AdditionalPower:SetOrientation("VERTICAL")

		if playerPortraitStyle ~= "NoPortraits" and playerPortraitStyle ~= "OverlayPortrait" then
			AdditionalPower:SetPoint("TOPLEFT", self.Portrait, -18, 0)
			AdditionalPower:SetPoint("BOTTOMLEFT", self.Portrait, -18, 0)
		else
			AdditionalPower:SetPoint("TOPLEFT", self, -18, 0)
			AdditionalPower:SetPoint("BOTTOMLEFT", self, -18, 0)
		end

		AdditionalPower:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
		AdditionalPower:SetStatusBarColor(unpack(K.Colors.power.MANA))
		AdditionalPower:CreateBorder()
		AdditionalPower.colorPower = true

		if C["Unitframe"].Smooth then
			K:SmoothBar(AdditionalPower)
		end

		AdditionalPower.Text = AdditionalPower:CreateFontString(nil, "OVERLAY")
		AdditionalPower.Text:SetFontObject(K.UIFont)
		AdditionalPower.Text:SetFont(select(1, AdditionalPower.Text:GetFont()), 9, select(3, AdditionalPower.Text:GetFont()))
		AdditionalPower.Text:SetPoint("CENTER", AdditionalPower, 2, 0)

		AdditionalPower.PostUpdate = Module.PostUpdateAddPower
		AdditionalPower.frequentUpdates = true

		self.AdditionalPower = AdditionalPower
	end

	-- Global Cooldown
	if C["Unitframe"].GlobalCooldown then
		local GCD = CreateFrame("Frame", "oUF_PlayerGCD", Health)
		GCD:SetWidth(playerWidth)
		GCD:SetHeight(C["Unitframe"].PlayerHealthHeight - 2)
		GCD:SetPoint("LEFT", Health, "LEFT", 0, 0)
		GCD:SetAlpha(0.7)

		GCD.Color = { 1, 1, 1, 0.6 }
		GCD.Texture = C["Media"].Textures.Spark128Texture
		GCD.Height = C["Unitframe"].PlayerHealthHeight - 2
		GCD.Width = 128 / 2

		self.GCD = GCD
	end

	-- Combat Text
	if C["Unitframe"].CombatText then
		if not (C_AddOns.IsAddOnLoaded("MikScrollingBattleText") or C_AddOns.IsAddOnLoaded("Parrot") or C_AddOns.IsAddOnLoaded("xCT") or C_AddOns.IsAddOnLoaded("sct")) then
			local parentFrame = CreateFrame("Frame", nil, UIParent)
			local FloatingCombatFeedback = CreateFrame("Frame", "oUF_Player_CombatTextFrame", parentFrame)
			FloatingCombatFeedback:SetSize(32, 32)
			K.Mover(FloatingCombatFeedback, "CombatText", "PlayerCombatText", { "BOTTOM", self, "TOPLEFT", 0, 120 })

			for i = 1, 36 do
				FloatingCombatFeedback[i] = parentFrame:CreateFontString("$parentText", "OVERLAY")
			end

			FloatingCombatFeedback.font = select(1, KkthnxUIFontOutline:GetFont())
			FloatingCombatFeedback.fontFlags = "OUTLINE"
			FloatingCombatFeedback.abbreviateNumbers = true

			self.FloatingCombatFeedback = FloatingCombatFeedback
		else
			C["Unitframe"].CombatText = false
		end
	end

	-- Swing Timer
	if C["Unitframe"].SwingBar then
		local width, height = C["Unitframe"].SwingWidth, C["Unitframe"].SwingHeight

		local bar = CreateFrame("Frame", nil, self)
		bar:SetSize(width, height)
		bar.mover = K.Mover(bar, "UFs SwingBar", "Swing", { "BOTTOM", UIParent, "BOTTOM", 0, 360 })
		bar:ClearAllPoints()
		bar:SetPoint("CENTER", bar.mover)

		local two = CreateFrame("StatusBar", nil, bar)
		two:SetStatusBarTexture(UnitframeTexture)
		two:SetStatusBarColor(0.20, 0.60, 0.80) -- Light blue color
		two:CreateBorder()
		two:Hide()
		two:SetAllPoints()

		local main = CreateFrame("StatusBar", nil, bar)
		main:SetStatusBarTexture(UnitframeTexture)
		main:SetStatusBarColor(0.20, 0.80, 0.20) -- Light green color
		main:CreateBorder()
		main:Hide()
		main:SetAllPoints()

		local off = CreateFrame("StatusBar", nil, bar)
		off:SetStatusBarTexture(UnitframeTexture)
		off:SetStatusBarColor(0.80, 0.20, 0.20) -- Light red color
		off:CreateBorder()
		off:Hide()
		if C["Unitframe"].OffOnTop then
			off:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", 0, 6)
			off:SetPoint("BOTTOMRIGHT", bar, "TOPRIGHT", 0, 6)
		else
			off:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -6)
			off:SetPoint("TOPRIGHT", bar, "BOTTOMRIGHT", 0, -6)
		end
		off:SetHeight(height)

		bar.Text = K.CreateFontString(bar, 12, "")
		bar.Text:SetShown(C["Unitframe"].SwingTimer)
		bar.TextMH = K.CreateFontString(main, 12, "")
		bar.TextMH:SetShown(C["Unitframe"].SwingTimer)
		bar.TextOH = K.CreateFontString(off, 12, "")
		bar.TextOH:SetShown(C["Unitframe"].SwingTimer)

		self.Swing = bar
		self.Swing.Twohand = two
		self.Swing.Mainhand = main
		self.Swing.Offhand = off
		self.Swing.hideOoc = true
	end

	-- Indicators
	local LeaderIndicator = Overlay:CreateTexture(nil, "OVERLAY")
	LeaderIndicator:SetSize(16, 16)
	if playerPortraitStyle ~= "NoPortraits" and playerPortraitStyle ~= "OverlayPortrait" then
		LeaderIndicator:SetPoint("TOPLEFT", self.Portrait, 0, 8)
	else
		LeaderIndicator:SetPoint("TOPLEFT", Health, 0, 8)
	end
	self.LeaderIndicator = LeaderIndicator

	local AssistantIndicator = Overlay:CreateTexture(nil, "OVERLAY")
	AssistantIndicator:SetSize(16, 16)
	if playerPortraitStyle ~= "NoPortraits" and playerPortraitStyle ~= "OverlayPortrait" then
		AssistantIndicator:SetPoint("TOPLEFT", self.Portrait, 0, 8)
	else
		AssistantIndicator:SetPoint("TOPLEFT", Health, 0, 8)
	end
	self.AssistantIndicator = AssistantIndicator

	if C["Unitframe"].PvPIndicator then
		local PvPIndicator = self:CreateTexture(nil, "OVERLAY")
		PvPIndicator:SetSize(32, 36)
		PvPIndicator:SetAlpha(0.9)
		if playerPortraitStyle ~= "NoPortraits" and playerPortraitStyle ~= "OverlayPortrait" then
			PvPIndicator:SetPoint("RIGHT", self.Portrait, "LEFT", -2, 0)
		else
			PvPIndicator:SetPoint("RIGHT", Health, "LEFT", -2, 0)
		end
		PvPIndicator.PostUpdate = Module.PostUpdatePvPIndicator
		self.PvPIndicator = PvPIndicator
	end

	local CombatIndicator = Health:CreateTexture(nil, "OVERLAY")
	CombatIndicator:SetSize(26, 26)
	CombatIndicator:SetPoint("LEFT", 6, -1)
	CombatIndicator:SetAtlas("UI-HUD-UnitFrame-Player-CombatIcon")
	CombatIndicator:SetAlpha(0.6)
	self.CombatIndicator = CombatIndicator

	local RaidTargetIndicator = Overlay:CreateTexture(nil, "OVERLAY")
	if playerPortraitStyle ~= "NoPortraits" and playerPortraitStyle ~= "OverlayPortrait" then
		RaidTargetIndicator:SetPoint("TOP", self.Portrait, "TOP", 0, 8)
	else
		RaidTargetIndicator:SetPoint("TOP", Health, "TOP", 0, 8)
	end
	RaidTargetIndicator:SetSize(24, 24)
	self.RaidTargetIndicator = RaidTargetIndicator

	local ReadyCheckIndicator = Overlay:CreateTexture(nil, "OVERLAY")
	if playerPortraitStyle ~= "NoPortraits" and playerPortraitStyle ~= "OverlayPortrait" then
		ReadyCheckIndicator:SetPoint("CENTER", self.Portrait)
	else
		ReadyCheckIndicator:SetPoint("CENTER", Health)
	end
	ReadyCheckIndicator:SetSize(playerHeight - 4, playerHeight - 4)
	self.ReadyCheckIndicator = ReadyCheckIndicator

	local ResurrectIndicator = Overlay:CreateTexture(nil, "OVERLAY")
	ResurrectIndicator:SetSize(44, 44)
	if playerPortraitStyle ~= "NoPortraits" and playerPortraitStyle ~= "OverlayPortrait" then
		ResurrectIndicator:SetPoint("CENTER", self.Portrait)
	else
		ResurrectIndicator:SetPoint("CENTER", Health)
	end
	self.ResurrectIndicator = ResurrectIndicator

	do
		local RestingIndicator = CreateFrame("Frame", "KKUI_RestingFrame", Overlay)
		RestingIndicator:SetSize(5, 5)
		if playerPortraitStyle ~= "NoPortraits" and playerPortraitStyle ~= "OverlayPortrait" then
			RestingIndicator:SetPoint("TOPLEFT", self.Portrait, "TOPLEFT", -2, 4)
		else
			RestingIndicator:SetPoint("TOPLEFT", Health, "TOPLEFT", -2, 4)
		end
		RestingIndicator:Hide()

		local textFrame = CreateFrame("Frame", nil, RestingIndicator)
		textFrame:SetAllPoints()
		textFrame:SetFrameLevel(6)

		local texts = {}
		local offsets = {
			{ 4, -4 },
			{ 0, 0 },
			{ -5, 5 },
		}

		for i = 1, 3 do
			texts[i] = K.CreateFontString(textFrame, (7 + i * 3), "z", "", "system", "CENTER", offsets[i][1], offsets[i][2])
		end

		local step, stepSpeed = 0, 0.35
		local stepMaps = {
			{ true, false, false },
			{ true, true, false },
			{ true, true, true },
			{ false, true, true },
			{ false, false, true },
			{ false, false, false },
		}

		RestingIndicator:SetScript("OnUpdate", function(self, elapsed)
			self.elapsed = (self.elapsed or 0) + elapsed

			if self.elapsed > stepSpeed then
				step = (step % 6) + 1

				for i = 1, 3 do
					texts[i]:SetShown(stepMaps[step][i])
				end

				self.elapsed = 0
			end
		end)

		RestingIndicator:SetScript("OnHide", function()
			step = 6
			for i = 1, 3 do
				texts[i]:SetShown(stepMaps[step][i])
			end
		end)

		self.RestingIndicator = RestingIndicator
	end

	-- Debuff Highlight
	if C["Unitframe"].DebuffHighlight then
		local DebuffHighlight = Health:CreateTexture(nil, "OVERLAY")
		DebuffHighlight:SetAllPoints(Health)
		DebuffHighlight:SetTexture(C["Media"].Textures.White8x8Texture)
		DebuffHighlight:SetVertexColor(0, 0, 0, 0)
		DebuffHighlight:SetBlendMode("ADD")

		self.DebuffHighlight = DebuffHighlight
		self.DebuffHighlightAlpha = 0.45
		self.DebuffHighlightFilter = true
	end

	-- Highlight
	local Highlight = Health:CreateTexture(nil, "OVERLAY")
	Highlight:SetAllPoints()
	Highlight:SetTexture("Interface\\PETBATTLES\\PetBattle-SelectedPetGlow")
	Highlight:SetTexCoord(0, 1, 0.5, 1)
	Highlight:SetVertexColor(0.6, 0.6, 0.6)
	Highlight:SetBlendMode("ADD")
	Highlight:Hide()
	self.Highlight = Highlight

	-- Threat Indicator
	local ThreatIndicator = {
		IsObjectType = K.Noop,
		Override = Module.UpdateThreat,
	}
	self.ThreatIndicator = ThreatIndicator
end
