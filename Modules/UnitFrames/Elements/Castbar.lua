local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Unitframes")

local format = format
local min = min

local GetTime = GetTime
local IsPlayerSpell = IsPlayerSpell
local UnitExists = UnitExists
local UnitInVehicle = UnitInVehicle
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName
local YOU = YOU

local channelingTicks = {
	-- Death Knight
	[42650]	= 8, 	-- Army of the Dead
	--Druid
	[740]		= 4, 	-- Tranquility
	[16914]	= 10,	-- Hurricane
	-- Mage
	[10]		= 8, 	-- Blizzard
	[5143]	= 3, 	-- Arcane Missiles	
	[12051]	= 4, 	-- Evocation
	-- Priest
	[15407]	= 3, 	-- Mind Flay
	[64843]	= 4, 	-- Divine Hymn
	[64901]	= 4, 	-- Hymn of Hope
	[48045]	= 5, 	-- Mind Sear
	[47540]	= 2, 	-- Penance (Dummy)
	[47750]	= 2, 	-- Penance (Heal A)
	[47757]	= 2, 	-- Penance (Heal B)
	[47666]	= 2, 	-- Penance (DPS A)
	[47758]	= 2, 	-- Penance (DPS B)	
	-- Warlock
	[1120]	= 5, 	-- Drain Soul
	[755]		= 10, -- Health Funnel
	[689]		= 5, 	-- Drain Life
	[5740]	= 4, 	-- Rain of Fire	
	[1949]	= 15,	-- Hellfire
	[79268] 	= 3, 	-- Soul Harvest
	-- First Aid
	[45544]	= 8, 	-- Heavy Frostweave Bandage
	[45543]	= 8, 	-- Frostweave Bandage
	[27031]	= 8, 	-- Heavy Netherweave Bandage
	[27030]	= 8, 	-- Netherweave Bandage
	[23567]	= 8, 	-- Warsong Gulch Runecloth Bandage
	[23696]	= 8, 	-- Alterac Heavy Runecloth Bandage
	[24414]	= 8, 	-- Arathi Basin Runecloth Bandage
	[18610]	= 8, 	-- Heavy Runecloth Bandage
	[18608]	= 8, 	-- Runecloth Bandage
	[10839]	= 8, 	-- Heavy Mageweave Bandage
	[10838]	= 8, 	-- Mageweave Bandage
	[7927]	= 8, 	-- Heavy Silk Bandage
	[7926]	= 8, 	-- Silk Bandage
	[3268]	= 7, 	-- Heavy Wool Bandage
	[3267]	= 7, 	-- Wool Bandage
	[1159]	= 6, 	-- Heavy Linen Bandage
	[746]		= 6, 	-- Linen Bandage
}

local function CreateAndUpdateBarTicks(bar, ticks, numTicks)
	for i = 1, #ticks do
		ticks[i]:Hide()
	end

	if numTicks and numTicks > 0 then
		local width, height = bar:GetSize()
		local delta = width / numTicks
		for i = 1, numTicks - 1 do
			if not ticks[i] then
				ticks[i] = bar:CreateTexture(nil, "OVERLAY")
				ticks[i]:SetTexture(C["Media"].Textures.White8x8Texture)
				ticks[i]:SetVertexColor(0, 0, 0, 0.7)
				ticks[i]:SetWidth(1)
				ticks[i]:SetHeight(height)
			end
			ticks[i]:ClearAllPoints()
			ticks[i]:SetPoint("RIGHT", bar, "LEFT", delta * i, 0)
			ticks[i]:Show()
		end
	end
end

function Module:OnCastbarUpdate(elapsed)
	if self.casting or self.channeling then
		local decimal = self.decimal

		local duration = self.casting and (self.duration + elapsed) or (self.duration - elapsed)
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end

		if self.__owner.unit == "player" then
			if self.delay ~= 0 then
				self.Time:SetFormattedText(decimal .. " - |cffff0000" .. decimal, duration, self.casting and self.max + self.delay or self.max - self.delay)
			else
				self.Time:SetFormattedText(decimal .. " - " .. decimal, duration, self.max)
			end
		else
			if duration > 1e4 then
				self.Time:SetText("∞ - ∞")
			else
				self.Time:SetFormattedText(decimal .. " - " .. decimal, duration, self.casting and self.max + self.delay or self.max - self.delay)
			end
		end
		self.duration = duration
		self:SetValue(duration)
		self.Spark:SetPoint("CENTER", self, "LEFT", (duration / self.max) * self:GetWidth(), 0)
	elseif self.holdTime > 0 then
		self.holdTime = self.holdTime - elapsed
	else
		self.Spark:Hide()
		local alpha = self:GetAlpha() - 0.02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end

function Module:OnCastSent()
	local element = self.Castbar
	if not element.SafeZone then return end
	element.__sendTime = GetTime()
end

local function ResetSpellTarget(self)
	if self.spellTarget then
		self.spellTarget:SetText("")
	end
end

local function UpdateSpellTarget(self, unit)
	if not C["Nameplate"].CastTarget then return end
	if not self.spellTarget then return end

	local unitTarget = unit and unit .. "target"
	if unitTarget and UnitExists(unitTarget) then
		local nameString
		if UnitIsUnit(unitTarget, "player") then
			nameString = format("|cffff0000%s|r", ">" .. strupper(YOU) .. "<")
		else
			nameString = K.RGBToHex(K.UnitColor(unitTarget)) .. UnitName(unitTarget)
		end
		self.spellTarget:SetText(nameString)
	else
		ResetSpellTarget(self) -- when unit loses target
	end
end

local function UpdateCastBarColor(self, unit)
	local color = K.Colors.castbar.CastingColor

	-- Check if the casting should be colored with class colors and the unit is a player
	if C["Unitframe"].CastClassColor and UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		color = class and K.Colors.class[class]

	-- Check if the casting should be colored with reaction colors
	elseif C["Unitframe"].CastReactionColor then
		local reaction = UnitReaction(unit, "player")
		color = reaction and K.Colors.reaction[reaction]

	-- Check if the casting can only be interrupted by the caster
	elseif self.notInterruptible and not UnitIsUnit(unit, "player") then
		color = K.Colors.castbar.notInterruptibleColor
	end

	-- Set the bar color to the color obtained above
	self:SetStatusBarColor(color[1], color[2], color[3])
end

function Module:PostCastStart(unit)
	self:SetAlpha(1)
	self.Spark:Show()

	local safeZone = self.SafeZone
	local lagString = self.LagString

	if unit == "vehicle" or UnitInVehicle("player") then
		if safeZone then
			safeZone:Hide()
			lagString:Hide()
		end
	elseif unit == "player" then
		if safeZone then
			local sendTime = self.__sendTime
			local timeDiff = sendTime and min((GetTime() - sendTime), self.max)
			if timeDiff and timeDiff ~= 0 then
				safeZone:SetWidth(self:GetWidth() * timeDiff / self.max)
				safeZone:Show()
				lagString:SetFormattedText("%d ms", timeDiff * 1000)
				lagString:Hide() --- Hide/Show Text Castbar Latency
			else
				safeZone:Hide()
				lagString:Hide()
			end
			self.__sendTime = nil
		end

		local numTicks = 0
		if self.channeling then
			numTicks = channelingTicks[self.spellID] or 0
		end
		CreateAndUpdateBarTicks(self, self.castTicks, numTicks)
	end

	UpdateCastBarColor(self, unit)

	if self.__owner.mystyle == "nameplate" then
		-- Major spells
		if C.MajorSpells[self.spellID] then
			K.ShowOverlayGlow(self.glowFrame)
		else
			K.HideOverlayGlow(self.glowFrame)
		end

		-- Spell target
		UpdateSpellTarget(self, unit)
	end
end

function Module:PostCastUpdate(unit)
	UpdateSpellTarget(self, unit)
end

function Module:PostUpdateInterruptible(unit)
	UpdateCastBarColor(self, unit)
end

function Module:PostCastStop()
	if not self.fadeOut then
		self:SetStatusBarColor(K.Colors.castbar.CompleteColor[1], K.Colors.castbar.CompleteColor[2], K.Colors.castbar.CompleteColor[3])
		self.fadeOut = true
	end

	self:Show()
	ResetSpellTarget(self)
end

function Module:PostCastFailed()
	self:SetStatusBarColor(K.Colors.castbar.FailColor[1], K.Colors.castbar.FailColor[2], K.Colors.castbar.FailColor[3])
	self:SetValue(self.max)
	self.fadeOut = true
	self:Show()
	ResetSpellTarget(self)
end