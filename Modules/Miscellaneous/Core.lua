local K = KkthnxUI[1]
local C = KkthnxUI[2]
local L = KkthnxUI[3]
local Module = K:NewModule("Miscellaneous")

-- Localizing Lua built-in functions
local select = select
local tonumber = tonumber
local next = next
local type = type
local ipairs = ipairs
local pcall = pcall
local error = error

-- Localizing WoW API functions
local CreateFrame = CreateFrame
local PlaySound = PlaySound
local StaticPopup_Show = StaticPopup_Show
local hooksecurefunc = hooksecurefunc
local UIParent = UIParent
local UnitXP = UnitXP
local UnitXPMax = UnitXPMax
local UnitGUID = UnitGUID
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantItemMaxStack = GetMerchantItemMaxStack
local GetRewardXP = GetRewardXP
local GetQuestLogRewardXP = GetQuestLogRewardXP
local IsAltKeyDown = IsAltKeyDown
local InCombatLockdown = InCombatLockdown
local C_BattleNet_GetGameAccountInfoByGUID = C_BattleNet.GetGameAccountInfoByGUID
local C_FriendList_IsFriend = C_FriendList.IsFriend
local C_QuestLog_GetSelectedQuest = C_QuestLog.GetSelectedQuest
local C_QuestLog_ShouldShowQuestRewards = C_QuestLog.ShouldShowQuestRewards
local GetItemInfo = C_Item.GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local StaticPopupDialogs = StaticPopupDialogs
local IsGuildMember = IsGuildMember

-- Localizing WoW UI constants
local FRIEND = FRIEND
local GUILD = GUILD
local NO = NO
local YES = YES

-- Miscellaneous Module Registry
local KKUI_MISC_MODULE = {}

-- Register Miscellaneous Modules
function Module:RegisterMisc(name, func)
	if not KKUI_MISC_MODULE[name] then
		KKUI_MISC_MODULE[name] = func
	end
end

-- Enable Module and Initialize Miscellaneous Modules
function Module:OnEnable()
	for name, func in next, KKUI_MISC_MODULE do
		if name and type(func) == "function" then
			func()
		end
	end

	local loadMiscModules = {
		"CreateAutoBubbles",		
		"CreateBossEmote",
		"CreateDurabilityFrameMove",
		"CreateErrorFrameToggle",
		"CreateGUIGameMenuButton",
		"CreateMinimapButton",
		"CreateQuickDeleteDialog",
		"CreateQuickMenuButton",
		"CreateTicketStatusFrameMove",
		"CreateTradeTargetInfo",
		"CreateVehicleSeatMover",
		"CreateThreatbar",
		"CreateQueueTimer",
		"NakedIcon",

		--"CreateQuestSizeUpdate",
	}
	
	K.Delay(0, Module.UpdateMaxCameraZoom)

	for _, funcName in ipairs(loadMiscModules) do
		local func = self[funcName]
		if type(func) == "function" then
			local success, err = pcall(func, self)
			if not success then
				error("Error in " .. funcName .. ": " .. tostring(err), 2)
			end
		end
	end
end

-- Enable Auto Chat Bubbles
function Module:CreateAutoBubbles()
	if C["Misc"].AutoBubbles then
		local function updateBubble()
			local name, instType = GetInstanceInfo()
			SetCVar("chatBubbles", (name and instType == "raid") and 1 or 0)
		end
		K:RegisterEvent("PLAYER_ENTERING_WORLD", updateBubble)
	end
end

-- Readycheck sound on master channel
K:RegisterEvent("READY_CHECK", function()
	PlaySound(SOUNDKIT.READY_CHECK, "master")
end)

-- Modify Delete Dialog
function Module:CreateQuickDeleteDialog()
	local confirmationText = DELETE_GOOD_ITEM:gsub("[\r\n]", "@")
	local _, confirmationType = strsplit("@", confirmationText, 2)

	local function setHyperlinkHandlers(dialog)
		dialog.OnHyperlinkEnter = StaticPopupDialogs["DELETE_GOOD_ITEM"].OnHyperlinkEnter
		dialog.OnHyperlinkLeave = StaticPopupDialogs["DELETE_GOOD_ITEM"].OnHyperlinkLeave
	end

	setHyperlinkHandlers(StaticPopupDialogs["DELETE_ITEM"])
	setHyperlinkHandlers(StaticPopupDialogs["DELETE_QUEST_ITEM"])
	setHyperlinkHandlers(StaticPopupDialogs["DELETE_GOOD_QUEST_ITEM"])

	local deleteConfirmationFrame = CreateFrame("FRAME")
	deleteConfirmationFrame:RegisterEvent("DELETE_ITEM_CONFIRM")
	deleteConfirmationFrame:SetScript("OnEvent", function()
		local staticPopup = StaticPopup1
		local editBox = StaticPopup1EditBox
		local button = StaticPopup1Button1
		local popupText = StaticPopup1Text

		if editBox:IsShown() then
			staticPopup:SetHeight(staticPopup:GetHeight() - 14)
			editBox:Hide()
			button:Enable()
			local link = select(3, GetCursorInfo())

			if link then
				local linkType, linkOptions, name = LinkUtil.ExtractLink(link)
				popupText:SetText(popupText:GetText():gsub(confirmationType, "") .. "|n|n" .. link)
			end
		else
			staticPopup:SetHeight(staticPopup:GetHeight() + 40)
			editBox:Hide()
			button:Enable()
			local link = select(3, GetCursorInfo())

			if link then
				local linkType, linkOptions, name = LinkUtil.ExtractLink(link)
				popupText:SetText(popupText:GetText():gsub(confirmationType, "") .. "|n|n" .. link)
			end
		end
	end)
end

-- Update Drag Cursor for Minimap
local function UpdateDragCursor(self)
	local minimapCenterX, minimapCenterY = Minimap:GetCenter()
	local cursorX, cursorY = GetCursorPosition()
	local scale = Minimap:GetEffectiveScale()
	cursorX, cursorY = cursorX / scale, cursorY / scale

	local angle = atan2(cursorY - minimapCenterY, cursorX - minimapCenterX)
	local x, y, quadrant = cos(angle), sin(angle), 1
	if x < 0 then
		quadrant = quadrant + 1
	end
	if y > 0 then
		quadrant = quadrant + 2
	end

	local width = (Minimap:GetWidth() / 2) + 5
	local height = (Minimap:GetHeight() / 2) + 5
	local diagRadiusW = sqrt(2 * width ^ 2) - 10
	local diagRadiusH = sqrt(2 * height ^ 2) - 10
	x = max(-width, min(x * diagRadiusW, width))
	y = max(-height, min(y * diagRadiusH, height))

	self:ClearAllPoints()
	self:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Click Minimap Button Functionality
local function OnMinimapButtonClick(_, button)
	if button == "LeftButton" then
		if SettingsPanel:IsShown() or ChatConfigFrame:IsShown() then
			return
		end
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(K.InfoColor .. ERR_NOT_IN_COMBAT)
			return
		end
		K.GUI:Toggle()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION, "SFX")
	end
end

-- Create Minimap Button
function Module:CreateMinimapButton()
	local minimapButton = CreateFrame("Button", "KKUI_MinimapButton", Minimap)
	minimapButton:SetFrameStrata("MEDIUM")
	minimapButton:SetPoint("BOTTOMLEFT", -15, 20)
	minimapButton:SetSize(32, 32)
	minimapButton:SetMovable(true)
	minimapButton:SetUserPlaced(true)
	minimapButton:RegisterForDrag("LeftButton")

	local overlay = minimapButton:CreateTexture(nil, "OVERLAY")
	overlay:SetSize(53, 53)
	overlay:SetTexture(136430)
	overlay:SetPoint("TOPLEFT")

	local background = minimapButton:CreateTexture(nil, "BACKGROUND")
	background:SetSize(20, 20)
	background:SetTexture(136467)
	background:SetPoint("TOPLEFT", 7, -5)

	local icon = minimapButton:CreateTexture(nil, "ARTWORK")
	icon:SetSize(16, 16)
	icon:SetPoint("CENTER")
	icon:SetTexture(C["Media"].Textures.LogoSmallTexture)

	minimapButton:SetScript("OnEnter", function()
		GameTooltip:SetOwner(minimapButton, "ANCHOR_LEFT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(K.Title, 1, 0.8, 0)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cff00ff00Left Click:|r Open Configuration", 0.8, 0.8, 0.8)
		GameTooltip:Show()
	end)

	minimapButton:SetScript("OnLeave", GameTooltip_Hide)
	minimapButton:RegisterForClicks("AnyUp")
	minimapButton:SetScript("OnClick", OnMinimapButtonClick)
	minimapButton:SetScript("OnDragStart", function(self)
		self:SetScript("OnUpdate", UpdateDragCursor)
	end)
	minimapButton:SetScript("OnDragStop", function(self)
		self:SetScript("OnUpdate", nil)
	end)

	function Module:ToggleMinimapButton()
		if C.General.MinimapIcon then
			minimapButton:Show()
		else
			minimapButton:Hide()
		end
	end

	Module:ToggleMinimapButton()
end

-- Game Menu Setup
function Module:CreateGUIGameMenuButton()
	local gameMenuButton = CreateFrame("Button", "KKUI_GameMenuFrame", GameMenuFrame, "GameMenuButtonTemplate")
	gameMenuButton:SetHeight(26)
	gameMenuButton:SetText(K.Title)
	gameMenuButton:SetPoint("TOP", GameMenuButtonAddons, "BOTTOM", 0, -21)

	gameMenuButton.Left:SetDesaturated(1)
	gameMenuButton.Middle:SetDesaturated(1)
	gameMenuButton.Right:SetDesaturated(1)

	GameMenuFrame:HookScript("OnShow", function(self)
		GameMenuButtonLogout:SetPoint("TOP", gameMenuButton, "BOTTOM", 0, -21)
		GameMenuButtonStore:SetPoint("TOP", GameMenuButtonHelp, "BOTTOM", 0, -6)
		GameMenuButtonMacros:SetPoint("TOP", GameMenuButtonOptions, "BOTTOM", 0, -6)
		GameMenuButtonAddons:SetPoint("TOP", GameMenuButtonMacros, "BOTTOM", 0, -6)
		GameMenuButtonQuit:SetPoint("TOP", GameMenuButtonLogout, "BOTTOM", 0, -6)
		self:SetHeight(self:GetHeight() + gameMenuButton:GetHeight() + 22)
		if self:GetScale() ~= 1.2 then
			self:SetScale(1.2)
		end
	end)

	gameMenuButton:SetScript("OnClick", function()
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(K.InfoColor .. ERR_NOT_IN_COMBAT)
			return
		end
		K["GUI"]:Toggle()
		HideUIPanel(GameMenuFrame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	end)
end

-- Reanchor DurabilityFrame
function Module:CreateDurabilityFrameMove()
	-- Create a new frame to hold the DurabilityFrame
	local durabilityHolder = CreateFrame("Frame", "KKUI_DurabilityHolder", UIParent)
	durabilityHolder:SetSize(DurabilityFrame:GetSize())
	durabilityHolder:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -40, -50)

	-- Create a mover for the new frame
	K.Mover(durabilityHolder, "DurabilityFrameMover", "Durability Frame", { "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 470, 50 })

	-- Reanchor the DurabilityFrame to the new frame
	DurabilityFrame:ClearAllPoints()
	DurabilityFrame:SetPoint("CENTER", durabilityHolder, "CENTER")
	DurabilityFrame:SetParent(durabilityHolder)

	-- Hook the SetPoint function to prevent it from being moved by other addons
	hooksecurefunc(DurabilityFrame, "SetPoint", function(self, _, parent)
		if parent == "MinimapCluster" or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint("CENTER", durabilityHolder, "CENTER")
			self:SetParent(durabilityHolder)
		end
	end)
end

-- Reanchor Ticket Status Frame
function Module:CreateTicketStatusFrameMove()
	hooksecurefunc(TicketStatusFrame, "SetPoint", function(self, relF)
		if relF == "TOPRIGHT" then
			self:ClearAllPoints()
			self:SetPoint("TOP", UIParent, "TOP", -400, -20)
		end
	end)
end

-- Hide Boss Emote
function Module:CreateBossEmote()
	if C["Misc"].HideBossEmote then
		RaidBossEmoteFrame:UnregisterAllEvents()
	else
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_EMOTE")
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_WHISPER")
		RaidBossEmoteFrame:RegisterEvent("CLEAR_BOSS_EMOTES")
	end
end

local function SetupErrorFrameToggle(event)
	if event == "PLAYER_REGEN_DISABLED" then
		_G.UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		K:RegisterEvent("PLAYER_REGEN_ENABLED", SetupErrorFrameToggle)
	else
		_G.UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
		K:UnregisterEvent(event, SetupErrorFrameToggle)
	end
end

function Module:CreateErrorFrameToggle()
	if C["General"].NoErrorFrame then
		K:RegisterEvent("PLAYER_REGEN_DISABLED", SetupErrorFrameToggle)
	else
		K:UnregisterEvent("PLAYER_REGEN_DISABLED", SetupErrorFrameToggle)
	end
end

--function Module:CreateQuestSizeUpdate()
--	QuestTitleFont:SetFont(QuestTitleFont:GetFont(), C["Skins"].QuestFontSize + 3, "")
--	QuestFont:SetFont(QuestFont:GetFont(), C["Skins"].QuestFontSize + 1, "")
--	QuestFontNormalSmall:SetFont(QuestFontNormalSmall:GetFont(), C["Skins"].QuestFontSize, "")
--end

-- TradeFrame hook
function Module:CreateTradeTargetInfo()
	local infoText = K.CreateFontString(TradeFrame, 16, "", "")
	infoText:SetPoint("TOP", TradeFrameRecipientNameText, "BOTTOM", 0, -8)

	local function updateColor()
		local r, g, b = K.UnitColor("NPC")
		TradeFrameRecipientNameText:SetTextColor(r, g, b)
		local guid = UnitGUID("NPC")
		if not guid then
			return
		end
		local text = "|cffff0000" .. L["Stranger"]
		if C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) then
			text = "|cffffff00" .. FRIEND
		elseif IsGuildMember(guid) then
			text = "|cff00ff00" .. GUILD
		end
		infoText:SetText(text)
	end

	updateColor()
	TradeFrame:HookScript("OnShow", updateColor)
end

-- Archaeology counts
do
	local function DisplayArchaeologyCounts(tooltip, anchor)
		tooltip:SetOwner(anchor, "ANCHOR_BOTTOMRIGHT")
		tooltip:ClearLines()
		tooltip:AddLine("|c0000FF00Arch Count:")
		tooltip:AddLine(" ")

		local totalArtifacts = 0
		for raceIndex = 1, GetNumArchaeologyRaces() do
			local numArtifacts = GetNumArtifactsByRace(raceIndex)
			local raceArtifactCount = 0
			for artifactIndex = 1, numArtifacts do
				local completionCount = select(10, GetArtifactInfoByRace(raceIndex, artifactIndex))
				raceArtifactCount = raceArtifactCount + completionCount
			end
			if numArtifacts > 1 then
				local raceName = GetArchaeologyRaceInfo(raceIndex)
				tooltip:AddDoubleLine(raceName .. ":", K.InfoColor .. raceArtifactCount)
				totalArtifacts = totalArtifacts + raceArtifactCount
			end
		end

		tooltip:AddLine(" ")
		tooltip:AddDoubleLine("|c0000ff00" .. TOTAL .. ":", "|cffff0000" .. totalArtifacts)
		tooltip:Show()
	end

	local function CreateArchaeologyCalculateButton()
		local button = CreateFrame("Button", nil, ArchaeologyFrameCompletedPage)
		button:SetPoint("TOPRIGHT", -45, -45)
		button:SetSize(35, 35)
		button.Icon = button:CreateTexture(nil, "ARTWORK")
		button.Icon:SetAllPoints()
		button.Icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])
		button.Icon:SetTexture("Interface\\ICONS\\TRADE_ARCHAEOLOGY_HIGHBORNE_SCROLL")
		button:CreateBorder()
		button:StyleButton()

		button:SetScript("OnEnter", function()
			DisplayArchaeologyCounts(GameTooltip, button)
		end)
		button:SetScript("OnLeave", K.HideTooltip)
	end

	local function InitializeArchaeologyUI(event, addon)
		if addon == "Blizzard_ArchaeologyUI" then
			CreateArchaeologyCalculateButton()

			K:UnregisterEvent(event, InitializeArchaeologyUI)
		end
	end
	K:RegisterEvent("ADDON_LOADED", InitializeArchaeologyUI)
end

-- ALT+RightClick to buy a stack
do
	local cache = {}
	local itemLink, id

	StaticPopupDialogs["BUY_STACK"] = {
		text = L["Stack Buying Check"],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			if not itemLink then return end
			BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			cache[itemLink] = true
			itemLink = nil
		end,
		hideOnEscape = 1,
		hasItemFrame = 1,
	}

	local _MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
	function MerchantItemButton_OnModifiedClick(self, ...)
		if IsAltKeyDown() then
			id = self:GetID()
			itemLink = GetMerchantItemLink(id)
			if not itemLink then return end

			local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
			if maxStack and maxStack > 1 then
				if not cache[itemLink] then
					local r, g, b = GetItemQualityColor(quality or 1)
					StaticPopup_Show("BUY_STACK", " ", " ", {
						["texture"] = texture,
						["name"] = name,
						["color"] = { r, g, b, 1 },
						["link"] = itemLink,
						["index"] = id,
						["count"] = maxStack,
					})
				else
					BuyMerchantItem(id, GetMerchantItemMaxStack(id))
				end
			end
		end
		_MerchantItemButton_OnModifiedClick(self, ...)
	end
end

-- Get Naked
function Module:NakedIcon()
	local bu = CreateFrame("Button", nil, CharacterFrameInsetRight)
	bu:SetSize(31, 34)
	bu:SetPoint("RIGHT", PaperDollSidebarTab1, "LEFT", -4, 1)
	bu:SetFrameLevel(PaperDollSidebarTab1:GetFrameLevel())

	bu.Icon = bu:CreateTexture(nil, "ARTWORK")
	bu.Icon:SetTexture("Interface\\ICONS\\SPELL_SHADOW_TWISTEDFAITH")
	bu.Icon:SetAllPoints()
	bu.Icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])

	bu.bg = CreateFrame("Frame", nil, bu)
	bu.bg:SetAllPoints()
	bu.bg:SetFrameLevel(bu:GetFrameLevel())
	bu.bg:CreateBorder()

	K.AddTooltip(bu, "ANCHOR_RIGHT", "Double click to unequip all items.")

	local function UnequipItemInSlot(i)
		local action = EquipmentManager_UnequipItemInSlot(i)
		EquipmentManager_RunAction(action)
	end

	bu:SetScript("OnDoubleClick", function()
		for i = 1, 18 do
			local texture = GetInventoryItemTexture("player", i)
			if texture then
				UnequipItemInSlot(i)
			end
		end
	end)
end

-- Reanchor Vehicle
function Module:CreateVehicleSeatMover()
	if not VehicleSeatIndicator then return end

	local frame = CreateFrame("Frame", "KKUI_VehicleSeatMover", UIParent)
	frame:SetSize(125, 125)
	K.Mover(frame, "VehicleSeat", "VehicleSeat", {"BOTTOMRIGHT", UIParent, -530, 120})

	hooksecurefunc(VehicleSeatIndicator, "SetPoint", function(self, _, parent)
		if parent ~= frame then
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", frame)
		end
	end)
end

-- Buttons to enhance popup menu
function Module:CustomMenu_AddFriend(rootDescription, data, name)
	rootDescription:CreateButton(K.InfoColor .. ADD_CHARACTER_FRIEND, function()
		local fullName = data.server and data.name .. "-" .. data.server or data.name
		C_FriendList.AddFriend(name or fullName)
	end)
end

local guildInviteString = gsub(CHAT_GUILD_INVITE_SEND, HEADER_COLON, "")
function Module:CustomMenu_GuildInvite(rootDescription, data, name)
	rootDescription:CreateButton(K.InfoColor .. guildInviteString, function()
		local fullName = data.server and data.name .. "-" .. data.server or data.name
		C_GuildInfo.Invite(name or fullName)
	end)
end

function Module:CustomMenu_CopyName(rootDescription, data, name)
	rootDescription:CreateButton(K.InfoColor .. COPY_NAME, function()
		local editBox = ChatEdit_ChooseBoxForSend()
		local hasText = (editBox:GetText() ~= "")
		ChatEdit_ActivateChat(editBox)
		editBox:Insert(name or data.name)
		if not hasText then
			editBox:HighlightText()
		end
	end)
end

function Module:CustomMenu_Whisper(rootDescription, data)
	rootDescription:CreateButton(K.InfoColor .. WHISPER, function()
		ChatFrame_SendTell(data.name)
	end)
end

function Module:CreateQuickMenuButton()
	-- if not C["Misc"].MenuButton then
	-- 	return
	-- end

	--hooksecurefunc(UnitPopupManager, "OpenMenu", function(_, which)
	--	print("MENU_UNIT_"..which)
	--end)

	Menu.ModifyMenu("MENU_UNIT_SELF", function(_, rootDescription, data)
		Module:CustomMenu_CopyName(rootDescription, data)
		Module:CustomMenu_Whisper(rootDescription, data)
	end)

	Menu.ModifyMenu("MENU_UNIT_TARGET", function(_, rootDescription, data)
		Module:CustomMenu_CopyName(rootDescription, data)
	end)

	Menu.ModifyMenu("MENU_UNIT_PLAYER", function(_, rootDescription, data)
		Module:CustomMenu_GuildInvite(rootDescription, data)
	end)

	Menu.ModifyMenu("MENU_UNIT_FRIEND", function(_, rootDescription, data)
		Module:CustomMenu_AddFriend(rootDescription, data)
		Module:CustomMenu_GuildInvite(rootDescription, data)
	end)

	Menu.ModifyMenu("MENU_UNIT_BN_FRIEND", function(_, rootDescription, data)
		local fullName
		local gameAccountInfo = data.accountInfo and data.accountInfo.gameAccountInfo
		if gameAccountInfo then
			local characterName = gameAccountInfo.characterName
			local realmName = gameAccountInfo.realmName
			if characterName and realmName then
				fullName = characterName .. "-" .. realmName
			end
		end

		Module:CustomMenu_AddFriend(rootDescription, data, fullName)
		Module:CustomMenu_GuildInvite(rootDescription, data, fullName)
		Module:CustomMenu_CopyName(rootDescription, data, fullName)
	end)

	Menu.ModifyMenu("MENU_UNIT_PARTY", function(_, rootDescription, data)
		Module:CustomMenu_GuildInvite(rootDescription, data)
	end)

	Menu.ModifyMenu("MENU_UNIT_RAID", function(_, rootDescription, data)
		Module:CustomMenu_AddFriend(rootDescription, data)
		Module:CustomMenu_GuildInvite(rootDescription, data)
		Module:CustomMenu_CopyName(rootDescription, data)
		Module:CustomMenu_Whisper(rootDescription, data)
	end)

	Menu.ModifyMenu("MENU_UNIT_RAID_PLAYER", function(_, rootDescription, data)
		Module:CustomMenu_GuildInvite(rootDescription, data)
	end)
end

-- Update Max Camera Zoom
function Module:UpdateMaxCameraZoom()
	SetCVar("cameraDistanceMaxZoomFactor", C["Misc"].MaxCameraZoom)
end
