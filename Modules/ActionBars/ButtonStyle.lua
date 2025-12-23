local K = KkthnxUI[1]
local Module = K:GetModule("ActionBar")

-- 1. Define Localized Globals (Cache them to avoid nil errors if WoW changes keys)
-- We use "or" to fallback to English if the Global is missing in a specific client version.
local L_BUTTON = _G.KEY_BUTTON3:gsub("3", "") or "Button"
local L_MOUSEWHEELUP = _G.KEY_MOUSEWHEELUP or "Mouse Wheel Up"
local L_MOUSEWHEELDN = _G.KEY_MOUSEWHEELDOWN or "Mouse Wheel Down"
local L_NUMPAD = _G.KEY_NUMPAD0:gsub("0", "") or "Num Pad"
local L_PAGEUP = _G.KEY_PAGEUP or "Page Up"
local L_PAGEDOWN = _G.KEY_PAGEDOWN or "Page Down"
local L_SPACE = _G.KEY_SPACE or "Space"
local L_INSERT = _G.KEY_INSERT or "Insert"
local L_HOME = _G.KEY_HOME or "Home"
local L_DELETE = _G.KEY_DELETE or "Delete"

-- 2. The Master Replacement Table
-- Ordered specifically: Modifiers first, then specific keys, then generic patterns.
local replacements = {
	-- >> Modifiers (Handle various casings and localized formats)
	{ "(CTRL%-)", "c" },
	{ "(Ctrl%-)", "c" },
	{ "(ALT%-)", "a" },
	{ "(Alt%-)", "a" },
	{ "(SHIFT%-)", "s" },
	{ "(Shift%-)", "s" },
	{ "(META%-)", "m" }, -- macOS Command Key
	{ "(Meta%-)", "m" },

	-- >> Mouse (Localized & English)
	{ L_MOUSEWHEELUP, "MU" },
	{ "MOUSEWHEELUP", "MU" },
	{ L_MOUSEWHEELDN, "MD" },
	{ "MOUSEWHEELDOWN", "MD" },
	{ L_BUTTON, "M" }, -- Localized "Button"
	{ "BUTTON", "M" }, -- English "BUTTON"

	-- >> Navigation & Editing (The missing items)
	{ L_PAGEUP, "PU" },
	{ "PAGEUP", "PU" },
	{ L_PAGEDOWN, "PD" },
	{ "PAGEDOWN", "PD" },
	{ L_HOME, "Hm" },
	{ "HOME", "Hm" },
	{ "END", "End" }, -- Usually same in Locales, but safe to keep
	{ L_INSERT, "Ins" },
	{ "INSERT", "Ins" },
	{ L_DELETE, "Del" },
	{ "DELETE", "Del" },
	{ "BACKSPACE", "BS" },
	{ "Backspace", "BS" },
	{ "TAB", "Tab" },
	{ "ESCAPE", "Esc" },

	-- >> Special Keys
	{ L_SPACE, "Sp" },
	{ "SPACE", "Sp" },
	{ "CAPSLOCK", "CL" },
	{ "Capslock", "CL" },
	{ "NUMLOCK", "NL" },
	{ "Num Lock", "NL" },

	-- >> Numpad Cleanup (Specific operators first, then generic)
	{ "NUMPADDIVIDE", "N/" },
	{ "NUMPADMULTIPLY", "N*" },
	{ "NUMPADPLUS", "N+" },
	{ "NUMPADMINUS", "N-" },
	{ L_NUMPAD, "N" }, -- Localized "Num Pad"
	{ "NUMPAD", "N" }, -- English "NUMPAD"
}

function Module:UpdateHotKey()
	local text = self:GetText()
	if not text then
		return
	end

	if text == RANGE_INDICATOR then
		text = ""
	else
		for _, value in pairs(replacements) do
			text = gsub(text, value[1], value[2])
		end
	end
	self:SetFormattedText("%s", text)
end

function Module:UpdateBarBorderColor(button)
	if not button.__bg then
		return
	end

	if button.Border:IsShown() then
		button.__bg.KKUI_Border:SetVertexColor(0, 0.7, 0.1)
	else
		K.SetBorderColor(button.__bg.KKUI_Border)
	end
end

local function OverrideNormalTextureAndAtlas(self, texture)
	if texture and texture ~= 0 then
		self:SetNormalTexture(0)
	end
end

function Module:StyleActionButton(button)
	if not button then return end
	if button.__styled then return end

	local buttonName = button:GetName()

	local autoCastable = _G[buttonName .. "AutoCastable"]
	local border = button.Border
	local checked
	if button.GetCheckedTexture then
		checked = button:GetCheckedTexture()
	end
	local cooldown = button.cooldown
	local flash = button.Flash or _G[buttonName .. "Flash"]
	local floatingBG = _G[buttonName .. "FloatingBG"]
	local highlight = button:GetHighlightTexture()
	local hotkey = button.HotKey
	local icon = button.icon
	local newActionTexture = button.NewActionTexture
	local normal = button:GetNormalTexture()
	local petShine = _G[buttonName .. "Shine"]
	local pushed = button:GetPushedTexture()
	local spellHighlight = button.SpellHighlightTexture
	local style = button.style

	if normal then
		normal:SetTexture(0)
		-- Hook the function to both SetNormalTexture and SetNormalAtlas methods
		hooksecurefunc(button, "SetNormalTexture", OverrideNormalTextureAndAtlas)
		hooksecurefunc(button, "SetNormalAtlas", OverrideNormalTextureAndAtlas)
	end

	if flash then
		flash:SetColorTexture(220 / 255, 68 / 255, 54 / 255, 0.65 / 255)
		flash:SetAllPoints()
	end

	if newActionTexture then
		newActionTexture:SetDrawLayer("OVERLAY", 2)
		newActionTexture:ClearAllPoints()
		newActionTexture:SetPoint("TOPLEFT", -5, 5)
		newActionTexture:SetPoint("BOTTOMRIGHT", 5, -5)
	end

	if border then
		border:SetTexture(0)
	end

	if floatingBG then
		floatingBG:Hide()
		floatingBG:SetAlpha(0)
	end

	if style then
		style:SetAlpha(0)
	end

	if petShine then
		petShine:ClearAllPoints()
		petShine:SetPoint("TOPLEFT", 1, -1)
		petShine:SetPoint("BOTTOMRIGHT", -1, 1)
	end

	if autoCastable then
		autoCastable:SetDrawLayer("OVERLAY", 3)
		autoCastable:ClearAllPoints()
		autoCastable:SetPoint("TOPLEFT", -10, 10)
		autoCastable:SetPoint("BOTTOMRIGHT", 10, -10)
	end

	if icon then
		icon:SetAllPoints()
		if not icon.__lockdown then
			icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])
		end

		if not button.__bgCreated then
			button.__bg = CreateFrame("Frame", nil, button, "BackdropTemplate")
			button.__bg:SetAllPoints(button)
			button.__bg:SetFrameLevel(button:GetFrameLevel())
			button.__bg:CreateBorder(nil, nil, nil, nil, nil, nil, K.MediaFolder .. "Skins\\UI-Slot-Background", nil, nil, nil, { 1, 1, 1 })
			button.__bgCreated = true
		end
	end

	if cooldown then
		cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
		cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
	end

	if pushed then
		button:SetPushedTexture("Interface\\Buttons\\CheckButtonHilight")
		button:GetPushedTexture():SetBlendMode("ADD")
		button:GetPushedTexture():SetAllPoints()
	end

	if checked then
		button:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
		button:GetCheckedTexture():SetBlendMode("ADD")
		button:GetCheckedTexture():SetAllPoints()
	end

	if highlight then
		button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		button:GetHighlightTexture():SetBlendMode("ADD")
		button:GetHighlightTexture():SetAllPoints()
	end

	if spellHighlight then
		spellHighlight:SetDrawLayer("OVERLAY", 2)
		spellHighlight:ClearAllPoints()
		spellHighlight:SetPoint("TOPLEFT", -5, 5)
		spellHighlight:SetPoint("BOTTOMRIGHT", 5, -5)
	end

	if hotkey then
		Module.UpdateHotKey(hotkey)
		hooksecurefunc(hotkey, "SetText", Module.UpdateHotKey)
	end

	button.__styled = true
end

function Module:ReskinBars()
	for i = 1, 8 do
		for j = 1, 12 do
			Module:StyleActionButton(_G["KKUI_ActionBar" .. i .. "Button" .. j])
		end
	end

	-- petbar buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		Module:StyleActionButton(_G["PetActionButton" .. i])
	end

	-- stancebar buttons
	for i = 1, 10 do
		Module:StyleActionButton(_G["StanceButton" .. i])
	end

	-- leave vehicle
	Module:StyleActionButton(_G["KKUI_LeaveVehicleButton"])

	-- extra action button
	Module:StyleActionButton(ExtraActionButton1)
	--spell flyout
	SpellFlyoutBackgroundEnd:SetTexture(nil)
	SpellFlyoutHorizontalBackground:SetTexture(nil)
	SpellFlyoutVerticalBackground:SetTexture(nil)
	local function checkForFlyoutButtons()
		local i = 1
		local button = _G["SpellFlyoutButton"..i]
		while button and button:IsShown() do
			Module:StyleActionButton(button)
			i = i + 1
			button = _G["SpellFlyoutButton"..i]
		end
	end
	SpellFlyout:HookScript("OnShow", checkForFlyoutButtons)
	SpellFlyout:HookScript("OnHide", checkForFlyoutButtons)
end
