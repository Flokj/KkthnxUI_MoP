local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]
local GUI = K["GUI"]

local COLORS = COLORS
local FILTERS = FILTERS
local FOCUS = FOCUS
local INTERRUPT = INTERRUPT
local PET = PET
local PLAYER = PLAYER
local SlashCmdList = SlashCmdList
local TARGET = TARGET
local TUTORIAL_TITLE47 = TUTORIAL_TITLE47

local emojiExampleIcon = "|TInterface\\Addons\\KkthnxUI\\Media\\Chat\\Emojis\\StuckOutTongueClosedEyes:0:0:4|t"
local enableTextColor = "|cff00cc4c"
local newFeatureIcon = "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\star:14:14:-2:1|t"

local function updateBagSize()
	K:GetModule("Bags"):UpdateBagSize()
end

local function UpdateBagSortOrder()
	SetSortBagsRightToLeft(not C["Inventory"].ReverseSort)
end

local function UpdateBagStatus()
	K:GetModule("Bags"):UpdateAllBags()
end

local function updateBagAnchor()
	K:GetModule("Bags"):UpdateAllAnchors()
end

local function refreshNameplates()
	K:GetModule("Unitframes"):RefreshAllPlates()
end

local function togglePlatePower()
	K:GetModule("Unitframes"):TogglePlatePower()
end

local function togglePlayerPlate()
	refreshNameplates()
	K:GetModule("Unitframes"):TogglePlayerPlate()
end

local function updateSmoothingAmount()
	K:SetSmoothingAmount(C["General"].SmoothAmount)
end

local function UpdatePlayerBuffs()
	local frame = oUF_Player
	if not frame then return end

	local element = frame.Buffs
	element.iconsPerRow = C["Unitframe"].PlayerBuffsPerRow

	local width = C["Unitframe"].PlayerHealthWidth
	local maxLines = element.iconsPerRow and K.Round(element.num / element.iconsPerRow)
	element.size = K:GetModule("Unitframes").auraIconSize(width, element.iconsPerRow, element.spacing)
	element:SetWidth(width)
	element:SetHeight((element.size + element.spacing) * maxLines)
	element:ForceUpdate()
end

local function UpdatePlayerDebuffs()
	local frame = oUF_Player
	if not frame then return end

	local element = frame.Debuffs
	element.iconsPerRow = C["Unitframe"].PlayerDebuffsPerRow

	local width = C["Unitframe"].PlayerHealthWidth
	local maxLines = element.iconsPerRow and K.Round(element.num / element.iconsPerRow)
	element.size = K:GetModule("Unitframes").auraIconSize(width, element.iconsPerRow, element.spacing)
	element:SetWidth(width)
	element:SetHeight((element.size + element.spacing) * maxLines)
	element:ForceUpdate()
end

local function UpdateTargetBuffs()
	local frame = oUF_Target
	if not frame then return end

	local element = frame.Buffs
	element.iconsPerRow = C["Unitframe"].TargetBuffsPerRow

	local width = C["Unitframe"].TargetHealthWidth
	local maxLines = element.iconsPerRow and K.Round(element.num / element.iconsPerRow)
	element.size = K:GetModule("Unitframes").auraIconSize(width, element.iconsPerRow, element.spacing)
	element:SetWidth(width)
	element:SetHeight((element.size + element.spacing) * maxLines)
	element:ForceUpdate()
end

local function UpdateTargetDebuffs()
	local frame = oUF_Target
	if not frame then return end

	local element = frame.Debuffs
	element.iconsPerRow = C["Unitframe"].TargetDebuffsPerRow

	local width = C["Unitframe"].TargetHealthWidth
	local maxLines = element.iconsPerRow and K.Round(element.num / element.iconsPerRow)
	element.size = K:GetModule("Unitframes").auraIconSize(width, element.iconsPerRow, element.spacing)
	element:SetWidth(width)
	element:SetHeight((element.size + element.spacing) * maxLines)
	element:ForceUpdate()
end

local function UpdateChatSticky()
	K:GetModule("Chat"):ChatWhisperSticky()
end

local function UpdateChatSize()
	K:GetModule("Chat"):UpdateChatSize()
end

local function ToggleChatBackground()
	K:GetModule("Chat"):ToggleChatBackground()
end

local function UpdateChatBubble()
	for _, chatBubble in pairs(C_ChatBubbles.GetAllChatBubbles()) do
		chatBubble.KKUI_Background:SetVertexColor(C["Media"].Backdrops.ColorBackdrop[1], C["Media"].Backdrops.ColorBackdrop[2], C["Media"].Backdrops.ColorBackdrop[3], C["Skins"].ChatBubbleAlpha)
	end
end

local function UpdateMarkerGrid()
	K:GetModule("Miscellaneous"):RaidTool_UpdateGrid()
end

function UpdateActionbar()
	K:GetModule("ActionBar"):UpdateBarVisibility()
end

local function SetABFaderState()
	local Module = K:GetModule("ActionBar")
	if not Module.fadeParent then
		return
	end

	Module.fadeParent:SetAlpha(C["ActionBar"].BarFadeAlpha)
end

local function UpdateABFaderState()
	local Module = K:GetModule("ActionBar")
	if not Module.fadeParent then
		return
	end

	Module:UpdateFaderState()
	Module.fadeParent:SetAlpha(C["ActionBar"].BarFadeAlpha)
end

local function UpdateActionbarHotkeys()
	K:GetModule("ActionBar"):UpdateBarConfig()
end

local function SetupAuraWatch()
	GUI:Toggle()
	SlashCmdList["KKUI_AWCONFIG"]() -- To Be Implemented
end

local function ResetDetails()
	K:GetModule("Skins"):ResetDetailsAnchor(true)
end

local function UpdateTotemBar()
	if not C["Auras"].Totems then return end

	K:GetModule("Auras"):TotemBar_Init()
end

local function UpdateQuestFontSize()
	K:GetModule("Miscellaneous"):CreateQuestSizeUpdate()
end

local function UpdateCustomUnitList()
	K:GetModule("Unitframes"):CreateUnitTable()
end

local function UpdatePowerUnitList()
	K:GetModule("Unitframes"):CreatePowerUnitTable()
end

local function UpdateInterruptAlert()
	K:GetModule("Announcements"):CreateInterruptAnnounce()
end

local function UpdateUnitPlayerSize()
	-- Retrieve dimensions from config, ensuring they are not nil
	local width = C["Unitframe"].PlayerHealthWidth or 190 -- Default width
	local healthHeight = C["Unitframe"].PlayerHealthHeight or 36 -- Default health height
	local powerHeight = C["Unitframe"].PlayerPowerHeight or 16 -- Default power height
	local gap = 6 -- Gap between health and power bars

	-- Calculate total height
	local height = healthHeight + powerHeight + gap

	if not _G.oUF_Player then
		return
	end

	-- Only update if dimensions have changed to improve performance
	if _G.oUF_Player:GetWidth() ~= width or _G.oUF_Player:GetHeight() ~= height then
		_G.oUF_Player:SetSize(width, height)
		_G.oUF_Player.Health:SetHeight(healthHeight)
		_G.oUF_Player.Power:SetHeight(powerHeight)
	end

	-- Update portrait if it's not set to 'NoPortraits'
	if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" and _G.KKUI_PlayerPortrait then
		local portraitSize = height -- Use height for square portraits
		-- Adjust size if necessary, considering different portrait styles might require different sizing logic
		_G.KKUI_PlayerPortrait:SetSize(portraitSize, portraitSize)
	end
end

local function UpdateUnitTargetSize()
	-- Retrieve dimensions from config, ensuring they are not nil
	local width = C["Unitframe"].TargetHealthWidth or 190 -- Default width
	local healthHeight = C["Unitframe"].TargetHealthHeight or 36 -- Default health height
	local powerHeight = C["Unitframe"].TargetPowerHeight or 16 -- Default power height
	local gap = 6 -- Gap between health and power bars

	-- Calculate total height
	local height = healthHeight + powerHeight + gap

	if not _G.oUF_Target then
		return
	end

	-- Only update if dimensions have changed to improve performance
	if _G.oUF_Target:GetWidth() ~= width or _G.oUF_Target:GetHeight() ~= height then
		_G.oUF_Target:SetSize(width, height)
		_G.oUF_Target.Health:SetHeight(healthHeight)
		_G.oUF_Target.Power:SetHeight(powerHeight)
	end

	-- Update portrait if it's not set to 'NoPortraits'
	if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" and _G.KKUI_TargetPortrait then
		local portraitSize = height -- Use height for square portraits
		-- Adjust size if necessary, considering different portrait styles might require different sizing logic
		_G.KKUI_TargetPortrait:SetSize(portraitSize, portraitSize)
	end
end

local function UpdateUnitFocusSize()
	-- Retrieve dimensions from config, ensuring they are not nil
	local width = C["Unitframe"].FocusHealthWidth or 150 -- Default width
	local healthHeight = C["Unitframe"].FocusHealthHeight or 28 -- Default health height
	local powerHeight = C["Unitframe"].FocusPowerHeight or 12 -- Default power height
	local gap = 6 -- Gap between health and power bars

	-- Calculate total height
	local height = healthHeight + powerHeight + gap

	if not _G.oUF_Focus then
		return
	end

	-- Only update if dimensions have changed to improve performance
	if _G.oUF_Focus:GetWidth() ~= width or _G.oUF_Focus:GetHeight() ~= height then
		_G.oUF_Focus:SetSize(width, height)
		_G.oUF_Focus.Health:SetHeight(healthHeight)
		_G.oUF_Focus.Power:SetHeight(powerHeight)
	end

	-- Update portrait if it's not set to 'NoPortraits'
	if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" and _G.KKUI_FocusPortrait then
		local portraitSize = height -- Use height for square portraits
		-- Adjust size if necessary, considering different portrait styles might require different sizing logic
		_G.KKUI_FocusPortrait:SetSize(portraitSize, portraitSize)
	end
end

local function UpdateUnitPartySize()
	-- Retrieve dimensions from config, ensuring they are not nil
	local width = C["Party"].HealthWidth or 150 -- Default width
	local healthHeight = C["Party"].HealthHeight or 22 -- Default health height
	local powerHeight = C["Party"].PowerHeight or 12 -- Default power height
	local gap = 6 -- Gap between health and power bars

	-- Calculate total height
	local height = healthHeight + powerHeight + gap

	for i = 1, _G.MAX_PARTY_MEMBERS do
		local bu = _G["oUF_PartyUnitButton" .. i]
		if bu then
			-- Only update if dimensions have changed to improve performance
			if bu:GetWidth() ~= width or bu:GetHeight() ~= height then
				bu:SetSize(width, height)
				bu.Health:SetHeight(healthHeight)
				bu.Power:SetHeight(powerHeight)
			end

			-- Update portrait for each party member if not 'NoPortraits'
			if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
				-- Note: This assumes there's a unique portrait for each party member.
				-- If not, you might need to adjust this to reference the correct portrait per member.
				local portrait = _G["KKUI_PartyPortrait" .. i]
				if portrait then
					local portraitSize = height -- Use height for square portraits
					portrait:SetSize(portraitSize, portraitSize)
				end
			end
		end
	end
end

local function UpdateUnitRaidSize()
	-- Retrieve dimensions from config, ensuring they are not nil
	local width = C["Raid"].Width or 70 -- Default width
	local healthHeight = C["Raid"].Height or 44 -- Default height
	local height = healthHeight

	-- Check if we're in combat to avoid protected frame errors
	if InCombatLockdown() then
		return
	end

	for i = 1, _G.MAX_RAID_MEMBERS do
		local bu = _G["oUF_Raid" .. i .. "UnitButton" .. i]
		if bu then
			-- Only update if dimensions have changed to improve performance
			if bu:GetWidth() ~= width or bu:GetHeight() ~= height then
				bu:SetSize(width, height)
				bu.Health:SetHeight(healthHeight)
			end
		end
	end
end

local function UpdateMaxZoomLevel()
	K:GetModule("Miscellaneous"):UpdateMaxCameraZoom()
end

local function UpdateActionBar1Scale()
	K:GetModule("ActionBar"):UpdateActionSize("Bar1")
end

local function UpdateActionBar2Scale()
	K:GetModule("ActionBar"):UpdateActionSize("Bar2")
end

local function UpdateActionBar3Scale()
	K:GetModule("ActionBar"):UpdateActionSize("Bar3")
end

local function UpdateActionBar4Scale()
	K:GetModule("ActionBar"):UpdateActionSize("Bar4")
end

local function UpdateActionBar5Scale()
	K:GetModule("ActionBar"):UpdateActionSize("Bar5")
end

local function UpdateActionBar6Scale()
	K:GetModule("ActionBar"):UpdateActionSize("Bar6")
end

local function UpdateActionBar7Scale()
	K:GetModule("ActionBar"):UpdateActionSize("Bar7")
end

local function UpdateActionBar8Scale()
	K:GetModule("ActionBar"):UpdateActionSize("Bar8")
end

local function UpdateActionBarPetScale()
	K:GetModule("ActionBar"):UpdateActionSize("BarPet")
end

local function UpdateActionBarStance()
	K:GetModule("ActionBar"):UpdateStanceBar()
end

local function UpdateActionBarVehicleButton()
	K:GetModule("ActionBar"):UpdateVehicleButton()
end

local function UpdateTotemSize()
	K:GetModule("ActionBar"):UpdateTotemSize()
end

local function UpdateChatButtons()
	K:GetModule("Chat"):UpdateChatButtons()
end

-- Sliders > minvalue, maxvalue, stepvalue
local ActionBar = function(self)
	local Window = self:CreateWindow(L["ActionBar"])

	Window:CreateSection(L["ActionBar 1"])
	Window:CreateSwitch("ActionBar", "Bar1", enableTextColor .. L["Enable ActionBar"] .. " 1", L["Bar1 Desc"], UpdateActionbar)
	Window:CreateSlider("ActionBar", "Bar1Size", L["Button Size"], 20, 80, 1, L["Bar1Size Desc"], UpdateActionBar1Scale)
	Window:CreateSlider("ActionBar", "Bar1PerRow", L["Button PerRow"], 1, 12, 1, L["Bar1PerRow Desc"], UpdateActionBar1Scale)
	Window:CreateSlider("ActionBar", "Bar1Num", L["Button Num"], 1, 12, 1, L["Bar1Num Desc"], UpdateActionBar1Scale)
	Window:CreateSlider("ActionBar", "Bar1Font", L["Button FontSize"], 8, 20, 1, L["Bar1Font Desc"], UpdateActionBar1Scale)
	Window:CreateSwitch("ActionBar", "Bar1Fade", L["Enable Fade for Bar 1"], L["Allows Bar 1 to fade based on the specified conditions"], UpdateABFaderState)

	Window:CreateSection(L["ActionBar 2"])
	Window:CreateSwitch("ActionBar", "Bar2", enableTextColor .. L["Enable ActionBar"] .. " 2", L["Bar2 Desc"], UpdateActionbar)
	Window:CreateSlider("ActionBar", "Bar2Size", L["Button Size"], 20, 80, 1, L["Bar2Size Desc"], UpdateActionBar2Scale)
	Window:CreateSlider("ActionBar", "Bar2PerRow", L["Button PerRow"], 1, 12, 1, L["Bar2PerRow Desc"], UpdateActionBar2Scale)
	Window:CreateSlider("ActionBar", "Bar2Num", L["Button Num"], 1, 12, 1, L["Bar2Num Desc"], UpdateActionBar2Scale)
	Window:CreateSlider("ActionBar", "Bar2Font", L["Button FontSize"], 8, 20, 1, L["Bar2Font Desc"], UpdateActionBar2Scale)
	Window:CreateSwitch("ActionBar", "Bar2Fade", L["Enable Fade for Bar 2"], L["Allows Bar 2 to fade based on the specified conditions"], UpdateABFaderState)

	Window:CreateSection(L["ActionBar 3"])
	Window:CreateSwitch("ActionBar", "Bar3", enableTextColor .. L["Enable ActionBar"] .. " 3", L["Bar3 Desc"], UpdateActionbar)
	Window:CreateSlider("ActionBar", "Bar3Size", L["Button Size"], 20, 80, 1, L["Bar3Size Desc"], UpdateActionBar3Scale)
	Window:CreateSlider("ActionBar", "Bar3PerRow", L["Button PerRow"], 1, 12, 1, L["Bar3PerRow Desc"], UpdateActionBar3Scale)
	Window:CreateSlider("ActionBar", "Bar3Num", L["Button Num"], 1, 12, 1, L["Bar3Num Desc"], UpdateActionBar3Scale)
	Window:CreateSlider("ActionBar", "Bar3Font", L["Button FontSize"], 8, 20, 1, L["Bar3Font Desc"], UpdateActionBar3Scale)
	Window:CreateSwitch("ActionBar", "Bar3Fade", L["Enable Fade for Bar 3"], L["Allows Bar 3 to fade based on the specified conditions"], UpdateABFaderState)

	Window:CreateSection(L["ActionBar 4"])
	Window:CreateSwitch("ActionBar", "Bar4", enableTextColor .. L["Enable ActionBar"] .. " 4", L["Bar4 Desc"], UpdateActionbar)
	Window:CreateSlider("ActionBar", "Bar4Size", L["Button Size"], 20, 80, 1, L["Bar4Size Desc"], UpdateActionBar4Scale)
	Window:CreateSlider("ActionBar", "Bar4PerRow", L["Button PerRow"], 1, 12, 1, L["Bar4PerRow Desc"], UpdateActionBar4Scale)
	Window:CreateSlider("ActionBar", "Bar4Num", L["Button Num"], 1, 12, 1, L["Bar4Num Desc"], UpdateActionBar4Scale)
	Window:CreateSlider("ActionBar", "Bar4Font", L["Button FontSize"], 8, 20, 1, L["Bar4Font Desc"], UpdateActionBar4Scale)
	Window:CreateSwitch("ActionBar", "Bar4Fade", L["Enable Fade for Bar 4"], L["Allows Bar 4 to fade based on the specified conditions"], UpdateABFaderState)

	Window:CreateSection(L["ActionBar 5"])
	Window:CreateSwitch("ActionBar", "Bar5", enableTextColor .. L["Enable ActionBar"] .. " 5", L["Bar5 Desc"], UpdateActionbar)
	Window:CreateSlider("ActionBar", "Bar5Size", L["Button Size"], 20, 80, 1, L["Bar5Size Desc"], UpdateActionBar5Scale)
	Window:CreateSlider("ActionBar", "Bar5PerRow", L["Button PerRow"], 1, 12, 1, L["Bar5PerRow Desc"], UpdateActionBar5Scale)
	Window:CreateSlider("ActionBar", "Bar5Num", L["Button Num"], 1, 12, 1, L["Bar5Num Desc"], UpdateActionBar5Scale)
	Window:CreateSlider("ActionBar", "Bar5Font", L["Button FontSize"], 8, 20, 1, L["Bar5Font Desc"], UpdateActionBar5Scale)
	Window:CreateSwitch("ActionBar", "Bar5Fade", L["Enable Fade for Bar 5"], L["Allows Bar 5 to fade based on the specified conditions"], UpdateABFaderState)

	Window:CreateSection(L["ActionBar 6"])
	Window:CreateSwitch("ActionBar", "Bar6", enableTextColor .. L["Enable ActionBar"] .. " 6", L["Bar6 Desc"], UpdateActionbar)
	Window:CreateSlider("ActionBar", "Bar6Size", L["Button Size"], 20, 80, 1, L["Bar6Size Desc"], UpdateActionBar6Scale)
	Window:CreateSlider("ActionBar", "Bar6PerRow", L["Button PerRow"], 1, 12, 1, L["Bar6PerRow Desc"], UpdateActionBar6Scale)
	Window:CreateSlider("ActionBar", "Bar6Num", L["Button Num"], 1, 12, 1, L["Bar6Num Desc"], UpdateActionBar6Scale)
	Window:CreateSlider("ActionBar", "Bar6Font", L["Button FontSize"], 8, 20, 1, L["Bar6Font Desc"], UpdateActionBar6Scale)
	Window:CreateSwitch("ActionBar", "Bar6Fade", L["Enable Fade for Bar 6"], L["Allows Bar 6 to fade based on the specified conditions"], UpdateABFaderState)

	Window:CreateSection(L["ActionBar 7"])
	Window:CreateSwitch("ActionBar", "Bar7", enableTextColor .. L["Enable ActionBar"] .. " 7", L["Bar7 Desc"], UpdateActionbar)
	Window:CreateSlider("ActionBar", "Bar7Size", L["Button Size"], 20, 80, 1, L["Bar7Size Desc"], UpdateActionBar7Scale)
	Window:CreateSlider("ActionBar", "Bar7PerRow", L["Button PerRow"], 1, 12, 1, L["Bar7PerRow Desc"], UpdateActionBar7Scale)
	Window:CreateSlider("ActionBar", "Bar7Num", L["Button Num"], 1, 12, 1, L["Bar7Num Desc"], UpdateActionBar7Scale)
	Window:CreateSlider("ActionBar", "Bar7Font", L["Button FontSize"], 8, 20, 1, L["Bar7Font Desc"], UpdateActionBar7Scale)
	Window:CreateSwitch("ActionBar", "Bar7Fade", L["Enable Fade for Bar 7"], L["Allows Bar 7 to fade based on the specified conditions"], UpdateABFaderState)

	Window:CreateSection(L["ActionBar 8"])
	Window:CreateSwitch("ActionBar", "Bar8", enableTextColor .. L["Enable ActionBar"] .. " 8", L["Bar8 Desc"], UpdateActionbar)
	Window:CreateSlider("ActionBar", "Bar8Size", L["Button Size"], 20, 80, 1, L["Bar8Size Desc"], UpdateActionBar8Scale)
	Window:CreateSlider("ActionBar", "Bar8PerRow", L["Button PerRow"], 1, 12, 1, L["Bar8PerRow Desc"], UpdateActionBar8Scale)
	Window:CreateSlider("ActionBar", "Bar8Num", L["Button Num"], 1, 12, 1, L["Bar8Num Desc"], UpdateActionBar8Scale)
	Window:CreateSlider("ActionBar", "Bar8Font", L["Button FontSize"], 8, 20, 1, L["Bar8Font Desc"], UpdateActionBar8Scale)
	Window:CreateSwitch("ActionBar", "Bar8Fade", L["Enable Fade for Bar 8"], L["Allows Bar 8 to fade based on the specified conditions"], UpdateABFaderState)

	Window:CreateSection(L["ActionBar Pet"])
	Window:CreateSlider("ActionBar", "BarPetSize", L["Button Size"], 20, 80, 1, L["BarPetSize Desc"], UpdateActionBarPetScale)
	Window:CreateSlider("ActionBar", "BarPetPerRow", L["Button PerRow"], 1, 12, 1, L["BarPetPerRow Desc"], UpdateActionBarPetScale)
	Window:CreateSlider("ActionBar", "BarPetFont", L["Button FontSize"], 8, 20, 1, L["BarPetFont Desc"], UpdateActionBarPetScale)
	Window:CreateSwitch("ActionBar", "BarPetFade", L["Enable Fade for Pet Bar"], L["Allows the Pet Bar to fade based on the specified conditions"], UpdateABFaderState)

	Window:CreateSection(L["ActionBar Stance"])
	Window:CreateSwitch("ActionBar", "ShowStance", enableTextColor .. L["Enable StanceBar"], L["ShowStance Desc"])
	Window:CreateSlider("ActionBar", "BarStanceSize", L["Button Size"], 20, 80, 1, L["BarStanceSize Desc"], UpdateActionBarStance)
	Window:CreateSlider("ActionBar", "BarStancePerRow", L["Button PerRow"], 1, 12, 1, L["BarStancePerRow Desc"], UpdateActionBarStance)
	Window:CreateSlider("ActionBar", "BarStanceFont", L["Button FontSize"], 8, 20, 1, L["BarStanceFont Desc"], UpdateActionBarStance)
	Window:CreateSwitch("ActionBar", "BarStanceFade", L["Enable Fade for Stance Bar"], L["Allows the Stance Bar to fade based on the specified conditions"], UpdateABFaderState)

	if K.Class == "SHAMAN" then
		Window:CreateSection(newFeatureIcon .. "TotemBar")
		Window:CreateSwitch("ActionBar", "TotemBar", enableTextColor .. "Enable TotemBar")
		Window:CreateSlider("ActionBar", "TotemBarSize", "Button Totem Size", 24, 60, 1, nil, UpdateTotemSize)
	end
	
	Window:CreateSection(L["ActionBar Vehicle"])
	Window:CreateSlider("ActionBar", "VehButtonSize", L["Button Size"], 20, 80, 1, L["VehButtonSize Desc"], UpdateActionBarVehicleButton)

	Window:CreateSection(L["Toggles"])
	Window:CreateSwitch("ActionBar", "EquipColor", L["Equip Color"], L["EquipColor Desc"], UpdateActionbarHotkeys)
	Window:CreateSwitch("ActionBar", "Grid", L["Actionbar Grid"], L["Grid Desc"], UpdateActionbarHotkeys)
	Window:CreateSwitch("ActionBar", "Hotkeys", L["Enable Hotkey"], L["Hotkeys Desc"], UpdateActionbarHotkeys)
	Window:CreateSwitch("ActionBar", "Macro", L["Enable Macro"], L["Macro Desc"], UpdateActionbarHotkeys)
	Window:CreateSwitch("ActionBar", "KeyDown", newFeatureIcon .. L["Cast on Key Press"], L["Cast spells and abilities on key press, not key release"], UpdateActionbarHotkeys)
	Window:CreateSwitch("ActionBar", "ButtonLock", newFeatureIcon .. L["Lock Action Bars"], L["Keep your action bar layout locked in place to prevent accidental reordering. To move a spell or ability while locked, hold the Shift key."], UpdateActionbarHotkeys)
	Window:CreateSwitch("ActionBar", "Cooldown", L["Show Cooldowns"], L["Cooldown Desc"])
	Window:CreateSwitch("ActionBar", "MicroMenu", L["Enable MicroBar"], L["MicroMenu Desc"])
	Window:CreateSwitch("ActionBar", "FadeMicroMenu", L["Mouseover MicroBar"], L["FadeMicroMenu Desc"])
	Window:CreateSwitch("ActionBar", "OverrideWA", L["Enable OverrideWA"], L["OverrideWA Desc"])
	Window:CreateSlider("ActionBar", "MmssTH", L["MMSSThreshold"], 60, 600, 1, L["MMSSThresholdTip"])
	Window:CreateSlider("ActionBar", "TenthTH", L["TenthThreshold"], 0, 60, 1, L["TenthThresholdTip"])

	Window:CreateSection(L["Fader Options"])
	Window:CreateSwitch("ActionBar", "BarFadeGlobal", L["Enable Global Fade"], L["BarFadeGlobal Desc"])
	Window:CreateSlider("ActionBar", "BarFadeAlpha", L["Fade Alpha"], 0, 1, 0.1, L["BarFadeAlpha Desc"], SetABFaderState)
	Window:CreateSlider("ActionBar", "BarFadeDelay", L["Fade Delay"], 0, 3, 0.1, L["BarFadeDelay Desc"])
	Window:CreateSwitch("ActionBar", "BarFadeCombat", L["Fade Out of Combat"], L["BarFadeCombat Desc"])
	Window:CreateSwitch("ActionBar", "BarFadeTarget", L["Fade without Target"], L["BarFadeTarget Desc"])
	Window:CreateSwitch("ActionBar", "BarFadeCasting", L["Fade While Casting"], L["BarFadeCasting Desc"])
	Window:CreateSwitch("ActionBar", "BarFadeHealth", L["Fade on Full Health"], L["BarFadeHealth Desc"])
	Window:CreateSwitch("ActionBar", "BarFadeVehicle", L["Fade in Vehicle"], L["BarFadeVehicle Desc"])
end

local Announcements = function(self)
	local Window = self:CreateWindow(L["Announcements"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Announcements", "ItemAlert", L["Announce Spells And Items"], "Alerts the group when specific spells or items are used.")
	Window:CreateSwitch("Announcements", "PullCountdown", L["Announce Pull Countdown (/pc #)"], "Announces the pull countdown timer to your group or raid.")
	Window:CreateSwitch("Announcements", "ResetInstance", L["Alert Group After Instance Resetting"], "Notifies the group when the instance is reset.")

	Window:CreateSection(L["Combat"])
	Window:CreateSwitch("Announcements", "SaySapped", L["Announce When Sapped"], "Automatically announces in chat when you are sapped in PvP.")
	Window:CreateSwitch("Announcements", "PvPEmote", L["Auto Emote On Your Killing Blow"], "Automatically performs an emote when you land a killing blow in PvP.")
	Window:CreateSwitch("Announcements", "HealthAlert", L["Announce When Low On Health"], "Alerts when your health drops below a critical threshold.")

	Window:CreateSection(INTERRUPT)
	Window:CreateSwitch("Announcements", "InterruptAlert", enableTextColor .. L["Announce Interrupts"], "Announces when you successfully interrupt a spell.", UpdateInterruptAlert)
	Window:CreateSwitch("Announcements", "DispellAlert", enableTextColor .. L["Announce Dispels"], "Announces when you successfully dispel an effect.", UpdateInterruptAlert)
	Window:CreateSwitch("Announcements", "BrokenAlert", enableTextColor .. L["Announce Broken Spells"], "Alerts the group when a spell is broken (e.g., crowd control spells).", UpdateInterruptAlert)
	Window:CreateSwitch("Announcements", "OwnInterrupt", L["Only Announce Own Interrupts"], "Limits interrupt announcements to only those you perform.")
	Window:CreateSwitch("Announcements", "OwnDispell", L["Only Announce Own Dispels"], "Limits dispel announcements to only those you perform.")
	Window:CreateSwitch("Announcements", "InstAlertOnly", L["Announce Only In Instances"], "Restricts announcements to dungeons, raids, and other instances.", UpdateInterruptAlert)
	Window:CreateDropdown("Announcements", "AlertChannel", L["Announce Interrupts To Specified Chat Channel"], "Select the chat channel where interrupt and dispel alerts will be sent.")

	Window:CreateSection(L["QuestNotifier"])
	Window:CreateSwitch("Announcements", "QuestNotifier", enableTextColor .. L["Enable QuestNotifier"], "Enables notifications related to quest progress and completion.")
	Window:CreateSwitch("Announcements", "OnlyCompleteRing", L["Only Play Complete Quest Sound"], "Plays a sound only when a quest is fully completed.")
	Window:CreateSwitch("Announcements", "QuestProgress", L["Alert QuestProgress In Chat"], "Sends quest progress updates to chat.")
end

local Automation = function(self)
	local Window = self:CreateWindow(L["Automation"])

	Window:CreateSection(L["Invite Management"])
	Window:CreateSwitch("Automation", "AutoInvite", L["Accept Invites From Friends & Guild Members"], "Automatically accepts group invitations from friends or guild members.")
	Window:CreateSwitch("Automation", "AutoDeclineDuels", L["Decline PvP Duels"], "Automatically declines all PvP duel requests.")
	Window:CreateSwitch("Automation", "AutoLoggingCombat", "Auto enables Combat Log in raid instances")
	Window:CreateEditBox("Automation", "WhisperInvite", L["Auto Accept Invite Keyword"], L["Enter a keyword that will trigger automatic acceptance of invites sent via whispers."])

	Window:CreateSection(L["Auto-Resurrect Options"])
	Window:CreateSwitch("Automation", "AutoResurrect", L["Auto Accept Resurrect Requests"], "Automatically accepts resurrection requests during combat or in dungeons.")
	Window:CreateSwitch("Automation", "AutoResurrectThank", L["Say 'Thank You' When Resurrected"], "Sends a 'Thank you' message to the player who resurrects you.")

	Window:CreateSection(L["Auto-Reward Options"])
	Window:CreateSwitch("Automation", "AutoReward", L["Auto Select Quest Rewards Best Value"], "Automatically selects the highest value quest reward.")

	Window:CreateSection(L["Miscellaneous Options"])
	-- Window:CreateSwitch("Automation", "AutoCollapse", L["Auto Collapse Objective Tracker"], "Automatically collapses the objective tracker when entering an instance.")
	Window:CreateSwitch("Automation", "AutoOpenItems", L["Auto Open Items In Your Inventory"], "Automatically opens items in your inventory that contain loot.")
	Window:CreateSwitch("Automation", "AutoRelease", L["Auto Release in Battlegrounds & Arenas"], "Automatically releases your spirit upon death in battlegrounds or arenas.")
	Window:CreateSwitch("Automation", "AutoSkipCinematic", L["Auto Skip All Cinematics/Movies"], "Automatically skips cinematics and movies during gameplay.")
	Window:CreateSwitch("Automation", "AutoSummon", L["Auto Accept Summon Requests"], "Automatically accepts summon requests from your group or raid.")
	Window:CreateSwitch("Automation", "NoBadBuffs", L["Automatically Remove Annoying Buffs"], "Automatically removes unwanted or annoying buffs.")
end

local Inventory = function(self)
	local Window = self:CreateWindow(L["Inventory"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Inventory", "Enable", enableTextColor .. L["Enable Inventory"], L["Enable Desc"])
	Window:CreateSwitch("Inventory", "AutoSell", L["Auto Vendor Grays"])

	Window:CreateSection("Bags")
	Window:CreateSwitch("Inventory", "BagsBindOnEquip", newFeatureIcon .. L["Display Bind Status"], L["BagsBindOnEquip Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "BagsItemLevel", L["Display Item Level"], L["BagsItemLevel Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "DeleteButton", L["Bags Delete Button"])
	Window:CreateSwitch("Inventory", "ReverseSort", L["Reverse the Sorting"], L["ReverseSort Desc"], UpdateBagSortOrder)
	Window:CreateSwitch("Inventory", "ShowNewItem", L["Show New Item Glow"])
	Window:CreateSwitch("Inventory", "SpecialBagsColor", "Color Special Bags", "Color Special Bags:|n- |cffabda74Hunter's Quiver or Ammo Pouch|r|n- |cff8787edWarlock's Soul Pouch|r|n- |cffc800c8Enchanting Mageweave Pouch|r|n- |cff008000Herbalist's Herb Pouch|r")
	Window:CreateSlider("Inventory", "BagsPerRow", L["Bags Per Row"], 1, 20, 1, L["BagsPerRow Desc"], updateBagAnchor)

	Window:CreateSection(BANK)
	Window:CreateSlider("Inventory", "BankPerRow", L["Bank Bags Per Row"], 1, 20, 1, L["BankPerRow Desc"], updateBagAnchor)

	Window:CreateSection(OTHER)
	Window:CreateDropdown("Inventory", "AutoRepair", L["Auto Repair Gear"])

	Window:CreateSection(FILTERS)
	Window:CreateSwitch("Inventory", "FilterAmmo", L["Filter Ammo Items"], nil, UpdateBagStatus)
	Window:CreateSwitch("Inventory", "FilterBOE", L["Filter BoE"], nil, UpdateBagStatus)
	Window:CreateSwitch("Inventory", "ItemFilter", L["Filter Items Into Categories"], L["ItemFilter Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "FilterCollection", L["Filter Collection Items"], L["FilterCollection Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "FilterConsumable", L["Filter Consumable Items"], L["FilterConsumable Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "FilterCustom", L["Filter Custom Items"], L["FilterCustom Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "FilterEquipSet", L["Filter EquipSet"], L["FilterEquipSet Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "FilterEquipment", L["Filter Equipment Items"], L["FilterEquipment Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "FilterGoods", L["Filter Goods Items"], L["FilterGoods Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "FilterJunk", L["Filter Junk Items"], L["FilterJunk Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "FilterLegendary", L["Filter Legendary Items"], L["FilterLegendary Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "FilterQuest", L["Filter Quest Items"], L["FilterQuest Desc"], UpdateBagStatus)
	Window:CreateSwitch("Inventory", "GatherEmpty", L["Gather Empty Slots Into One Button"], L["GatherEmpty Desc"], UpdateBagStatus)

	Window:CreateSection(L["Sizes"])
	Window:CreateSlider("Inventory", "BagsWidth", L["Bags Width"], 8, 16, 1, L["BagsWidth Desc"], updateBagSize)
	Window:CreateSlider("Inventory", "BankWidth", L["Bank Width"], 10, 18, 1, L["BankWidth Desc"], updateBagSize)
	Window:CreateSlider("Inventory", "IconSize", L["Slot Icon Size"], 28, 40, 1, L["IconSize Desc"], updateBagSize)

	Window:CreateSection(L["Bag Bar"])
	Window:CreateSwitch("Inventory", "BagBar", enableTextColor .. L["Enable Bagbar"], L["BagBar Desc"])
	Window:CreateSwitch("Inventory", "JustBackpack", L["Just Show Main Backpack"], L["JustBackpack Desc"])
	Window:CreateSwitch("Inventory", "BagBarMouseover", "Show Bag Bar On Mouseover")
	Window:CreateSlider("Inventory", "BagBarSize", L["BagBar Size"], 20, 34, 1, L["BagBarSize Desc"])
	Window:CreateDropdown("Inventory", "GrowthDirection", L["Growth Direction"], L["GrowthDirection Desc"])
	Window:CreateDropdown("Inventory", "SortDirection", L["Sort Direction"])
end

local Auras = function(self)
	local Window = self:CreateWindow(L["Auras"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Auras", "Enable", enableTextColor .. L["Enable Auras"], L["Enable Desc"])
	Window:CreateSwitch("Auras", "HideBlizBuff", L["Hide The Default BuffFrame"], L["HideBlizBuff Desc"])
	Window:CreateSwitch("Auras", "Reminder", L["Auras Reminder (Shout/Intellect/Poison)"], L["Reminder Desc"])
	Window:CreateSwitch("Auras", "ReverseBuffs", L["Buffs Grow Right"], L["ReverseBuffs Desc"])
	Window:CreateSwitch("Auras", "ReverseDebuffs", L["Debuffs Grow Right"])

	Window:CreateSection(L["Sizes"])
	Window:CreateSlider("Auras", "BuffSize", L["Buff Icon Size"], 20, 40, 1, L["AuraSize Desc"])
	Window:CreateSlider("Auras", "BuffsPerRow", L["Buffs per Row"], 10, 20, 1, L["BuffsPerRow Desc"])
	Window:CreateSlider("Auras", "DebuffSize", L["DeBuff Icon Size"], 20, 40, 1, L["AuraSize Desc"])
	Window:CreateSlider("Auras", "DebuffsPerRow", L["DeBuffs per Row"], 10, 16, 1, L["DebuffsPerRow Desc"])

	Window:CreateSection(TUTORIAL_TITLE47)
	Window:CreateSwitch("Auras", "Totems", enableTextColor .. L["Enable TotemBar"], L["Totems Desc"])
	Window:CreateSwitch("Auras", "VerticalTotems", L["Vertical TotemBar"], L["VerticalTotems Desc"], UpdateTotemBar)
	Window:CreateSlider("Auras", "TotemSize", L["Totems IconSize"], 24, 60, 1, L["TotemSize Desc"], UpdateTotemBar)
end

local AuraWatch = function(self)
	local Window = self:CreateWindow(L["AuraWatch"])

	Window:CreateSection(GENERAL)
	Window:CreateButton(L["AuraWatch GUI"], nil, nil, SetupAuraWatch)
	Window:CreateSwitch("AuraWatch", "Enable", enableTextColor .. L["Enable AuraWatch"], L["Enable Desc"])
	Window:CreateSwitch("AuraWatch", "ClickThrough", L["Disable AuraWatch Tooltip (ClickThrough)"], "If enabled, the icon would be uninteractable, you can't select or mouseover them.")
	Window:CreateSlider("AuraWatch", "IconScale", L["AuraWatch IconScale"], 0.8, 2, 0.1)
	Window:CreateSlider("AuraWatch", "MinCD", L["AuraWatch MinCD"], 1, 60, 1, L["MinCDTip"])
end

local Chat = function(self)
	local Window = self:CreateWindow(L["Chat"])

	-- General chat settings
	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Chat", "Enable", enableTextColor .. L["Enable Chat"], L["Enable Desc"])
	Window:CreateSwitch("Chat", "Lock", L["Lock Chat"], L["Lock Desc"])
	Window:CreateSwitch("Chat", "Background", L["Show Chat Background"], L["Background Desc"], ToggleChatBackground)
	Window:CreateSwitch("Chat", "OldChatNames", L["Use Default Channel Names"], L["OldChatNames Desc"])

	-- Chat appearance
	Window:CreateSwitch("Chat", "Chatbar", "Show Chat Bars")
	Window:CreateSwitch("Chat", "ChatClassColor", "Most Class Color in Chat and chat Bubbles")
	Window:CreateSwitch("Chat", "ChatItemGem", "Show Item Gem in ChatFrames")
	Window:CreateSwitch("Chat", "CopyButton", newFeatureIcon .. "Enable Copy Chat Button |TInterface\\Buttons\\UI-GuildButton-PublicNote-Up:14:14|t", "Enable or disable the Copy Chat button, which allows you to copy chat text.", UpdateChatButtons)
	Window:CreateSwitch("Chat", "ConfigButton", newFeatureIcon .. "Enable Config Button |TInterface\\Buttons\\UI-OptionsButton:14:14|t", "Enable or disable the Config button, which provides quick access to the configuration menu.", UpdateChatButtons)
	Window:CreateSwitch("Chat", "RollButton", newFeatureIcon .. "Enable Roll Button |A:charactercreate-icon-dice:14:14|a", "Enable or disable the Roll button, which allows you to roll a random number between 1 and 100.", UpdateChatButtons)
	Window:CreateSection(L["Appearance"])
	Window:CreateSwitch("Chat", "Emojis", L["Show Emojis In Chat"] .. emojiExampleIcon, L["Emojis Desc"])
	Window:CreateSwitch("Chat", "ChatItemLevel", L["Show ItemLevel on ChatFrames"], L["ChatItemLevel Desc"])
	Window:CreateDropdown("Chat", "TimestampFormat", L["Custom Chat Timestamps"], L["TimestampFormat Desc"])

	-- Chat behavior
	Window:CreateSection(L["Behavior"])
	Window:CreateSwitch("Chat", "Freedom", L["Disable Chat Language Filter"], L["Freedom Desc"])
	Window:CreateSwitch("Chat", "ChatMenu", L["Show Chat Menu Buttons"], L["ChatMenu Desc"])
	Window:CreateSwitch("Chat", "Sticky", L["Stick On Channel If Whispering"], L["Sticky Desc"], UpdateChatSticky)
	Window:CreateSwitch("Chat", "WhisperColor", L["Differ Whisper Colors"])

	Window:CreateSection(L["Sizes"])
	Window:CreateSlider("Chat", "Height", L["Lock Chat Height"], 100, 500, 1, L["Height Desc"], UpdateChatSize)
	Window:CreateSlider("Chat", "Width", L["Lock Chat Width"], 200, 600, 1, L["Width Desc"], UpdateChatSize)
	Window:CreateSlider("Chat", "LogMax", L["Chat History Lines To Save"], 0, 500, 10, L["LogMax Desc"])

	Window:CreateSection(L["Fading"])
	Window:CreateSwitch("Chat", "Fading", L["Fade Chat Text"])
	Window:CreateSlider("Chat", "FadingTimeVisible", L["Fading Chat Visible Time"], 5, 120, 1, L["FadingTimeVisible Desc"])
end

local DataText = function(self)
	local Window = self:CreateWindow(L["DataText"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("DataText", "Coords", L["Enable Positon Coords"], L["Coords Desc"])
	Window:CreateSwitch("DataText", "Friends", L["Enable Friends Info"], L["Friends Desc"])
	Window:CreateSwitch("DataText", "Gold", L["Enable Currency Info"], L["Gold Desc"])
	Window:CreateSwitch("DataText", "Guild", L["Enable Guild Info"], L["Guild Desc"])
	Window:CreateSwitch("DataText", "Latency", L["Enable Latency Info"], L["Latency Desc"])
	Window:CreateSwitch("DataText", "Location", L["Enable Minimap Location"], L["Location Desc"])
	Window:CreateSwitch("DataText", "Spec", L["Enable Specialization Info"], L["Spec Desc"])
	Window:CreateSwitch("DataText", "System", L["Enable System Info"], L["System Desc"])
	Window:CreateSwitch("DataText", "Time", L["Enable Minimap Time"], L["Time Desc"])

	-- Section: Icon Colors
	Window:CreateSection(L["Icon Colors"])
	Window:CreateColorSelection("DataText", "IconColor", L["Color The Icons"], L["IconColor Desc"])

	-- Section: Text Toggles
	Window:CreateSection(L["Text Toggles"])
	Window:CreateSwitch("DataText", "HideText", L["Hide Icon Text"], L["HideText Desc"])
end

local General = function(self)
	local Window = self:CreateWindow(L["General"], true)

	-- Profiles
	Window:CreateSection(L["Profiles"])
	local AddProfile = Window:CreateDropdown("General", "Profiles", L["Import Profiles From Other Characters"], L["Profiles Desc"])
	AddProfile.Menu:HookScript("OnHide", GUI.SetProfile)

	-- Delete Profile Dropdown
	local DeleteProfileDropdown = Window:CreateDropdown("General", "DeleteProfiles", "Delete Profile", "Select a profile to delete, You pick a profile from the dropdown, and then press the button to delete it!")

	-- Delete Profile Button
	Window:CreateButton("Press To Delete", "Delete the selected profile from your list.", "", function()
		local profileToDelete = C["General"].DeleteProfiles.Value

		if profileToDelete then
			local server, nickname = strsplit("-", profileToDelete)
			if KkthnxUIDB.Settings[server] and KkthnxUIDB.Settings[server][nickname] then
				KkthnxUIDB.Settings[server][nickname] = nil
				if KkthnxUIDB.Variables[server] then
					KkthnxUIDB.Variables[server][nickname] = nil
				end
				print("Profile deleted: " .. profileToDelete)

				-- Clear the dropdown value and text
				C["General"].DeleteProfiles.Value = nil
				if DeleteProfileDropdown then
					DeleteProfileDropdown.Current:SetText("")
					DeleteProfileDropdown.Value = nil
				end

				-- Refresh the options and update dropdown
				KKUI_LoadDeleteProfiles()
				KKUI_LoadProfiles()

				if DeleteProfileDropdown and DeleteProfileDropdown.Update then
					DeleteProfileDropdown:Update()
				end
			end
		end
	end)

	-- Toggles
	Window:CreateSection(GENERAL)
	Window:CreateSwitch("General", "MinimapIcon", L["Enable Minimap Icon"], L["MinimapIcon Desc"])
	Window:CreateSwitch("General", "MoveBlizzardFrames", L["Move Blizzard Frames"], L["MoveBlizzardFrames Desc"])
	Window:CreateSwitch("General", "NoErrorFrame", L["Disable Blizzard Error Frame Combat"])
	Window:CreateSwitch("General", "NoTutorialButtons", L["Disable 'Some' Blizzard Tutorials"], L["NoTutorialButtons Desc"])

	Window:CreateDropdown("General", "GlowMode", L["Button Glow Mode"], L["GlowMode Desc"])

	-- Border Style
	Window:CreateDropdown("General", "BorderStyle", L["Border Style"])

	-- Number Prefix Style
	Window:CreateDropdown("General", "NumberPrefixStyle", L["Number Prefix Style"])

	-- Smoothing Amount
	Window:CreateSlider("General", "SmoothAmount", "SmoothAmount", 0.1, 1, 0.01, L["Setup healthbar smooth frequency for unitframes and nameplates. The lower the smoother."], updateSmoothingAmount)

	-- Scaling
	Window:CreateSection(L["Scaling"])
	Window:CreateSwitch("General", "AutoScale", L["Auto Scale"], L["AutoScaleTip"])
	Window:CreateSlider("General", "UIScale", L["Set UI scale"], 0.4, 1.15, 0.01, L["UIScaleTip"])

	-- Colors
	Window:CreateSection(COLORS)
	Window:CreateSwitch("General", "ColorTextures", L["Color 'Most' KkthnxUI Borders"], L["ColorTextures Desc"])
	Window:CreateColorSelection("General", "TexturesColor", L["Textures Color"])

	-- Texture
	Window:CreateSection(L["Texture"])
	Window:CreateDropdown("General", "Texture", L["Set General Texture"], L["Texture Desc"], "Texture")
end

local Loot = function(self)
	local Window = self:CreateWindow(L["Loot"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Loot", "Enable", enableTextColor .. L["Enable Loot"], L["Enable Desc"])
	Window:CreateSwitch("Loot", "GroupLoot", enableTextColor .. L["Enable Group Loot"], L["GroupLoot Desc"], UpdateGroupLoot)

	Window:CreateSection(L["Auto-Looting"])
	Window:CreateSwitch("Loot", "FastLoot", L["Faster Auto-Looting"], L["FastLoot Desc"])

	Window:CreateSection(L["Auto-Confirm"])
	Window:CreateSwitch("Loot", "AutoConfirmLoot", L["Auto Confirm Loot Dialogs"])
	Window:CreateSwitch("Loot", "AutoGreed", L["Auto Greed Green Items"], L["AutoGreed Desc"])
end

local Minimap = function(self)
	local Window = self:CreateWindow(L["Minimap"])

	-- General Section
	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Minimap", "Enable", enableTextColor .. L["Enable Minimap"], L["Enable Desc"])
	Window:CreateSwitch("Minimap", "Calendar", L["Show Minimap Calendar"], L["If enabled, show minimap calendar icon on minimap.|nYou can simply click mouse middle button on minimap to toggle calendar even without this option."])

	-- Features Section
	Window:CreateSection(L["Features"])
	Window:CreateSwitch("Minimap", "EasyVolume", newFeatureIcon .. L["EasyVolume"], L["EasyVolumeTip"])
	Window:CreateSwitch("Minimap", "MailPulse", newFeatureIcon .. L["Pulse Minimap Mail"], L["MailPulse Desc"])
	Window:CreateSwitch("Minimap", "ShowRecycleBin", L["Show Minimap Button Collector"], L["ShowRecycleBin Desc"])

	-- Recycle Bin Section
	Window:CreateSection(L["Recycle Bin"])
	Window:CreateDropdown("Minimap", "RecycleBinPosition", L["Set RecycleBin Positon"], L["RecycleBinPosition Desc"])

	-- Location Section
	Window:CreateSection(L["Location"])
	Window:CreateDropdown("Minimap", "LocationText", L["Location Text Style"])

	-- Size Section
	Window:CreateSection(L["Size"])
	Window:CreateSlider("Minimap", "Size", L["Minimap Size"], 120, 300, 1, L["Size Desc"])
end

local Misc = function(self)
	local Window = self:CreateWindow(L["Misc"])

	-- General Section
	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Misc", "AlreadyKnown", "Highlight Already Known Items", "Highlights items you already know in various frames such as the merchant, auction house, and guild bank.")
	Window:CreateSwitch("Misc", "ClassColorPlus", "Enable Class Color Enhancements", "Enhances various UI elements with class-specific colors, including guild, friends, who list, and battlefield score frames.")
	Window:CreateSwitch("Misc", "ColorPicker", L["Enhanced Color Picker"])
	Window:CreateSwitch("Misc", "EasyMarking", L["EasyMarking by Ctrl + LeftClick"])
	Window:CreateSwitch("Misc", "Focuser", "Mouseover focus by Alt + LeftClick")	
	Window:CreateSwitch("Misc", "HideBossEmote", L["Hide Boss Emotes"])

	Window:CreateSection("Camera")
	Window:CreateSlider("Misc", "MaxCameraZoom", newFeatureIcon .. "Max Camera Zoom Level", 1, 3.4, 0.1, nil, UpdateMaxZoomLevel)

	Window:CreateSection("Trade Skill")
	Window:CreateSwitch("Misc", "TradeTabs", L["Add Spellbook-Like Tabs On TradeSkillFrame"])

	-- Social Section
	Window:CreateSection("Social")
	Window:CreateSwitch("Misc", "AFKCamera", L["AFK Camera"])
	Window:CreateSwitch("Misc", "EnhancedFriends", L["Enhanced Colors (Friends/Guild +)"])
	Window:CreateSwitch("Misc", "MuteSounds", "Mute Various Annoying Sounds In-Game")

	-- Mail Section
	Window:CreateSection("Mail")
	Window:CreateSwitch("Misc", "EnhancedMail", "Add 'Postal' Like Feaures To The Mailbox")
	Window:CreateSwitch("Misc", "MailSaver", "Mail Saver (Save mail recipient)")

	-- Questing Section
	Window:CreateSection("Questing")
	Window:CreateSwitch("Misc", "ExpRep", "Display Exp/Rep Bar (Minimap)")
	Window:CreateSwitch("Misc", "ShowWowHeadLinks", L["Show Wowhead Links Above Questlog Frame"])

	-- Durability Section
	Window:CreateSection("Durability")
	Window:CreateSwitch("Misc", "SlotDurability", L["Show Slot Durability %"])
	Window:CreateSwitch("Misc", "SlotDurabilityWarning", "Show Low Durability Warnings.", "Enable this option to display a warning when your equipment's durability falls below 25%. The warning will remind you to repair your gear to avoid item breakage.")

	-- Raid Tool Section
	Window:CreateSection("Raid Tool")
	Window:CreateSwitch("Misc", "RaidTool", L["Show Raid Utility Frame"])
	Window:CreateEditBox("Misc", "DBMCount", "DBMCount - Add Info")
	Window:CreateSlider("Misc", "MarkerBarSize", "Marker Bar Size - Add Info", 20, 40, 1, nil, UpdateMarkerGrid)
	Window:CreateDropdown("Misc", "ShowMarkerBar", L["World Markers Bar"], nil, nil, UpdateMarkerGrid)

	-- Misc Section
	Window:CreateSection("Threat Bar")
	Window:CreateSwitch("Misc", "ThreatEnable", "Show Threat Bar")
	Window:CreateEditBox("Misc", "ThreatHeight", "Bars height")
	Window:CreateEditBox("Misc", "ThreatWidth", "Bars width")
	Window:CreateEditBox("Misc", "ThreatBarRows", "Number of bars")
	Window:CreateSwitch("Misc", "ThreatHideSolo", "Show only in party/raid")

	-- Misc Section
	Window:CreateSection("Misc")
	if C["Misc"].ItemLevel then
		Window:CreateSwitch("Misc", "GemEnchantInfo", L["Character/Inspect Gem/Enchant Info"])
	end
	Window:CreateSwitch("Misc", "ItemLevel", L["Show Character/Inspect ItemLevel Info"])
	Window:CreateSwitch("Misc", "HelmCloakToggle", newFeatureIcon.."Add Helm/Cloak Toggle Buttons To Character Frame")
end

local Nameplate = function(self)
	local Window = self:CreateWindow(L["Nameplate"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Nameplate", "Enable", enableTextColor .. L["Enable Nameplates"])
	Window:CreateSwitch("Nameplate", "ClassIcon", L["Show Enemy Class Icons"])
	Window:CreateSwitch("Nameplate", "ColoredTarget", "Colored Targeted Nameplate", "If enabled, this will color your targeted nameplate|nIts priority is higher than custom/threat colors")
	Window:CreateSwitch("Nameplate", "CustomUnitColor", L["Colored Custom Units"])
	Window:CreateSwitch("Nameplate", "FriendlyCC", L["Show Friendly ClassColor"])
	Window:CreateSwitch("Nameplate", "FullHealth", L["Show Health Value"], nil, refreshNameplates)
	Window:CreateSwitch("Nameplate", "HostileCC", L["Show Hostile ClassColor"])
	Window:CreateSwitch("Nameplate", "InsideView", L["Interacted Nameplate Stay Inside"])
	Window:CreateSwitch("Nameplate", "NameOnly", L["Show Only Names For Friendly"])
	Window:CreateSwitch("Nameplate", "NameplateClassPower", "Show Nameplate Class Power")
	Window:CreateDropdown("Nameplate", "AuraFilter", L["Auras Filter Style"], nil, nil, refreshNameplates)
	Window:CreateDropdown("Nameplate", "TargetIndicator", L["TargetIndicator Style"], nil, nil, refreshNameplates)
	Window:CreateDropdown("Nameplate", "TargetIndicatorTexture", "TargetIndicator Texture") -- Needs Locale
	Window:CreateEditBox("Nameplate", "CustomUnitList", L["Custom UnitColor List"], L["CustomUnitTip"], UpdateCustomUnitList)
	Window:CreateEditBox("Nameplate", "PowerUnitList", L["Custom PowerUnit List"], L["CustomUnitTip"], UpdatePowerUnitList)

	Window:CreateSection("Castbar")
	Window:CreateSwitch("Nameplate", "CastTarget", "Show Nameplate Target Of Casting Spell")

	Window:CreateSection("Threat")
	Window:CreateSwitch("Nameplate", "DPSRevertThreat", L["Revert Threat Color If Not Tank"])
	Window:CreateSwitch("Nameplate", "TankMode", L["Force TankMode Colored"])

	Window:CreateSection("Miscellaneous")
	Window:CreateSwitch("Nameplate", "PlateAuras", "Target Nameplate Auras", nil, refreshNameplates)
	Window:CreateSwitch("Nameplate", "QuestIndicator", L["Quest Progress Indicator"])
	Window:CreateSwitch("Nameplate", "Smooth", L["Smooth Bars Transition"])
	Window:CreateSwitch("Nameplate", "TarName", "Show target name")

	Window:CreateSection(L["Sizes"])
	Window:CreateSlider("Nameplate", "AuraSize", L["Auras Size"], 18, 40, 1, nil, refreshNameplates)
	--Window:CreateSlider("Nameplate", "Distance", L["Nameplete MaxDistance"], 20, 41, 1)
	Window:CreateSlider("Nameplate", "ExecuteRatio", L["Unit Execute Ratio"], 0, 90, 1, L["ExecuteRatioTip"])
	Window:CreateSlider("Nameplate", "HealthTextSize", L["HealthText FontSize"], 8, 16, 1, nil, refreshNameplates)
	Window:CreateSlider("Nameplate", "MaxAuras", L["Max Auras"], 4, 8, 1, nil, refreshNameplates)
	Window:CreateSlider("Nameplate", "MinAlpha", L["Non-Target Nameplate Alpha"], 0.1, 1, 0.1)
	Window:CreateSlider("Nameplate", "MinScale", L["Non-Target Nameplate Scale"], 0.1, 3, 0.1)
	Window:CreateSlider("Nameplate", "NameTextSize", L["NameText FontSize"], 8, 16, 1, nil, refreshNameplates)
	Window:CreateSlider("Nameplate", "PlateHeight", L["Nameplate Height"], 6, 28, 1, nil, refreshNameplates)
	Window:CreateSlider("Nameplate", "PlateWidth", L["Nameplate Width"], 80, 240, 1, nil, refreshNameplates)
	Window:CreateSlider("Nameplate", "VerticalSpacing", L["Nameplate Vertical Spacing"], 0.5, 2.5, 0.1)
	Window:CreateSlider("Nameplate", "SelectedScale", "SelectedScale", 1, 1.4, 0.1)

	Window:CreateSection("Player Nameplate Toggles")
	Window:CreateSwitch("Nameplate", "ShowPlayerPlate", enableTextColor .. L["Enable Personal Resource"], nil, togglePlayerPlate)
	Window:CreateSwitch("Nameplate", "PPGCDTicker", L["Enable GCD Ticker"])
	Window:CreateSwitch("Nameplate", "PPHideOOC", L["Only Visible in Combat"])
	Window:CreateSwitch("Nameplate", "PPOnFire", "Always Refresh PlayerPlate Auras")
	Window:CreateSwitch("Nameplate", "PPPowerText", L["Show Power Value"], nil, togglePlatePower)

	Window:CreateSection("Player Nameplate Values")
	Window:CreateSlider("Nameplate", "PPHeight", L["Classpower/Healthbar Height"], 4, 10, 1, nil, refreshNameplates)
	Window:CreateSlider("Nameplate", "PPIconSize", L["PlayerPlate IconSize"], 20, 40, 1)
	Window:CreateSlider("Nameplate", "PPPHeight", L["PlayerPlate Powerbar Height"], 4, 10, 1, nil, refreshNameplates)

	Window:CreateSection(COLORS)
	Window:CreateColorSelection("Nameplate", "CustomColor", L["Custom Color"])
	Window:CreateColorSelection("Nameplate", "InsecureColor", L["Insecure Color"])
	Window:CreateColorSelection("Nameplate", "OffTankColor", L["Off-Tank Color"])
	Window:CreateColorSelection("Nameplate", "SecureColor", L["Secure Color"])
	Window:CreateColorSelection("Nameplate", "TargetColor", "Selected Target Coloring")
	Window:CreateColorSelection("Nameplate", "TargetIndicatorColor", L["TargetIndicator Color"])
	Window:CreateColorSelection("Nameplate", "TransColor", L["Transition Color"])
end

local Skins = function(self)
	local Window = self:CreateWindow(L["Skins"])

	Window:CreateSection("Blizzard Skins")
	Window:CreateSwitch("Skins", "BlizzardFrames", L["Skin Some Blizzard Frames & Objects"])
	Window:CreateSwitch("Skins", "TradeSkills", "Skin TradeSkills")
	Window:CreateSwitch("Skins", "Trainers", "Skin Trainers")
	Window:CreateSwitch("Skins", "ChatBubbles", L["ChatBubbles Skin"])
	Window:CreateSlider("Skins", "ChatBubbleAlpha", L["ChatBubbles Background Alpha"], 0, 1, 0.1, nil, UpdateChatBubble)

	Window:CreateSection("AddOn Skins")
	Window:CreateSwitch("Skins", "AtlasLoot", "AtlasLoot Skin")
	Window:CreateSwitch("Skins", "Bartender4", L["Bartender4 Skin"])
	Window:CreateSwitch("Skins", "BigWigs", L["BigWigs Skin"])
	Window:CreateSwitch("Skins", "ButtonForge", L["ButtonForge Skin"])
	Window:CreateSwitch("Skins", "ChocolateBar", L["ChocolateBar Skin"])
	Window:CreateSwitch("Skins", "DeadlyBossMods", L["Deadly Boss Mods Skin"])
	Window:CreateSwitch("Skins", "Details", L["Details Skin"])
	Window:CreateSwitch("Skins", "Dominos", L["Dominos Skin"])
	Window:CreateSwitch("Skins", "RareScanner", L["RareScanner Skin"])
	Window:CreateSwitch("Skins", "Skada", L["Skada Skin"])
	Window:CreateSwitch("Skins", "WeakAuras", L["WeakAuras Skin"])
	Window:CreateButton(L["Reset Details"], nil, nil, ResetDetails)

	Window:CreateSection("Font Tweaks")
	Window:CreateSlider("Skins", "QuestFontSize", L["Adjust QuestFont Size"], 10, 30, 1, nil, UpdateQuestFontSize)
	--Window:CreateSlider("Skins", "ObjectiveFontSize", newFeatureIcon .. "Adjust ObjectiveFont Size", 10, 30, 1, nil, UpdateObjectiveFontSize)
end

local Tooltip = function(self)
	local Window = self:CreateWindow(L["Tooltip"])

	-- General section
	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Tooltip", "Enable", enableTextColor .. "Enable Tooltip")
	Window:CreateSwitch("Tooltip", "Icons", L["Item Icons"])
	Window:CreateSwitch("Tooltip", "ShowIDs", L["Show Tooltip IDs"])
	Window:CreateDropdown("Tooltip","HideInCombat", L["Hide Tooltip in Combat"])

	-- Appearance section
	Window:CreateSection("Appearance")
	Window:CreateSwitch("Tooltip", "ItemQuality", L["Quality Color Border"])
	Window:CreateSwitch("Tooltip", "FactionIcon", L["Show Faction Icon"])
	Window:CreateSwitch("Tooltip", "HideJunkGuild", L["Abbreviate Guild Names"])
	Window:CreateSwitch("Tooltip", "HideRank", L["Hide Guild Rank"])
	Window:CreateSwitch("Tooltip", "HideRealm", L["Show realm name by SHIFT"])
	Window:CreateSwitch("Tooltip", "HideTitle", L["Hide Player Title"])
	Window:CreateDropdown("Tooltip", "TipAnchor", "Tooltip Anchor")

	-- Advanced section
	Window:CreateSection("Advanced")
	Window:CreateSwitch("Tooltip", "LFDRole", L["Show Roles Assigned Icon"])
	Window:CreateSwitch("Tooltip", "SpecLevelByShift", L["Show Spec/ItemLevel by SHIFT"])
	Window:CreateSwitch("Tooltip", "TargetBy", L["Show Player Targeted By"])
	Window:CreateDropdown("Tooltip", "CursorMode", L["Follow Cursor"])
end

local function updateUFTextScale()
	K:GetModule("Unitframes"):UpdateTextScale()
end

local Unitframe = function(self)
	local Window = self:CreateWindow(L["Unitframe"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Unitframe", "Enable", enableTextColor .. L["Enable Unitframes"])
	Window:CreateSwitch("Unitframe", "CastClassColor", L["Class Color Castbars"])
	Window:CreateSwitch("Unitframe", "CastReactionColor", L["Reaction Color Castbars"])
	Window:CreateSwitch("Unitframe", "ClassResources", L["Show Class Resources"])
	-- Window:CreateSwitch("Unitframe", "CombatFade", L["Fade Unitframes"]) -- Broken. Portraits do not obey? Blizzard issue?
	Window:CreateSwitch("Unitframe", "DebuffHighlight", L["Show Health Debuff Highlight"])
	Window:CreateSwitch("Unitframe", "PvPIndicator", L["Show PvP Indicator on Player / Target"])
	Window:CreateSwitch("Unitframe", "Range", "Fade Unitframes When NOT In Unit Range")
	Window:CreateSwitch("Unitframe", "ShowHealPrediction", L["Show HealPrediction Statusbars"])
	Window:CreateSwitch("Unitframe", "Smooth", L["Smooth Bars"])

	Window:CreateSlider("Unitframe", "AllTextScale", "Scale All Unitframe Texts", 0.8, 1.5, 0.05, nil, updateUFTextScale) -- WIP

	Window:CreateSection("Combat Text")
	Window:CreateSwitch("Unitframe", "CombatText", enableTextColor .. L["Enable Simple CombatText"])
	Window:CreateSwitch("Unitframe", "AutoAttack", L["Show AutoAttack Damage"])
	Window:CreateSwitch("Unitframe", "FCTOverHealing", L["Show Full OverHealing"])
	Window:CreateSwitch("Unitframe", "HotsDots", L["Show Hots and Dots"])
	Window:CreateSwitch("Unitframe", "PetCombatText", L["Pet's Healing/Damage"])

	Window:CreateSection(PLAYER)
	if K.Class == "DRUID" then
		Window:CreateSwitch("Unitframe", "AdditionalPower", "Show Additional Mana Power (|CFFFF7D0ADruid|r)")
	end
	Window:CreateSwitch("Unitframe", "CastbarLatency", L["Show Castbar Latency"])
	Window:CreateSwitch("Unitframe", "GlobalCooldown", "Show Global Cooldown Spark")
	Window:CreateSwitch("Unitframe", "PlayerBuffs", L["Show Player Frame Buffs"])
	Window:CreateSwitch("Unitframe", "PlayerCastbar", L["Enable Player CastBar"])
	Window:CreateSwitch("Unitframe", "PlayerCastbarIcon", L["Enable Player CastBar"] .. " Icon")
	Window:CreateSwitch("Unitframe", "PlayerDebuffs", L["Show Player Frame Debuffs"])
	if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
		Window:CreateSwitch("Unitframe", "ShowPlayerLevel", L["Show Player Frame Level"])
	end
	Window:CreateSwitch("Unitframe", "SwingBar", L["Unitframe Swingbar"])
	Window:CreateSwitch("Unitframe", "SwingTimer", L["Unitframe Swingbar Timer"])
	Window:CreateSwitch("Unitframe", "OffOnTop", "Offhand timer on top")
	Window:CreateSlider("Unitframe", "SwingWidth", "Unitframe SwingBar Width", 50, 1000, 1)
	Window:CreateSlider("Unitframe", "SwingHeight", "Unitframe SwingBar Height", 1, 50, 1)

	Window:CreateSlider("Unitframe", "PlayerBuffsPerRow", L["Number of Buffs Per Row"], 4, 10, 1, nil, UpdatePlayerBuffs)
	Window:CreateSlider("Unitframe", "PlayerDebuffsPerRow", L["Number of Debuffs Per Row"], 4, 10, 1, nil, UpdatePlayerDebuffs)
	Window:CreateSlider("Unitframe", "PlayerPowerHeight", "Player Power Bar Height", 10, 40, 1, nil, UpdateUnitPlayerSize)
	Window:CreateSlider("Unitframe", "PlayerHealthHeight", L["Player Frame Height"], 20, 75, 1, nil, UpdateUnitPlayerSize)
	Window:CreateSlider("Unitframe", "PlayerHealthWidth", L["Player Frame Width"], 100, 300, 1, nil, UpdateUnitPlayerSize)
	Window:CreateSlider("Unitframe", "PlayerCastbarHeight", L["Player Castbar Height"], 20, 40, 1)
	Window:CreateSlider("Unitframe", "PlayerCastbarWidth", L["Player Castbar Width"], 100, 800, 1)

	Window:CreateSection(TARGET)
	Window:CreateSwitch("Unitframe", "OnlyShowPlayerDebuff", L["Only Show Your Debuffs"])
	Window:CreateSwitch("Unitframe", "TargetBuffs", L["Show Target Frame Buffs"])
	Window:CreateSwitch("Unitframe", "TargetCastbar", L["Enable Target CastBar"])
	Window:CreateSwitch("Unitframe", "TargetCastbarIcon", L["Enable Target CastBar"] .. " Icon")
	Window:CreateSwitch("Unitframe", "TargetDebuffs", L["Show Target Frame Debuffs"])
	Window:CreateSlider("Unitframe", "TargetBuffsPerRow", newFeatureIcon .. L["Number of Buffs Per Row"], 4, 10, 1, nil, UpdateTargetBuffs)
	Window:CreateSlider("Unitframe", "TargetDebuffsPerRow", newFeatureIcon .. L["Number of Debuffs Per Row"], 4, 10, 1, nil, UpdateTargetDebuffs)
	Window:CreateSlider("Unitframe", "TargetPowerHeight", "Target Power Bar Height", 10, 40, 1, nil, UpdateUnitTargetSize)
	Window:CreateSlider("Unitframe", "TargetHealthHeight", L["Target Frame Height"], 20, 75, 1, nil, UpdateUnitTargetSize)
	Window:CreateSlider("Unitframe", "TargetHealthWidth", L["Target Frame Width"], 100, 300, 1, nil, UpdateUnitTargetSize)
	Window:CreateSlider("Unitframe", "TargetCastbarHeight", L["Target Castbar Height"], 20, 40, 1)
	Window:CreateSlider("Unitframe", "TargetCastbarWidth", L["Target Castbar Width"], 100, 800, 1)

	Window:CreateSection(PET)
	Window:CreateSwitch("Unitframe", "HidePet", "Hide Pet Frame")
	Window:CreateSwitch("Unitframe", "HidePetLevel", L["Hide Pet Level"])
	Window:CreateSwitch("Unitframe", "HidePetName", L["Hide Pet Name"])
	Window:CreateSlider("Unitframe", "PetHealthHeight", L["Pet Frame Height"], 10, 50, 1)
	Window:CreateSlider("Unitframe", "PetHealthWidth", L["Pet Frame Width"], 80, 300, 1)
	Window:CreateSlider("Unitframe", "PetPowerHeight", L["Pet Power Bar"], 10, 50, 1)

	Window:CreateSection("Target Of Target")
	Window:CreateSwitch("Unitframe", "HideTargetofTarget", L["Hide TargetofTarget Frame"])
	Window:CreateSwitch("Unitframe", "HideTargetOfTargetLevel", L["Hide TargetofTarget Level"])
	Window:CreateSwitch("Unitframe", "HideTargetOfTargetName", L["Hide TargetofTarget Name"])
	Window:CreateSlider("Unitframe", "TargetTargetHealthHeight", L["Target of Target Frame Height"], 10, 50, 1)
	Window:CreateSlider("Unitframe", "TargetTargetHealthWidth", L["Target of Target Frame Width"], 80, 300, 1)
	Window:CreateSlider("Unitframe", "TargetTargetPowerHeight", "Target of Target Power Height", 10, 50, 1)

	Window:CreateSection(FOCUS)
	Window:CreateSlider("Unitframe", "FocusPowerHeight", "Focus Power Bar Height", 10, 40, 1, nil, UpdateUnitFocusSize)
	Window:CreateSlider("Unitframe", "FocusHealthHeight", L["Focus Frame Height"], 20, 75, 1, nil, UpdateUnitFocusSize)
	Window:CreateSlider("Unitframe", "FocusHealthWidth", L["Focus Frame Width"], 100, 300, 1, nil, UpdateUnitFocusSize)
	Window:CreateSwitch("Unitframe", "FocusBuffs", "Show Focus Frame Buffs")
	Window:CreateSwitch("Unitframe", "FocusCastbar", "Enable Focus CastBar")
	Window:CreateSwitch("Unitframe", "FocusCastbarIcon", "Enable Focus CastBar" .. " Icon")
	Window:CreateSwitch("Unitframe", "FocusDebuffs", "Show Focus Frame Debuffs")

	Window:CreateSection("Focus Target")
	Window:CreateSwitch("Unitframe", "HideFocusTarget", "Hide Focus Target Frame")
	Window:CreateSwitch("Unitframe", "HideFocusTargetLevel", "Hide Focus Target Level")
	Window:CreateSwitch("Unitframe", "HideFocusTargetName", "Hide Focus Target Name")
	Window:CreateSlider("Unitframe", "FocusTargetHealthHeight", "Focus Target Frame Height", 10, 50, 1)
	Window:CreateSlider("Unitframe", "FocusTargetHealthWidth", "Focus Target Frame Width", 80, 300, 1)
	Window:CreateSlider("Unitframe", "FocusTargetPowerHeight", "Focus Target Power Height", 10, 50, 1)

	Window:CreateSection("Unitframe Misc")
	Window:CreateDropdown("Unitframe", "HealthbarColor", L["Health Color Format"])
	Window:CreateDropdown("Unitframe", "PortraitStyle", L["Unitframe Portrait Style"], "It is highly recommanded to NOT use 3D portraits as you could see a drop in FPS")
end

local Party = function(self)
	local Window = self:CreateWindow(L["Party"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Party", "Enable", enableTextColor .. L["Enable Party"])
	Window:CreateSwitch("Party", "ShowBuffs", L["Show Party Buffs"])
	Window:CreateSwitch("Party", "ShowHealPrediction", L["Show HealPrediction Statusbars"])
	Window:CreateSwitch("Party", "ShowPartySolo", "Show Party Frames While Solo")
	Window:CreateSwitch("Party", "ShowPet", L["Show Party Pets"])
	Window:CreateSwitch("Party", "ShowPlayer", L["Show Player In Party"])
	Window:CreateSwitch("Party", "Smooth", L["Smooth Bar Transition"])
	Window:CreateSwitch("Party", "TargetHighlight", L["Show Highlighted Target"])

	Window:CreateSection("Party Castbars")
	Window:CreateSwitch("Party", "Castbars", L["Show Castbars"])
	Window:CreateSwitch("Party", "CastbarIcon", L["Show Castbars"] .. " Icon")

	Window:CreateSection(L["Sizes"])
	Window:CreateSlider("Party", "HealthHeight", "Party Frame Health Height", 20, 50, 1, nil, UpdateUnitPartySize)
	Window:CreateSlider("Party", "HealthWidth", "Party Frame Health Width", 120, 180, 1, nil, UpdateUnitPartySize)
	Window:CreateSlider("Party", "PowerHeight", "Party Frame Power Height", 10, 30, 1, nil, UpdateUnitPartySize)

	Window:CreateSection(COLORS)
	Window:CreateDropdown("Party", "HealthbarColor", L["Health Color Format"])
end

local Boss = function(self)
	local Window = self:CreateWindow(L["Boss"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Boss", "Enable", enableTextColor .. L["Enable Boss"], "Toggle Boss Module On/Off")
	Window:CreateSwitch("Boss", "Castbars", L["Show Castbars"])
	Window:CreateSwitch("Boss", "Smooth", L["Smooth Bar Transition"])

	Window:CreateSection(L["Sizes"])
	Window:CreateSlider("Boss", "HealthHeight", "Health Height", 20, 50, 1)
	Window:CreateSlider("Boss", "HealthWidth", "Health Width", 120, 180, 1)
	Window:CreateSlider("Boss", "PowerHeight", "Power Height", 10, 30, 1)
	Window:CreateSlider("Boss", "YOffset", "Vertical Offset From One Another" .. K.GreyColor .. "(54)|r", 40, 60, 1)

	Window:CreateSection(COLORS)
	Window:CreateDropdown("Boss", "HealthbarColor", L["Health Color Format"])
end

local Arena = function(self)
	local Window = self:CreateWindow(L["Arena"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Arena", "Enable", enableTextColor .. L["Enable Arena"], "Toggle Arena Module On/Off")
	Window:CreateSwitch("Arena", "Castbars", L["Show Castbars"])
	Window:CreateSwitch("Arena", "CastbarIcon", "Show Castbars Icon")
	Window:CreateSwitch("Arena", "Smooth", L["Smooth Bar Transition"])

	Window:CreateSection(L["Sizes"])
	Window:CreateSlider("Arena", "HealthHeight", "Health Height", 20, 50, 1)
	Window:CreateSlider("Arena", "HealthWidth", "Health Width", 120, 180, 1)
	Window:CreateSlider("Arena", "PowerHeight", "Power Height", 10, 30, 1)
	Window:CreateSlider("Arena", "YOffset", "Vertical Offset From One Another" .. K.GreyColor .. "(54)|r", 40, 60, 1)

	Window:CreateSection(COLORS)
	Window:CreateDropdown("Arena", "HealthbarColor", L["Health Color Format"])
end

local Raid = function(self)
	local Window = self:CreateWindow(L["Raid"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("Raid", "Enable", enableTextColor .. L["Enable Raidframes"])
	Window:CreateSwitch("Raid", "HorizonRaid", L["Horizontal Raid Frames"])
	Window:CreateSwitch("Raid", "MainTankFrames", L["Show MainTank Frames"])
	Window:CreateSwitch("Raid", "PowerBarShow", "Toggle The visibility Of All Power Bars")
	Window:CreateSwitch("Raid", "ManabarShow", L["Show Manabars"])
	Window:CreateSwitch("Raid", "ReverseRaid", L["Reverse Raid Frame Growth"])
	Window:CreateSwitch("Raid", "ShowHealPrediction", L["Show HealPrediction Statusbars"])
	Window:CreateSwitch("Raid", "ShowNotHereTimer", L["Show Away/DND Status"])
	Window:CreateSwitch("Raid", "ShowRaidSolo", "Show Raid Frames While Solo")
	Window:CreateSwitch("Raid", "ShowTeamIndex", L["Show Group Number Team Index"])
	Window:CreateSwitch("Raid", "Smooth", L["Smooth Bar Transition"])
	Window:CreateSwitch("Raid", "TargetHighlight", L["Show Highlighted Target"])

	Window:CreateSection(L["Sizes"])
	Window:CreateSlider("Raid", "Height", L["Raidframe Height"], 20, 100, 1, nil, UpdateUnitRaidSize)
	Window:CreateSlider("Raid", "NumGroups", L["Number Of Groups to Show"], 1, 8, 1)
	Window:CreateSlider("Raid", "Width", L["Raidframe Width"], 20, 100, 1, nil, UpdateUnitRaidSize)

	Window:CreateSection(COLORS)
	Window:CreateDropdown("Raid", "HealthbarColor", L["Health Color Format"])
	Window:CreateDropdown("Raid", "HealthFormat", L["Health Format"])

	Window:CreateSection("Raid Buffs")
	Window:CreateDropdown("Raid", "RaidBuffsStyle", "Select the buff style you want to use") -- Needs Locale

	if C["Raid"].RaidBuffsStyle.Value == "Standard" then
		Window:CreateDropdown("Raid", "RaidBuffs", "Enable buffs display & filtering") -- Needs Locale
		Window:CreateSwitch("Raid", "DesaturateBuffs", "Desaturate buffs that are not by me") -- Needs Locale
	elseif C["Raid"].RaidBuffsStyle.Value == "Aura Track" then
		Window:CreateSwitch("Raid", "AuraTrack", "Enable auras tracking module for healer (replace buffs)") -- Needs Locale
		Window:CreateSwitch("Raid", "AuraTrackIcons", "Use squared icons instead of status bars") -- Needs Locale
		Window:CreateSwitch("Raid", "AuraTrackSpellTextures", "Display icons texture on aura squares instead of colored squares") -- Needs Locale
		Window:CreateSlider("Raid", "AuraTrackThickness", "Thickness size of status bars in pixel", 2, 10, 1) -- Needs Locale
	end

	Window:CreateSection("Raid Debuffs")
	Window:CreateSwitch("Raid", "DebuffWatch", "Enable debuffs tracking (filtered auto by current gameplay (pvp or pve)") -- Needs Locale
	Window:CreateSwitch("Raid", "DebuffWatchDefault", "We have already a debuff tracking list for pve and pvp, use it?") -- Needs Locale
end

local WorldMap = function(self)
	local Window = self:CreateWindow(L["WorldMap"])

	Window:CreateSection(GENERAL)
	Window:CreateSwitch("WorldMap", "SmallWorldMap", L["Show Smaller Worldmap"])
	Window:CreateSwitch("WorldMap", "Coordinates", L["Show Player/Mouse Coordinates"])

	Window:CreateSection("WorldMap Reveal")
	Window:CreateSwitch("WorldMap", "MapRevealGlow", L["Map Reveal Shadow"], L["MapRevealTip"])

	Window:CreateSection(L["Sizes"])
	Window:CreateSwitch("WorldMap", "FadeWhenMoving", L["Fade Worldmap When Moving"])
	Window:CreateSlider("WorldMap", "AlphaWhenMoving", L["Alpha When Moving"], 0.1, 1, 0.01)
	Window:CreateSlider("WorldMap", "MaxMapScale", "Fullscreen map scale", 0.1, 1, 0.1)
	Window:CreateSlider("WorldMap", "MapScale", "Window map scale", 0.5, 2, 0.1)
end

GUI:AddWidgets(ActionBar)
GUI:AddWidgets(Announcements)
GUI:AddWidgets(Arena)
GUI:AddWidgets(AuraWatch)
GUI:AddWidgets(Auras)
GUI:AddWidgets(Automation)
GUI:AddWidgets(Boss)
GUI:AddWidgets(Chat)
GUI:AddWidgets(DataText)
GUI:AddWidgets(General)
GUI:AddWidgets(Inventory)
GUI:AddWidgets(Loot)
GUI:AddWidgets(Minimap)
GUI:AddWidgets(Misc)
GUI:AddWidgets(Nameplate)
GUI:AddWidgets(Party)
GUI:AddWidgets(Raid)
GUI:AddWidgets(Skins)
GUI:AddWidgets(Tooltip)
GUI:AddWidgets(Unitframe)
GUI:AddWidgets(WorldMap)
