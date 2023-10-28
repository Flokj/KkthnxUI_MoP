local K, C, L = unpack(KkthnxUI)

local _G = _G
local table_wipe = _G.table.wipe
local string_match = _G.string.match

local AcceptQuest = _G.AcceptQuest
local CloseQuest = _G.CloseQuest
local CompleteQuest = _G.CompleteQuest
local GameTooltip = _G.GameTooltip
local GetActiveTitle = _G.GetActiveTitle
local GetGossipActiveQuests = _G.GetGossipActiveQuests
local GetGossipAvailableQuests = _G.GetGossipAvailableQuests
local GetGossipOptions = _G.GetGossipOptions
local GetInstanceInfo = _G.GetInstanceInfo
local GetItemInfo = _G.GetItemInfo
local GetNumActiveQuests = _G.GetNumActiveQuests
local GetNumAvailableQuests = _G.GetNumAvailableQuests
local GetNumGossipActiveQuests = _G.GetNumGossipActiveQuests
local GetNumGossipAvailableQuests = _G.GetNumGossipAvailableQuests
local GetNumGossipOptions = _G.GetNumGossipOptions
local GetNumQuestChoices = _G.GetNumQuestChoices
local GetNumQuestItems = _G.GetNumQuestItems
local GetNumQuestLogEntries = _G.GetNumQuestLogEntries
local GetQuestID = _G.GetQuestID
local GetQuestItemInfo = _G.GetQuestItemInfo
local GetQuestItemLink = _G.GetQuestItemLink
local GetQuestLogTitle = _G.GetQuestLogTitle
local GetQuestReward = _G.GetQuestReward
local GetQuestTagInfo = _G.GetQuestTagInfo
local IsQuestCompletable = _G.IsQuestCompletable
local IsShiftKeyDown = _G.IsShiftKeyDown
local SelectActiveQuest = _G.SelectActiveQuest
local SelectAvailableQuest = _G.SelectAvailableQuest
local SelectGossipActiveQuest = _G.SelectGossipActiveQuest
local SelectGossipAvailableQuest = _G.SelectGossipAvailableQuest
local SelectGossipOption = _G.SelectGossipOption
local StaticPopup_Hide = _G.StaticPopup_Hide
local UnitGUID = _G.UnitGUID

local quests, choiceQueue = {}
local QuickQuest = CreateFrame("Frame")
QuickQuest:SetScript("OnEvent", function(self, event, ...)
	self[event](...)
end)

function QuickQuest:Register(event, func)
	self:RegisterEvent(event)
	self[event] = function(...)
		if KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest == true and not IsShiftKeyDown() then
			func(...)
		end
	end
end

local isCheckButtonCreated
local function SetupAutoQuestCheckButton()
	if isCheckButtonCreated then
		return
	end

	local AutoQuestCheckButton = CreateFrame("CheckButton", nil, WorldMapFrame, "OptionsCheckButtonTemplate")
	AutoQuestCheckButton:SetPoint("BOTTOMLEFT", 25, 90)
	AutoQuestCheckButton:SetSize(16, 16)

	AutoQuestCheckButton.text = AutoQuestCheckButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	AutoQuestCheckButton.text:SetPoint("LEFT", 24, 0)
	AutoQuestCheckButton.text:SetText(L["Auto Quest"])

	AutoQuestCheckButton:SetHitRectInsets(0, 0 - AutoQuestCheckButton.text:GetWidth(), 0, 0)
	AutoQuestCheckButton:SetChecked(KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest)
	AutoQuestCheckButton:SetScript("OnClick", function(self)
		KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest = self:GetChecked()
	end)

	AutoQuestCheckButton:SkinCheckBox()
	AutoQuestCheckButton:SetFrameLevel(WorldMapFrameCloseButton:GetFrameLevel())

	isCheckButtonCreated = true

	function AutoQuestCheckButton.UpdateTooltip(self)
		if GameTooltip:IsForbidden() then
			return
		end

		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 10)

		local r, g, b = 0.2, 1.0, 0.2

		if KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest == true then
			GameTooltip:AddLine(L["Auto Quest Enabled"])
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["Auto Quest Enabled Desc"], r, g, b)
		else
			GameTooltip:AddLine(L["Auto Quest Disabled"])
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["Auto Quest Disabled Desc"], r, g, b)
		end

		GameTooltip:Show()
	end

	AutoQuestCheckButton:HookScript("OnEnter", function(self)
		if GameTooltip:IsForbidden() then
			return
		end

		self:UpdateTooltip()
	end)

	AutoQuestCheckButton:HookScript("OnLeave", function()
		if GameTooltip:IsForbidden() then
			return
		end

		GameTooltip:Hide()
	end)

	AutoQuestCheckButton:SetScript("OnClick", function(self)
		KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest = self:GetChecked()
	end)
end
WorldMapFrame:HookScript("OnShow", SetupAutoQuestCheckButton)

local function GetNPCID()
	return K.GetNPCID(UnitGUID("npc"))
end

local ignoreQuestNPC = {
	[88570] = true,		-- Fate-Twister Tiklal
	[87391] = true,		-- Fate-Twister Seress
	[111243] = true,	-- Archmage Lan'dalock
	[108868] = true,	-- Hunter's order hall
	[101462] = true,	-- Reaves
	[43929] = true,		-- 4000
	[14847] = true,		-- DarkMoon
	[119388] = true,	-- 酋长哈顿
	[114719] = true,	-- 商人塞林
	[121263] = true,	-- 大技师罗姆尔
	[126954] = true,	-- 图拉扬
	[124312] = true,	-- 图拉扬
	[103792] = true,	-- 格里伏塔
	[101880] = true,	-- 泰克泰克
	[141584] = true,	-- 祖尔温
	[142063] = true,	-- 特兹兰
	[143388] = true,	-- 德鲁扎
	[98489] = true,		-- 海难俘虏
	[135690] = true,	-- 亡灵舰长
	[105387] = true,	-- 安杜斯
	[93538] = true,		-- 达瑞妮斯
	[154534] = true,	-- 大杂院阿畅
	[150987] = true,	-- 肖恩·维克斯，斯坦索姆
	[150563] = true,	-- 斯卡基特，麦卡贡订单日常
	[143555] = true,	-- 山德·希尔伯曼，祖达萨PVP军需官
}

local function GetQuestLogQuests(onlyComplete)
	table_wipe(quests)

	for index = 1, GetNumQuestLogEntries() do
		local title, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(index)
		if not isHeader then
			if onlyComplete and isComplete or not onlyComplete then
				quests[title] = questID
			end
		end
	end

	return quests
end

QuickQuest:Register("QUEST_GREETING", function()
	local npcID = GetNPCID()
	if ignoreQuestNPC[npcID] then return end

	local active = GetNumActiveQuests()
	if active > 0 then
		local logQuests = GetQuestLogQuests(true)
		for index = 1, active do
			local name, complete = GetActiveTitle(index)
			if complete then
				local questID = logQuests[name]
				if not questID then
					SelectActiveQuest(index)
				else
					local _, _, worldQuest = GetQuestTagInfo(questID)
					if not worldQuest then
						SelectActiveQuest(index)
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
				SelectAvailableQuest(index)
			end
		end
	end
end)

-- This should be part of the API, really
local function GetAvailableGossipQuestInfo(index)
	local name, level, isTrivial, frequency, isRepeatable, isLegendary, isIgnored = select(((index * 7) - 7) + 1, GetGossipAvailableQuests())
	return name, level, isTrivial, isIgnored, isRepeatable, frequency == 2, frequency == 3, isLegendary
end

local function GetActiveGossipQuestInfo(index)
	local name, level, isTrivial, isComplete, isLegendary, isIgnored = select(((index * 6) - 6) + 1, GetGossipActiveQuests())
	return name, level, isTrivial, isIgnored, isComplete, isLegendary
end

local ignoreGossipNPC = {
	-- Bodyguards
	[86945] = true, -- Aeda Brightdawn (Horde)
	[86933] = true, -- Vivianne (Horde)
	[86927] = true, -- Delvar Ironfist (Alliance)
	[86934] = true, -- Defender Illona (Alliance)
	[86682] = true, -- Tormmok
	[86964] = true, -- Leorajh
	[86946] = true, -- Talonpriest Ishaal

	-- Sassy Imps
	[95139] = true,
	[95141] = true,
	[95142] = true,
	[95143] = true,
	[95144] = true,
	[95145] = true,
	[95146] = true,
	[95200] = true,
	[95201] = true,

	-- Misc NPCs
	[79740] = true, -- Warmaster Zog (Horde)
	[79953] = true, -- Lieutenant Thorn (Alliance)
	[84268] = true, -- Lieutenant Thorn (Alliance)
	[84511] = true, -- Lieutenant Thorn (Alliance)
	[84684] = true, -- Lieutenant Thorn (Alliance)
	[117871] = true, -- War Councilor Victoria (Class Challenges @ Broken Shore)
	[155101] = true, -- 元素精华融合器
	[155261] = true, -- 肖恩·维克斯，斯坦索姆
	[150122] = true, -- 荣耀堡法师
	[150131] = true, -- 萨尔玛法师
}

local autoGossipTypes = {
	["taxi"] = true,
	["gossip"] = true,
	["banker"] = true,
	["vendor"] = true,
	["trainer"] = true,
}

QuickQuest:Register("GOSSIP_SHOW", function()
	local npcID = GetNPCID()
	if ignoreQuestNPC[npcID] then return end

	local active = GetNumGossipActiveQuests()
	if active > 0 then
		local logQuests = GetQuestLogQuests(true)
		for index = 1, active do
			local name, _, _, _, complete = GetActiveGossipQuestInfo(index)
			if complete then
				local questID = logQuests[name]
				if not questID then
					SelectGossipActiveQuest(index)
				else
					local _, _, worldQuest = GetQuestTagInfo(questID)
					if not worldQuest then
						SelectGossipActiveQuest(index)
					end
				end
			end
		end
	end

	local available = GetNumGossipAvailableQuests()
	if available > 0 then
		for index = 1, available do
			local _, _, trivial, ignored = GetAvailableGossipQuestInfo(index)
			if not trivial and not ignored then
				SelectGossipAvailableQuest(index)
			end
		end
	end

	if available == 0 and active == 0 then
		if GetNumGossipOptions() == 1 then
			local _, instance = GetInstanceInfo()
			if instance ~= "raid" and not ignoreGossipNPC[npcID] then
				local _, type = GetGossipOptions()
				if autoGossipTypes[type] then
					SelectGossipOption(1)
					return
				end
			end
		end
	end
end)

local darkmoonNPC = {}

QuickQuest:Register("GOSSIP_CONFIRM", function(index)
	local npcID = GetNPCID()
	if npcID and darkmoonNPC[npcID] then
		SelectGossipOption(index, "", true)
		StaticPopup_Hide("GOSSIP_CONFIRM")
	end
end)

QuickQuest:Register("QUEST_DETAIL", function()
	AcceptQuest()
end)

QuickQuest:Register("QUEST_ACCEPT_CONFIRM", AcceptQuest)

QuickQuest:Register("QUEST_ACCEPTED", function()
	if QuestFrame:IsShown() then
		CloseQuest()
	end
end)

QuickQuest:Register("QUEST_ITEM_UPDATE", function()
	if choiceQueue and QuickQuest[choiceQueue] then
		QuickQuest[choiceQueue]()
	end
end)

local itemBlacklist = {}

local ignoreProgressNPC = {}

QuickQuest:Register("QUEST_PROGRESS", function()
	if IsQuestCompletable() then
		local id, _, worldQuest = GetQuestTagInfo(GetQuestID())
		if id == 153 or worldQuest then
			return
		end

		local npcID = GetNPCID()
		if ignoreProgressNPC[npcID] then
			return
		end

		local requiredItems = GetNumQuestItems()
		if requiredItems > 0 then
			for index = 1, requiredItems do
				local link = GetQuestItemLink("required", index)
				if link then
					local id = tonumber(string_match(link, "item:(%d+)"))
					for _, itemID in next, itemBlacklist do
						if itemID == id then
							return
						end
					end
				else
					choiceQueue = "QUEST_PROGRESS"
					return
				end
			end
		end
		CompleteQuest()
	end
end)

local cashRewards = {}

QuickQuest:Register("QUEST_COMPLETE", function()
	local choices = GetNumQuestChoices()
	if choices <= 1 then
		GetQuestReward(1)
	elseif choices > 1 then
		local bestValue, bestIndex = 0
		for index = 1, choices do
			local link = GetQuestItemLink("choice", index)
			if link then
				local _, _, _, _, _, _, _, _, _, _, value = GetItemInfo(link)
				value = cashRewards[tonumber(string_match(link, "item:(%d+):"))] or value

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

local function AttemptAutoComplete(event)
	C_Timer.After(1, AttemptAutoComplete)

	if event == "PLAYER_REGEN_ENABLED" then
		QuickQuest:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end
QuickQuest:Register("PLAYER_LOGIN", AttemptAutoComplete)
QuickQuest:Register("QUEST_AUTOCOMPLETE", AttemptAutoComplete)
