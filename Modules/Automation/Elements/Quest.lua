local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]

local next, ipairs, select = next, ipairs, select

local AcceptQuest, CloseQuest, CompleteQuest = AcceptQuest, CloseQuest, CompleteQuest
local C_GossipInfo_GetActiveQuests = C_GossipInfo.GetActiveQuests
local C_GossipInfo_GetAvailableQuests = C_GossipInfo.GetAvailableQuests
local C_GossipInfo_GetNumActiveQuests = C_GossipInfo.GetNumActiveQuests
local C_GossipInfo_GetNumAvailableQuests = C_GossipInfo.GetNumAvailableQuests
local C_GossipInfo_GetOptions = C_GossipInfo.GetOptions
local C_GossipInfo_SelectActiveQuest = C_GossipInfo.SelectActiveQuest
local C_GossipInfo_SelectAvailableQuest = C_GossipInfo.SelectAvailableQuest
local C_GossipInfo_SelectOption = C_GossipInfo.SelectOption
local GetInstanceInfo, GetQuestID = GetInstanceInfo, GetQuestID
local GetNumActiveQuests, GetActiveTitle = GetNumActiveQuests, GetActiveTitle
local GetNumAvailableQuests, SelectAvailableQuest = GetNumAvailableQuests, SelectAvailableQuest
local GetNumQuestChoices, GetQuestReward, GetQuestItemInfo = GetNumQuestChoices, GetQuestReward, GetQuestItemInfo
local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetNumTrackingTypes = C_Minimap.GetNumTrackingTypes
local GetQuestLogTitle = GetQuestLogTitle
local GetQuestTagInfo = GetQuestTagInfo
local GetTrackingInfo = C_Minimap.GetTrackingInfo
local IsAltKeyDown = IsAltKeyDown
local IsQuestCompletable, GetNumQuestItems, GetQuestItemLink = IsQuestCompletable, GetNumQuestItems, GetQuestItemLink
local MINIMAP_TRACKING_TRIVIAL_QUESTS = MINIMAP_TRACKING_TRIVIAL_QUESTS
local QuestLabelPrepend = Enum.GossipOptionRecFlags.QuestLabelPrepend
local UnitGUID, IsShiftKeyDown, GetItemInfoFromHyperlink = UnitGUID, IsShiftKeyDown, GetItemInfoFromHyperlink

local quests, choiceQueue = {}

-- Minimap checkbox
local isCheckButtonCreated
local function setupCheckButton()
	if isCheckButtonCreated then
		return
	end

	local AutoQuestCheckButton = CreateFrame("CheckButton", nil, WorldMapFrame.BorderFrame, "OptionsBaseCheckButtonTemplate")
	AutoQuestCheckButton:SetFrameLevel(WorldMapFrame:GetFrameLevel() + 2)
	AutoQuestCheckButton:ClearAllPoints()
	if C_AddOns.IsAddOnLoaded("Leatrix_Maps") and LeaMapsDB and LeaMapsDB["UseDefaultMap"] == "Off" then
		if LeaMapsDB["ShowCoords"] == "On" then
			AutoQuestCheckButton:SetPoint("BOTTOMLEFT", 22, 44)
		else
			AutoQuestCheckButton:SetPoint("BOTTOMLEFT", 22, 26)
		end
	else
		AutoQuestCheckButton:SetPoint("TOPRIGHT", -140, 0)
	end
	AutoQuestCheckButton:SetSize(24, 24)

	AutoQuestCheckButton.text = AutoQuestCheckButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	AutoQuestCheckButton.text:SetPoint("LEFT", 24, 0)
	AutoQuestCheckButton.text:SetText(L["Auto Quest"])

	if C_AddOns.IsAddOnLoaded("Leatrix_Maps") and LeaMapsDB and LeaMapsDB["UseDefaultMap"] == "Off" then
		AutoQuestCheckButton.text:SetTextColor(1, 1, 1)
	else
		AutoQuestCheckButton.text:SetTextColor(1.0, 0.82, 0)
	end

	AutoQuestCheckButton:SetHitRectInsets(0, 0 - AutoQuestCheckButton.text:GetWidth(), 0, 0)
	AutoQuestCheckButton:SetChecked(KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest)
	AutoQuestCheckButton:SetScript("OnClick", function(self)
		KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest = self:GetChecked()
	end)
	AutoQuestCheckButton.title = "Auto Quest"
	K.AddTooltip(AutoQuestCheckButton, "ANCHOR_BOTTOMLEFT", "|nWhen enabled, quests and dialogs will be interacted with automatically.|n|nIf a gossip window has only one option, it will be automatically selected.|n|nHold the SHIFT key to temporarily pause automation.|n|nTo block an NPC from being auto-interacted with, hold the ALT key and click their name on the Gossip or Quest frame.", "info", "Auto Quest", true)

	local QuestToggle = _G.Questie_Toggle
	if QuestToggle then
		QuestToggle:ClearAllPoints()
		QuestToggle:SetHeight(22)
		QuestToggle:SetPoint("LEFT", WorldMapZoomOutButton, "RIGHT", 5, 0)
		QuestToggle.SetPoint = K.Noop
	end

	isCheckButtonCreated = true
end
WorldMapFrame:HookScript("OnShow", setupCheckButton)

-- Main
local QuickQuest = CreateFrame("Frame")
QuickQuest:SetScript("OnEvent", function(self, event, ...)
	self[event](...)
end)

function QuickQuest:Register(event, func)
	self:RegisterEvent(event)
	self[event] = function(...)
		if KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest and not IsShiftKeyDown() then
			func(...)
		end
	end
end

local function GetNPCID()
	return K.GetNPCID(UnitGUID("npc"))
end

local function IsTrackingHidden()
	local numTrackingTypes = GetNumTrackingTypes()
	if numTrackingTypes == 0 then
		return false
	end

	for index = 1, numTrackingTypes do
		local name, _, active = GetTrackingInfo(index)
		if name == MINIMAP_TRACKING_TRIVIAL_QUESTS then
			return active
		end
	end

	return false
end

C.IgnoreQuestNPC = {}

local function GetQuestLogQuests(onlyComplete)
	wipe(quests)

	for index = 1, GetNumQuestLogEntries() do
		local title, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(index)
		if not isHeader then
			if (onlyComplete and isComplete) or not onlyComplete then
				quests[title] = questID
			end
		end
	end

	return quests
end

QuickQuest:Register("QUEST_GREETING", function()
	local npcID = GetNPCID()
	if C.IgnoreQuestNPC[npcID] then
		return
	end

	if UnitExists("npc") or QuestFrameGreetingPanel:IsShown() then
		local active = GetNumActiveQuests()
		if active > 0 then
			local logQuests = GetQuestLogQuests(true)
			for index = 1, active do
				local name, complete = GetActiveTitle(index)
				if complete then
					local questID = logQuests[name]
					if not questID then
						C_GossipInfo_SelectActiveQuest(index)
					else
						local _, _, worldQuest = GetQuestTagInfo(questID)
						if not worldQuest then
							C_GossipInfo_SelectActiveQuest(index)
						end
					end
				end
			end
		end

		local available = GetNumAvailableQuests()
		if available > 0 then
			for index = 1, available do
				local isTrivial = IsActiveQuestTrivial(index)
				if not isTrivial then
					C_GossipInfo_SelectAvailableQuest(index)
				end
			end
		end
	end
end)

local QUEST_STRING = "cFF0000FF.-" .. TRANSMOG_SOURCE_2
QuickQuest:Register("GOSSIP_SHOW", function()
	local npcID = GetNPCID()
	if C.IgnoreQuestNPC[npcID] then
		return
	end

	if UnitExists("npc") or QuestFrameGreetingPanel:IsShown() then
		local active = C_GossipInfo_GetNumActiveQuests()
		if active > 0 then
			for _, questInfo in ipairs(C_GossipInfo_GetActiveQuests()) do
				local questID = questInfo.questID
				if questInfo.isComplete and questID then
					C_GossipInfo_SelectActiveQuest(questID)
				end
			end
		end

		local available = C_GossipInfo_GetNumAvailableQuests()
		if available > 0 then
			for _, questInfo in ipairs(C_GossipInfo_GetAvailableQuests()) do
				local trivial = questInfo.isTrivial
				if not trivial or IsTrackingHidden() then
					C_GossipInfo_SelectAvailableQuest(questInfo.questID)
				end
			end
		end

		local gossipInfoTable = C_GossipInfo_GetOptions()
		if not gossipInfoTable then
			return
		end

		local numOptions = #gossipInfoTable
		local firstOptionID = gossipInfoTable[1] and gossipInfoTable[1].gossipOptionID

		if firstOptionID then
			if C["AutoQuestData"].AutoSelectFirstOptionList[npcID] then
				return C_GossipInfo_SelectOption(firstOptionID)
			end

			if available == 0 and active == 0 and numOptions == 1 then
				local _, instance, _, _, _, _, _, mapID = GetInstanceInfo()
				if instance ~= "raid" and not C["AutoQuestData"].IgnoreGossipNPC[npcID] and not C["AutoQuestData"].IgnoreInstances[mapID] then
					return C_GossipInfo_SelectOption(firstOptionID)
				end
			end
		end

		-- Automatically select a quest with only one quest option
		local numQuestGossips = 0
		local questGossipID

		for i = 1, numOptions do
			local option = gossipInfoTable[i]
			if option.name and (strfind(option.name, QUEST_STRING) or option.flags == QuestLabelPrepend) then
				numQuestGossips = numQuestGossips + 1
				questGossipID = option.gossipOptionID
			end
		end

		if numQuestGossips == 1 and questGossipID then
			return C_GossipInfo_SelectOption(questGossipID)
		end
	end
end)

QuickQuest:Register("GOSSIP_CONFIRM", function(index)
	local npcID = GetNPCID()
	if npcID and C["AutoQuestData"].SkipConfirmNPCs[npcID] then
		SelectGossipOption(index, "", true)
		StaticPopup_Hide("GOSSIP_CONFIRM")
	end
end)

QuickQuest:Register("QUEST_DETAIL", function()
	if not C.IgnoreQuestNPC[GetNPCID()] then
		AcceptQuest()
	end
end)

QuickQuest:Register("QUEST_ACCEPT_CONFIRM", function()
	ConfirmAcceptQuest()
	StaticPopup_Hide("QUEST_ACCEPT")
end)

QuickQuest:Register("QUEST_ACCEPTED", function()
	if QuestFrame:IsShown() then
		CloseQuest()
	end
end)

QuickQuest:Register("QUEST_ITEM_UPDATE", function()
	if choiceQueue and QuickQuest[choiceQueue] then
		QuickQuest[choiceQueue]()
		choiceQueue = nil -- Reset choiceQueue after handling
	end
end)

QuickQuest:Register("QUEST_PROGRESS", function()
	if IsQuestCompletable() then
		local id, _, worldQuest = GetQuestTagInfo(GetQuestID())
		if id == 153 or worldQuest then
			return
		end

		local npcID = GetNPCID()
		if C.IgnoreQuestNPC[npcID] then
			return
		end

		local requiredItems = GetNumQuestItems()
		if requiredItems > 0 then
			for index = 1, requiredItems do
				local link = GetQuestItemLink("required", index)
				if link then
					local id = GetItemInfoFromHyperlink(link)
					for _, itemID in next, C["AutoQuestData"].ItemBlacklist do
						if itemID == id then
							CloseQuest()
							return
						end
					end
				else
					choiceQueue = "QUEST_PROGRESS"
					GetQuestItemInfo("required", index)
					return
				end
			end
		end

		CompleteQuest()
	end
end)

QuickQuest:Register("QUEST_COMPLETE", function()
	-- Blingtron 6000 only!
	local npcID = GetNPCID()
	if npcID == 43929 or npcID == 77789 then
		return
	end

	local choices = GetNumQuestChoices()
	if choices <= 1 then
		GetQuestReward(1)
	elseif choices > 1 then
		local bestValue = 0
		local bestIndex

		for index = 1, choices do
			local link = GetQuestItemLink("choice", index)
			if link then
				local value = select(11, C_Item.GetItemInfo(link))
				local itemID = GetItemInfoFromHyperlink(link)
				value = C["AutoQuestData"].CashRewards[itemID] or value

				if value > bestValue then
					bestValue, bestIndex = value, index
				end
			else
				choiceQueue = "QUEST_COMPLETE"
				return GetQuestItemInfo("choice", index)
			end
		end

		local button = bestIndex and QuestInfoRewardsFrame.RewardButtons[bestIndex]
		if button then
			QuestInfoItem_OnClick(button)
		end
	end
end)

local function AttemptAutoComplete(event, questID)
	if UnitIsDeadOrGhost("player") then
		QuickQuest:Register("PLAYER_REGEN_ENABLED", function()
			AttemptAutoComplete("PLAYER_REGEN_ENABLED", questID)
		end)
		return
	else
		C_Timer.After(1, function()
			AttemptAutoComplete(nil, questID)
		end)
	end

	if event == "PLAYER_REGEN_ENABLED" then
		QuickQuest:UnregisterEvent(event)
	end

	if questID then
		local questIndex = GetQuestLogIndexByID(questID)
		if questIndex and GetQuestLogIsAutoComplete(questIndex) then
			ShowQuestComplete(questIndex)
		end
	end
end

QuickQuest:Register("QUEST_AUTOCOMPLETE", function(_, questID)
	AttemptAutoComplete("QUEST_AUTOCOMPLETE", questID)
end)

-- Handle ignore list
local function UpdateIgnoreList()
	wipe(C.IgnoreQuestNPC)

	for npcID, value in pairs(C["AutoQuestData"].IgnoreQuestNPC) do
		C.IgnoreQuestNPC[npcID] = value
	end

	for npcID, value in pairs(KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuestIgnoreNPC) do
		if value and C["AutoQuestData"].IgnoreQuestNPC[npcID] then
			KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuestIgnoreNPC[npcID] = nil
		else
			C.IgnoreQuestNPC[npcID] = value
		end
	end
end

local function UnitQuickQuestStatus(self)
	if not self.__ignore then
		local frame = CreateFrame("Frame", nil, self)
		frame:SetSize(100, 14)
		frame:SetPoint("TOP", self, "BOTTOM", 0, -2)
		K.AddTooltip(frame, "ANCHOR_RIGHT", "You no longer auto interact quests with current NPC. You can hold key ALT and click the name above to undo this.", "info", true)
		K.CreateFontString(frame, 14, IGNORED):SetTextColor(1, 0, 0)

		self.__ignore = frame

		UpdateIgnoreList()
	end

	local npcID = GetNPCID()
	local isIgnored = KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest and npcID and C.IgnoreQuestNPC[npcID]
	self.__ignore:SetShown(isIgnored)
end

local function ToggleQuickQuestStatus(self)
	if not self.__ignore then
		return
	end
	if not KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest then
		return
	end
	if not IsAltKeyDown() then
		return
	end

	self.__ignore:SetShown(not self.__ignore:IsShown())
	local npcID = GetNPCID()
	if npcID then
		if self.__ignore:IsShown() then
			if C["AutoQuestData"].IgnoreQuestNPC[npcID] then
				KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuestIgnoreNPC[npcID] = nil
			else
				KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuestIgnoreNPC[npcID] = true
			end
		else
			if C["AutoQuestData"].IgnoreQuestNPC[npcID] then
				KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuestIgnoreNPC[npcID] = false
			else
				KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuestIgnoreNPC[npcID] = nil
			end
		end
	end

	UpdateIgnoreList()
end

QuestNpcNameFrame:HookScript("OnShow", UnitQuickQuestStatus)
QuestNpcNameFrame:HookScript("OnMouseDown", ToggleQuickQuestStatus)
local frame = GossipFrame.TitleContainer
if frame then
	frame:HookScript("OnShow", UnitQuickQuestStatus)
	frame:HookScript("OnMouseDown", ToggleQuickQuestStatus)
end
