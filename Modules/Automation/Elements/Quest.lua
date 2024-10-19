local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]

local GetTrackingInfo = C_Minimap.GetTrackingInfo
local GetNumTrackingTypes = C_Minimap.GetNumTrackingTypes

local isCheckButtonCreated
local function SetupAutoQuestCheckButton()
	if isCheckButtonCreated then return end

	local AutoQuestCheckButton = CreateFrame("CheckButton", nil, WorldMapFrame.BorderFrame, "OptionsCheckButtonTemplate")
	AutoQuestCheckButton:SetPoint("TOPRIGHT", -140, 0)
	AutoQuestCheckButton:SetSize(24, 24)

	AutoQuestCheckButton.text = AutoQuestCheckButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	AutoQuestCheckButton.text:SetPoint("LEFT", 24, 0)
	AutoQuestCheckButton.text:SetText(L["Auto Quest"])

	AutoQuestCheckButton:SetHitRectInsets(0, 0 - AutoQuestCheckButton.text:GetWidth(), 0, 0)
	AutoQuestCheckButton:SetChecked(KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest)
	AutoQuestCheckButton:SetScript("OnClick", function(self)
		KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest = self:GetChecked()
	end)

	isCheckButtonCreated = true

	function AutoQuestCheckButton.UpdateTooltip(self)
		if GameTooltip:IsForbidden() then return end
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
		if GameTooltip:IsForbidden() then return end
		self:UpdateTooltip()
	end)
	AutoQuestCheckButton:HookScript("OnLeave", function()
		if GameTooltip:IsForbidden() then return end
		GameTooltip:Hide()
	end)
	AutoQuestCheckButton:SetScript("OnClick", function(self)
		KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest = self:GetChecked()
	end)

	if Questie_Toggle then
		Questie_Toggle:ClearAllPoints()
		Questie_Toggle:SetHeight(22)
		Questie_Toggle:SetPoint("LEFT", WorldMapZoomOutButton, "RIGHT", 5, 0)
		Questie_Toggle.SetPoint = K.Noop
	end
end
WorldMapFrame:HookScript("OnShow", SetupAutoQuestCheckButton)

-- Function
local strmatch = string.match
local tonumber, next = tonumber, next
local IsAltKeyDown = IsAltKeyDown

local quests, choiceQueue = {}
local QuickQuest = CreateFrame("Frame")
QuickQuest:SetScript("OnEvent", function(self, event, ...) self[event](...) end)

function QuickQuest:Register(event, func)
	self:RegisterEvent(event)
	self[event] = function(...)
		if KkthnxUIDB.Variables[K.Realm][K.Name].AutoQuest == true and not IsShiftKeyDown() then
			func(...)
		end
	end
end

local function GetNPCID()
	return K.GetNPCID(UnitGUID("npc"))
end

local function IsTrackingHidden()
	for index = 1, GetNumTrackingTypes() do
		local name, _, active = GetTrackingInfo(index)
		if name == MINIMAP_TRACKING_TRIVIAL_QUESTS then
			return active
		end
	end
end

local ignoreQuestNPC = {}

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

local autoSelectFirstOptionList = {
	[97004] = true, -- "Red" Jack Findle
	[96782] = true, -- Lucian Trias
	[93188] = true, -- Mongar
}

local followerAssignees = {
	[138708] = true, -- 半兽人迦罗娜
	[135614] = true, -- 马迪亚斯·肖尔大师
}

local autoGossipTypes = {
	["taxi"] = true,
	["gossip"] = true,
	["banker"] = true,
	["vendor"] = true,
	["trainer"] = true,
}

local ignoreInstances = {
	[1571] = true, -- 枯法者
	[1626] = true, -- 群星庭院
}

QuickQuest:Register("GOSSIP_SHOW", function()
	local npcID = GetNPCID()
	if ignoreQuestNPC[npcID] then return end

	local active = C_GossipInfo.GetNumActiveQuests()
	if active > 0 then
		for index, questInfo in ipairs(C_GossipInfo.GetActiveQuests()) do
			local questID = questInfo.questID
			if questInfo.isComplete and questID then
				C_GossipInfo.SelectActiveQuest(questID)
			end
		end
	end

	local available = C_GossipInfo.GetNumAvailableQuests()
	if available > 0 then
		for index, questInfo in ipairs(C_GossipInfo.GetAvailableQuests()) do
			local trivial = questInfo.isTrivial
			if not trivial or IsTrackingHidden() or (trivial and npcID == 64337) then
				C_GossipInfo.SelectAvailableQuest(questInfo.questID)
			end
		end
	end

	local gossipInfoTable = C_GossipInfo.GetOptions()
	if not gossipInfoTable then return end

	local numOptions = #gossipInfoTable
	local firstOptionID = gossipInfoTable[1] and gossipInfoTable[1].gossipOptionID

	if firstOptionID then
		if autoSelectFirstOptionList[npcID] then
			return C_GossipInfo.SelectOption(firstOptionID)
		end

		if available == 0 and active == 0 and numOptions == 1 then
			local _, instance, _, _, _, _, _, mapID = GetInstanceInfo()
			if instance ~= "raid" and not ignoreGossipNPC[npcID] and not ignoreInstances[mapID] then
				return C_GossipInfo.SelectOption(firstOptionID)
			end
		end
	end
end)

QuickQuest:Register("QUEST_DETAIL", function()
	if not ignoreQuestNPC[npcID] then
		AcceptQuest()
	end
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

local itemBlacklist = {
	-- Inscription weapons
	[31690] = 79343, -- Inscribed Tiger Staff
	[31691] = 79340, -- Inscribed Crane Staff
	[31692] = 79341, -- Inscribed Serpent Staff

	-- Darkmoon Faire artifacts
	[29443] = 71635, -- Imbued Crystal
	[29444] = 71636, -- Monstrous Egg
	[29445] = 71637, -- Mysterious Grimoire
	[29446] = 71638, -- Ornate Weapon
	[29451] = 71715, -- A Treatise on Strategy
	[29456] = 71951, -- Banner of the Fallen
	[29457] = 71952, -- Captured Insignia
	[29458] = 71953, -- Fallen Adventurer's Journal
	[29464] = 71716, -- Soothsayer's Runes

	-- Tiller Gifts
	["progress_79264"] = 79264, -- Ruby Shard
	["progress_79265"] = 79265, -- Blue Feather
	["progress_79266"] = 79266, -- Jade Cat
	["progress_79267"] = 79267, -- Lovely Apple
	["progress_79268"] = 79268, -- Marsh Lily

	-- Garrison scouting missives
	["38180"] = 122424, -- Scouting Missive: Broken Precipice
	["38193"] = 122423, -- Scouting Missive: Broken Precipice
	["38182"] = 122418, -- Scouting Missive: Darktide Roost
	["38196"] = 122417, -- Scouting Missive: Darktide Roost
	["38179"] = 122400, -- Scouting Missive: Everbloom Wilds
	["38192"] = 122404, -- Scouting Missive: Everbloom Wilds
	["38194"] = 122420, -- Scouting Missive: Gorian Proving Grounds
	["38202"] = 122419, -- Scouting Missive: Gorian Proving Grounds
	["38178"] = 122402, -- Scouting Missive: Iron Siegeworks
	["38191"] = 122406, -- Scouting Missive: Iron Siegeworks
	["38184"] = 122413, -- Scouting Missive: Lost Veil Anzu
	["38198"] = 122414, -- Scouting Missive: Lost Veil Anzu
	["38177"] = 122403, -- Scouting Missive: Magnarok
	["38190"] = 122399, -- Scouting Missive: Magnarok
	["38181"] = 122421, -- Scouting Missive: Mok'gol Watchpost
	["38195"] = 122422, -- Scouting Missive: Mok'gol Watchpost
	["38185"] = 122411, -- Scouting Missive: Pillars of Fate
	["38199"] = 122409, -- Scouting Missive: Pillars of Fate
	["38187"] = 122412, -- Scouting Missive: Shattrath Harbor
	["38201"] = 122410, -- Scouting Missive: Shattrath Harbor
	["38186"] = 122408, -- Scouting Missive: Skettis
	["38200"] = 122407, -- Scouting Missive: Skettis
	["38183"] = 122416, -- Scouting Missive: Socrethar's Rise
	["38197"] = 122415, -- Scouting Missive: Socrethar's Rise
	["38176"] = 122405, -- Scouting Missive: Stonefury Cliffs
	["38189"] = 122401, -- Scouting Missive: Stonefury Cliffs

	-- Misc
	[31664] = 88604, -- Nat's Fishing Journal
}

QuickQuest:Register("QUEST_PROGRESS", function()
	if IsQuestCompletable() then
		local id, _, worldQuest = GetQuestTagInfo(GetQuestID())
		if id == 153 or worldQuest then	return end
		local npcID = GetNPCID()
		if ignoreQuestNPC[npcID] then return	end

		local requiredItems = GetNumQuestItems()
		if requiredItems > 0 then
			for index = 1, requiredItems do
				local link = GetQuestItemLink("required", index)
				if link then
					local id = tonumber(string.match(link, "item:(%d+)"))
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

local cashRewards = {
	[45724] = 1e5, -- Champion's Purse
	[64491] = 2e6, -- Royal Reward

	-- Items from the Sixtrigger brothers quest chain in Stormheim
	[138127] = 15, -- Mysterious Coin, 15 copper
	[138129] = 11, -- Swatch of Priceless Silk, 11 copper
	[138131] = 24, -- Magical Sprouting Beans, 24 copper
	[138123] = 15, -- Shiny Gold Nugget, 15 copper
	[138125] = 16, -- Crystal Clear Gemstone, 16 copper
	[138133] = 27, -- Elixir of Endless Wonder, 27 copper
}

QuickQuest:Register("QUEST_COMPLETE", function()
	-- Blingtron 6000 only!
	local npcID = GetNPCID()
	if npcID == 43929 or npcID == 77789 then return end

	local choices = GetNumQuestChoices()
	if choices <= 1 then
		GetQuestReward(1)
	elseif choices > 1 then
		local bestValue, bestIndex = 0
		for index = 1, choices do
			local link = GetQuestItemLink("choice", index)
			if link then
				local value = select(11, GetItemInfo(link))
				local itemID = GetItemInfoFromHyperlink(link)
				value = cashRewards[itemID] or value

				if(value > bestValue) then
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
	K.Delay(1, AttemptAutoComplete)

	if event == "PLAYER_REGEN_ENABLED" then
		QuickQuest:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end
QuickQuest:Register("PLAYER_LOGIN", AttemptAutoComplete)
QuickQuest:Register("QUEST_AUTOCOMPLETE", AttemptAutoComplete)
