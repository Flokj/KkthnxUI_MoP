local K = KkthnxUI[1]
local oUF = K.oUF

-- By Tukz, for Tukui

local Tracker = {
	-- PRIEST
	[21562] = { 1, 1, 0.66 }, -- Prayer of Fortitude
	[27683] = { 0.7, 0.7, 0.7 }, -- Prayer of Shadow Protection
	[17] = { 0.00, 0.00, 1.00 }, -- Power Word: Shield
	[139] = { 0.33, 0.73, 0.75 }, -- Renew

	-- HUNTER
	[19506] = { 0.89, 0.09, 0.05 }, -- Trueshot Aura 
	[13159] = { 0.00, 0.00, 0.85 }, -- Aspect of the Pack
	[20043] = { 0.33, 0.93, 0.79 }, -- Aspect of the Wild 

	-- MAGE
	[1459] = { 0.89, 0.09, 0.05 }, -- Arcane Intellect
	[130] = { 0.00, 0.00, 0.50 }, -- Slow Fall

	-- PALADIN
	[1044] = { 0.89, 0.45, 0 }, -- Blessing of Freedom
	[6940] = { 0.89, 0.1, 0.1 }, -- Blessing Sacrifice
	[19740] = { 0.2, 0.8, 0.2 }, -- Blessing of Might
	[465] = { 0.58, 1.00, 0.50 }, -- Devotion Aura
	[1022] = { 0.17, 1.00, 0.75 }, -- Blessing of Protection
	[19746] = { 0.83, 1.00, 0.07 }, -- Concentration Aura
	[32223] = { 0.83, 1.00, 0.07 }, -- Crusader Aura

	-- DRUID
	[1126] = { 0.2, 0.8, 0.8 }, -- Mark of the Wild
	[467] = { 0.4, 0.2, 0.8 }, -- Thorns
	[774] = { 0.83, 1.00, 0.25 }, -- Rejuvenation
	[8936] = { 0.33, 0.73, 0.75 }, -- Regrowth
	[29166] = { 0.49, 0.60, 0.55 }, -- Innervate
	[33763] = { 0.33, 0.37, 0.47 }, -- Lifebloom

	-- SHAMAN
	[974] = { 0.2, 0.2, 1 }, -- Earth Shield
	[8185] = { 0.05, 1.00, 0.50 }, -- Fire Resistance Totem
	[5672] = { 0.67, 1.00, 0.50 }, -- Healing Stream Totem
	[5677] = { 0.67, 1.00, 0.80 }, -- Mana Spring Totem
	[8072] = { 0.00, 0.00, 0.26 }, -- Stoneskin Totem
	[8076] = { 0.78, 0.61, 0.43 }, -- Strength of Earth Totem
	[2895] = { 1.00, 1.00, 1.00 }, -- Wrath of Air Totem

	-- WARLOCK
	[5597] = { 0.89, 0.09, 0.05 }, -- Unending Breath
	[6512] = { 0.2, 0.8, 0.2 }, -- Detect Lesser Invisibility
	[6307] = { 0.89, 0.09, 0.05 }, -- Blood Pact
	[24604] = { 0.08, 0.59, 0.41 }, -- Furious Howl

	-- WARRIOR
	[6673] = { 0.2, 0.2, 1 }, -- Battle Shout
	[469] = { 0.4, 0.2, 0.8 }, -- Commanding Shout
}

-- Declare a local function to handle the OnUpdate event
local function OnUpdate(self)
	-- Get the current time
	local currentTime = GetTime()

	-- Calculate the time left by subtracting the current time from the expiration time
	local timeLeft = self.Expiration - currentTime

	-- Get the total duration of the timer
	local totalDuration = self.Duration

	-- Check if the self object has a SetMinMaxValues method
	if self.SetMinMaxValues then
		-- Set the minimum and maximum values for the timer bar
		self:SetMinMaxValues(0, totalDuration)
		-- Set the value of the timer bar based on the time left
		self:SetValue(timeLeft)
	end
end

local function UpdateIcon(self, _, spellID, texture, id, expiration, duration, count)
	local AuraTrack = self.AuraTrack

	if id > AuraTrack.MaxAuras then
		return
	end

	local PositionX = (id * AuraTrack.IconSize) - AuraTrack.IconSize + (AuraTrack.Spacing * id)
	local r, g, b = unpack(Tracker[spellID])

	if not AuraTrack.Auras[id] then
		AuraTrack.Auras[id] = CreateFrame("Frame", nil, AuraTrack)
		AuraTrack.Auras[id]:SetSize(AuraTrack.IconSize, AuraTrack.IconSize)
		AuraTrack.Auras[id]:SetPoint("TOPLEFT", PositionX, AuraTrack.IconSize / 3)

		AuraTrack.Auras[id].Backdrop = AuraTrack.Auras[id]:CreateTexture(nil, "BACKGROUND")
		AuraTrack.Auras[id].Backdrop:SetPoint("TOPLEFT", AuraTrack.Auras[id], -1, 1)
		AuraTrack.Auras[id].Backdrop:SetPoint("BOTTOMRIGHT", AuraTrack.Auras[id], 1, -1)

		if AuraTrack.Auras[id].Backdrop.CreateShadow then
			AuraTrack.Auras[id]:CreateShadow(true)
		end

		AuraTrack.Auras[id].Texture = AuraTrack.Auras[id]:CreateTexture(nil, "ARTWORK")
		AuraTrack.Auras[id].Texture:SetAllPoints()
		AuraTrack.Auras[id].Texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		AuraTrack.Auras[id].Cooldown = CreateFrame("Cooldown", nil, AuraTrack.Auras[id], "CooldownFrameTemplate")
		AuraTrack.Auras[id].Cooldown:SetAllPoints()
		AuraTrack.Auras[id].Cooldown:SetReverse(true)
		AuraTrack.Auras[id].Cooldown:SetHideCountdownNumbers(true)

		AuraTrack.Auras[id].Count = AuraTrack.Auras[id]:CreateFontString(nil, "OVERLAY")
		AuraTrack.Auras[id].Count:SetFont(AuraTrack.Font, 12, "OUTLINE")
		AuraTrack.Auras[id].Count:SetPoint("CENTER", 1, 0)
	end

	AuraTrack.Auras[id].Expiration = expiration
	AuraTrack.Auras[id].Duration = duration
	AuraTrack.Auras[id].Backdrop:SetColorTexture(r * 0.2, g * 0.2, b * 0.2)
	AuraTrack.Auras[id].Cooldown:SetCooldown(expiration - duration, duration)
	AuraTrack.Auras[id]:Show()

	if count and count > 1 then
		AuraTrack.Auras[id].Count:SetText(count)
	else
		AuraTrack.Auras[id].Count:SetText("")
	end

	if AuraTrack.SpellTextures then
		AuraTrack.Auras[id].Texture:SetTexture(texture)
	else
		AuraTrack.Auras[id].Texture:SetColorTexture(r, g, b)
	end
end

local function UpdateBar(self, _, spellID, _, id, expiration, duration)
	local AuraTrack = self.AuraTrack
	local Orientation = self.Health:GetOrientation()
	local Size = Orientation == "HORIZONTAL" and AuraTrack:GetHeight() or AuraTrack:GetWidth()

	AuraTrack.MaxAuras = AuraTrack.MaxAuras or floor(Size / AuraTrack.Thickness)

	if id > AuraTrack.MaxAuras then
		return
	end

	local r, g, b = unpack(Tracker[spellID])
	local Position = (id * AuraTrack.Thickness) - AuraTrack.Thickness
	local X = Orientation == "VERTICAL" and -Position or 0
	local Y = Orientation == "HORIZONTAL" and -Position or 0
	local SizeX = Orientation == "VERTICAL" and AuraTrack.Thickness or AuraTrack:GetWidth()
	local SizeY = Orientation == "VERTICAL" and AuraTrack:GetHeight() or AuraTrack.Thickness

	if not AuraTrack.Auras[id] then
		AuraTrack.Auras[id] = CreateFrame("StatusBar", nil, AuraTrack)

		AuraTrack.Auras[id]:SetSize(SizeX, SizeY)
		AuraTrack.Auras[id]:SetPoint("TOPRIGHT", X, Y)

		if Orientation == "VERTICAL" then
			AuraTrack.Auras[id]:SetOrientation("VERTICAL")
		end

		AuraTrack.Auras[id].Backdrop = AuraTrack.Auras[id]:CreateTexture(nil, "BACKGROUND")
		AuraTrack.Auras[id].Backdrop:SetAllPoints()
	end

	AuraTrack.Auras[id].Expiration = expiration
	AuraTrack.Auras[id].Duration = duration
	AuraTrack.Auras[id]:SetStatusBarTexture(AuraTrack.Texture)
	AuraTrack.Auras[id]:SetStatusBarColor(r, g, b)
	AuraTrack.Auras[id].Backdrop:SetColorTexture(r * 0.2, g * 0.2, b * 0.2)

	if expiration > 0 and duration > 0 then
		AuraTrack.Auras[id]:SetScript("OnUpdate", OnUpdate)
	else
		AuraTrack.Auras[id]:SetScript("OnUpdate", nil)
		AuraTrack.Auras[id]:SetMinMaxValues(0, 1)
		AuraTrack.Auras[id]:SetValue(1)
	end

	AuraTrack.Auras[id]:Show()
end

local function Update(self, _, unit)
	if self.unit ~= unit then
		return
	end

	local ID = 0

	if self.AuraTrack:GetWidth() == 0 then
		return
	end

	self.AuraTrack.MaxAuras = self.AuraTrack.MaxAuras or 4
	self.AuraTrack.Spacing = self.AuraTrack.Spacing or 6
	self.AuraTrack.IconSize = (self.AuraTrack:GetWidth() / self.AuraTrack.MaxAuras) - self.AuraTrack.Spacing - (self.AuraTrack.Spacing / self.AuraTrack.MaxAuras)

	for i = 1, 40 do
		local _, texture, count, _, duration, expiration, caster, _, _, spellID = UnitAura(unit, i, "HELPFUL")

		if self.AuraTrack.Tracker[spellID] and (caster == "player" or caster == "pet") then
			ID = ID + 1

			if self.AuraTrack.Icons then
				UpdateIcon(self, unit, spellID, texture, ID, expiration, duration, count)
			else
				UpdateBar(self, unit, spellID, texture, ID, expiration, duration)
			end
		end
	end

	for i = ID + 1, self.AuraTrack.MaxAuras do
		if self.AuraTrack.Auras[i] and self.AuraTrack.Auras[i]:IsShown() then
			self.AuraTrack.Auras[i]:Hide()
		end
	end
end

local function Path(self, ...)
	return (self.AuraTrack.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local AuraTrack = self.AuraTrack

	if AuraTrack then
		AuraTrack.__owner = self
		AuraTrack.ForceUpdate = ForceUpdate

		AuraTrack.Tracker = AuraTrack.Tracker or Tracker
		AuraTrack.Thickness = AuraTrack.Thickness or 5
		AuraTrack.Texture = AuraTrack.Texture or [[Interface\\TargetingFrame\\UI-StatusBar]]
		AuraTrack.SpellTextures = AuraTrack.SpellTextures or AuraTrack.Icons == nil and true
		AuraTrack.Icons = AuraTrack.Icons or AuraTrack.Icons == nil and true
		AuraTrack.Auras = {}

		self:RegisterEvent("UNIT_AURA", Path)

		return true
	end
end

local function Disable(self)
	local AuraTrack = self.AuraTrack

	if AuraTrack then
		self:UnregisterEvent("UNIT_AURA", Path)
	end
end

oUF:AddElement("AuraTrack", Path, Enable, Disable)
