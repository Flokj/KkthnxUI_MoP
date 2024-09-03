local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("ActionBar")

local insert = table.insert
local ipairs, pairs = ipairs, pairs
local type = type

local MicroButtons = {}
local updateWatcher = 0

local function ResetButtonProperties(button)
	button:ClearAllPoints()
	button:SetAllPoints(button.__owner)
end

local function SetupMicroButtonTextures(button)
	local highlight, normal, pushed, disabled, flash = button:GetHighlightTexture(), button:GetNormalTexture(), button:GetPushedTexture(), button:GetDisabledTexture(), button.FlashBorder
	local flashTexture = K.MediaFolder .. "Skins\\HighlightMicroButtonWhite"

	if pushed then
		pushed:SetColorTexture(1, 0.84, 0, 0.2)
		pushed:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
		pushed:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
	end
	if disabled then
		disabled:SetColorTexture(1, 0, 0, 0.4)
		disabled:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
		disabled:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
	end

	highlight:SetTexture(flashTexture)
	highlight:SetVertexColor(K.r, K.g, K.b)
	highlight:SetPoint("TOPLEFT", button, "TOPLEFT", -24, 18)
	highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 24, -18)
	
	if flash then
		flash:SetTexture(flashTexture)
		flash:SetPoint("TOPLEFT", button, "TOPLEFT", -24, 18)
		flash:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 24, -18)
	end
end

local function FadeOutMicroMenu()
	local KKUI_MenuBar = _G.KKUI_MenuBar
	if KKUI_MenuBar then
		UIFrameFadeOut(KKUI_MenuBar, 0.2, KKUI_MenuBar:GetAlpha(), 0)
	end
end

local function UpdateOnMouseOver(_, elapsed)
	local KKUI_MenuBar = _G.KKUI_MenuBar
	if not KKUI_MenuBar then return end

	updateWatcher = updateWatcher + elapsed
	if updateWatcher > 0.1 then
		if not KKUI_MenuBar:IsMouseOver() then
			KKUI_MenuBar.IsMouseOvered = nil
			KKUI_MenuBar:SetScript("OnUpdate", nil)
			FadeOutMicroMenu()
		end
		updateWatcher = 0
	end
end

local function OnMicroButtonEnter()
	local KKUI_MenuBar = _G.KKUI_MenuBar
	if KKUI_MenuBar and not KKUI_MenuBar.IsMouseOvered then
		KKUI_MenuBar.IsMouseOvered = true
		KKUI_MenuBar:SetScript("OnUpdate", UpdateOnMouseOver)
		UIFrameFadeIn(KKUI_MenuBar, 0.2, KKUI_MenuBar:GetAlpha(), 1)
	end
end

local function CreateMicroButton(parent, data, FadeMicroMenuEnabled)
	local function SetTextureProperties(icon, texture)
		icon:SetPoint("TOPLEFT", -9, 5)
		icon:SetPoint("BOTTOMRIGHT", 10, -6)
		icon:SetTexture(K.MediaFolder .. "Skins\\" .. texture)
	end

	local texture, method, tooltip = unpack(data)

	local buttonFrame = CreateFrame("Frame", "KKUI_MicroButtons", parent)
	insert(MicroButtons, buttonFrame)
	buttonFrame:SetSize(22, 30)
	buttonFrame:CreateBorder()

	local icon = buttonFrame:CreateTexture(nil, "ARTWORK")
	SetTextureProperties(icon, texture)

	if type(method) == "string" then
		local button = _G[method]
		if not button then print(method) return end

		button:SetHitRectInsets(0, 0, 0, 0)
		button:SetParent(buttonFrame)
		button.__owner = buttonFrame

		hooksecurefunc(button, "SetParent", ResetButtonProperties)
		ResetButtonProperties(button)
		hooksecurefunc(button, "SetPoint", ResetButtonProperties)
		
		button:UnregisterAllEvents()
		button:SetNormalTexture(0)

		if tooltip then
			K.AddTooltip(button, "ANCHOR_RIGHT", tooltip)
		end

		if FadeMicroMenuEnabled then
			button:HookScript("OnEnter", OnMicroButtonEnter)
		end

		SetupMicroButtonTextures(button)	
	else
		buttonFrame:SetScript("OnMouseUp", method)
		K.AddTooltip(buttonFrame, "ANCHOR_RIGHT", tooltip)

		local highlight = buttonFrame:CreateTexture(nil, "HIGHLIGHT")
		highlight:SetTexture(K.MediaFolder .. "Skins\\HighlightMicroButtonWhite")
		highlight:SetVertexColor(K.r, K.g, K.b)
		highlight:SetPoint("TOPLEFT", buttonFrame, "TOPLEFT", -22, 18)
		highlight:SetPoint("BOTTOMRIGHT", buttonFrame, "BOTTOMRIGHT", 24, -18)
	end
end

function Module:CreateMicroMenu()
	if not C["ActionBar"].MicroMenu then return end

	local FadeMicroMenuEnabled = C["ActionBar"].FadeMicroMenu

	local KKUI_MenuBar = CreateFrame("Frame", "KKUI_MenuBar", UIParent)
	KKUI_MenuBar:SetSize(302, 30)
	KKUI_MenuBar:SetAlpha(FadeMicroMenuEnabled and not KKUI_MenuBar.IsMouseOvered and 0 or 1)
	KKUI_MenuBar:EnableMouse(false)
	K.Mover(KKUI_MenuBar, "Menubar", "Menubar", { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 4 })

	local buttonInfo = {
		{ "CharacterMicroButton", "CharacterMicroButton", MicroButtonTooltipText(CHARACTER_BUTTON, "TOGGLECHARACTER0") },
		{ "SpellbookMicroButton", "SpellbookMicroButton", MicroButtonTooltipText(SPELLBOOK_ABILITIES_BUTTON, "TOGGLESPELLBOOK") },
		{ "TalentMicroButton", "TalentMicroButton", MicroButtonTooltipText(TALENTS, "TOGGLETALENTS") },
		{ "AchievementMicroButton", "AchievementMicroButton", MicroButtonTooltipText(ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT") },
		{ "QuestLogMicroButton", "QuestLogMicroButton", MicroButtonTooltipText(QUESTLOG_BUTTON, "TOGGLEQUESTLOG") },
		{ "GuildMicroButton", "GuildMicroButton", MicroButtonTooltipText(GUILD_AND_COMMUNITIES, "TOGGLEGUILDTAB") },
		{ "EJMicroButton", "EJMicroButton", MicroButtonTooltipText(ENCOUNTER_JOURNAL, "TOGGLEENCOUNTERJOURNAL") },
		{ "LFDMicroButton", function(_, btn) if btn == "LeftButton" then PVEFrame_ToggleFrame() else TogglePVPFrame() end end, K.LeftButton..MicroButtonTooltipText(LFG_BUTTON, "TOGGLEGROUPFINDER").."|n"..K.RightButton..MicroButtonTooltipText(PLAYER_V_PLAYER, "TOGGLECHARACTER4") },
		{ "CollectionsMicroButton", "CollectionsMicroButton", MicroButtonTooltipText(COLLECTIONS, "TOGGLECOLLECTIONS") },
		{ "StoreMicroButton", function() ToggleStoreUI() end, BLIZZARD_STORE},
		{ "MainMenuMicroButton", "MainMenuMicroButton", MicroButtonTooltipText(MAINMENU_BUTTON, "TOGGLEGAMEMENU") },
	}

	for i, info in ipairs(buttonInfo) do
		CreateMicroButton(KKUI_MenuBar, info, FadeMicroMenuEnabled)
		if i > 1 then
			MicroButtons[i]:SetPoint("LEFT", MicroButtons[i - 1], "RIGHT", 6, 0)
		else
			MicroButtons[i]:SetPoint("LEFT")
		end
	end

	-- Default elements
	K.HideInterfaceOption(_G.PVPMicroButtonTexture)
	K.HideInterfaceOption(_G.MicroButtonPortrait)
	K.HideInterfaceOption(_G.MainMenuBarDownload)
	K.HideInterfaceOption(_G.HelpOpenWebTicketButton)
	K.HideInterfaceOption(_G.MainMenuBarPerformanceBar)
	MainMenuMicroButton:SetScript("OnUpdate", nil)
end
