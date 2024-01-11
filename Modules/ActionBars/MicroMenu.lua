local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("ActionBar")

-- Import Lua functions
local table_insert = table.insert
local pairs = pairs
local type = type

-- Global variables
local buttonList = {}
local watcher = 0

-- Callback for fading out the micro menu
local function LeaveBarFadeOut()
	local KKUI_MB = KKUI_MenuBar
	if C["ActionBar"].FadeMicroMenu then
		UIFrameFadeOut(KKUI_MB, 0.2, KKUI_MB:GetAlpha(), 0)
	end
end

-- Callback for updating when the mouse is over the micro menu
local function UpdateOnMouseOver(_, elapsed)
	local KKUI_MB = KKUI_MenuBar
	watcher = watcher + elapsed
	if watcher > 0.1 then
		if not KKUI_MB:IsMouseOver() then
			KKUI_MB.IsMouseOvered = nil
			KKUI_MB:SetScript("OnUpdate", nil)
			LeaveBarFadeOut()
		end
		watcher = 0
	end
end

-- Callback for handling micro button hover
local function OnMicroButtonEnter()
	local KKUI_MB = KKUI_MenuBar
	if not KKUI_MB.IsMouseOvered then
		KKUI_MB.IsMouseOvered = true
		KKUI_MB:SetScript("OnUpdate", UpdateOnMouseOver)
		UIFrameFadeIn(KKUI_MB, 0.2, KKUI_MB:GetAlpha(), 1)
	end
end

-- Callbacks for resetting button parent and anchor
local function ResetButtonParent(button, parent)
	if parent ~= button.__owner then
		button:SetParent(button.__owner)
	end
end

local function ResetButtonAnchor(button)
	button:ClearAllPoints()
	button:SetAllPoints()
end

-- Function for setting up button textures
local function SetupButtonTextures(button)
	local pushed = button:GetPushedTexture()
	local disabled = button:GetDisabledTexture()
	local highlight = button:GetHighlightTexture()
	local flash = button.Flash

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

	highlight:SetTexture(K.MediaFolder .. "Skins\\HighlightMicroButtonWhite")
	highlight:SetVertexColor(K.r, K.g, K.b)
	highlight:SetPoint("TOPLEFT", button, "TOPLEFT", -22, 18)
	highlight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 24, -18)
	
	if flash then
		flash:SetTexture(K.MediaFolder .. "Skins\\HighlightMicroButtonYellow")
		flash:SetPoint("TOPLEFT", button, "TOPLEFT", -22, 18)
		flash:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 24, -18)
	end
end

function MicroButtonCreate(parent, data)
	local function SetTextureProperties(icon, texture)
		icon:SetPoint("TOPLEFT", -9, 5)
		icon:SetPoint("BOTTOMRIGHT", 10, -6)
		icon:SetTexture(K.MediaFolder .. "Skins\\" .. texture)
	end

	local texture, method, tooltip = unpack(data)

	local buttonFrame = CreateFrame("Frame", "KKUI_MicroButtons", parent)
	table_insert(buttonList, buttonFrame)
	buttonFrame:SetSize(22, 30)
	buttonFrame:CreateBorder()

	local icon = buttonFrame:CreateTexture(nil, "ARTWORK")
	SetTextureProperties(icon, texture)

	if type(method) == "string" then
		local button = _G[method]
		button:SetHitRectInsets(0, 0, 0, 0)
		button:SetParent(buttonFrame)
		button.__owner = buttonFrame
		hooksecurefunc(button, "SetParent", ResetButtonParent)
		ResetButtonAnchor(button)
		hooksecurefunc(button, "SetPoint", ResetButtonAnchor)
		button:UnregisterAllEvents()
		button:SetNormalTexture(0)

		if tooltip then
			K.AddTooltip(button, "ANCHOR_RIGHT", tooltip)
		end

		if C["ActionBar"].FadeMicroMenu then
			button:HookScript("OnEnter", OnMicroButtonEnter)
		end

		SetupButtonTextures(button)	
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

function Module:MicroMenu()
	if not C["ActionBar"].MicroBar then return end

	local menubar = CreateFrame("Frame", "KKUI_MenuBar", UIParent)
	menubar:SetSize(302, 30)
	menubar:SetAlpha((C["ActionBar"].FadeMicroMenu and not menubar.IsMouseOvered and 0) or 1)
	menubar:EnableMouse(false)
	K.Mover(menubar, "Menubar", "Menubar", { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 4 })

	-- Generate Buttons
	local buttonInfo = {
		{ "CharacterMicroButton", "CharacterMicroButton", MicroButtonTooltipText(CHARACTER_BUTTON, "TOGGLECHARACTER0") },
		{ "SpellbookMicroButton", "SpellbookMicroButton", MicroButtonTooltipText(SPELLBOOK_ABILITIES_BUTTON, "TOGGLESPELLBOOK") },
		{ "TalentMicroButton", "TalentMicroButton", MicroButtonTooltipText(TALENTS, "TOGGLETALENTS") },
		{ "AchievementMicroButton", "AchievementMicroButton", MicroButtonTooltipText(ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT") },
		{ "QuestLogMicroButton", "QuestLogMicroButton", MicroButtonTooltipText(QUESTLOG_BUTTON, "TOGGLEQUESTLOG") },
		{ "GuildMicroButton", "SocialsMicroButton", MicroButtonTooltipText(SOCIAL_BUTTON, "TOGGLESOCIAL") },
		{ "LFDMicroButton", "PVPMicroButton", MicroButtonTooltipText(PLAYER_V_PLAYER, "TOGGLECHARACTER4") },
		{ "LFDMicroButton", "LFGMicroButton", MicroButtonTooltipText(LFG_BUTTON, "TOGGLELFG") },
		{ "CollectionsMicroButton", "CollectionsMicroButton", MicroButtonTooltipText(COLLECTIONS, "TOGGLECOLLECTIONS") },
		{ "StoreMicroButton", function() ToggleStoreUI() end, BLIZZARD_STORE},
		{ "MainMenuMicroButton", "MainMenuMicroButton", MicroButtonTooltipText(MAINMENU_BUTTON, "TOGGLEGAMEMENU") },
	}

	for _, info in pairs(buttonInfo) do
		MicroButtonCreate(menubar, info)
	end

	-- Order Positions
	for i, buttonFrame in ipairs(buttonList) do
		if i == 1 then
			buttonFrame:SetPoint("LEFT")
		else
			buttonFrame:SetPoint("LEFT", buttonList[i - 1], "RIGHT", 6, 0)
		end
	end

	-- Default elements
	K.HideInterfaceOption(PVPMicroButtonTexture)
	K.HideInterfaceOption(MicroButtonPortrait)
	K.HideInterfaceOption(MainMenuBarDownload)
	K.HideInterfaceOption(HelpOpenWebTicketButton)
	K.HideInterfaceOption(MainMenuBarPerformanceBar)
	MainMenuMicroButton:SetScript("OnUpdate", nil)
end
