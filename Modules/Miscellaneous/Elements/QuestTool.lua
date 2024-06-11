local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]
local Module = K:GetModule("Miscellaneous")
--[[
local pairs, strfind = pairs, strfind
local UnitGUID, GetItemCount = UnitGUID, GetItemCount
local GetActionInfo, GetSpellInfo, GetOverrideBarIndex = GetActionInfo, GetSpellInfo, GetOverrideBarIndex
local GetQuestLogIndexByID = GetQuestLogIndexByID
local SelectGossipOption, GetNumGossipOptions = SelectGossipOption, GetNumGossipOptions

local watchQuests = {
	-- check npc
	[60739] = true, -- https://www.wowhead.com/quest=60739/tough-crowd
	[62453] = true, -- https://www.wowhead.com/quest=62453/into-the-unknown
	-- glow
	[59585] = true, -- https://www.wowhead.com/quest=59585/well-make-an-aspirant-out-of-you
	[64271] = true, -- https://www.wowhead.com/quest=64271/a-more-civilized-way
}
local activeQuests = {}

local questNPCs = {
	[170080] = true, -- Boggart
	[174498] = true, -- Shimmersod
}

function Module:QuestTool_Init()
	for questID, value in pairs(watchQuests) do
		if GetQuestLogIndexByID(questID) then
			activeQuests[questID] = value
		end
	end
end

function Module:QuestTool_Accept(questID)
	if watchQuests[questID] then
		activeQuests[questID] = watchQuests[questID]
	end
end

function Module:QuestTool_Remove(questID)
	if watchQuests[questID] then
		activeQuests[questID] = nil
	end
end

local fixedStrings = {
	["Sweep"] = "Lunge",
	["Assault"] = "Assault",
}

local function isActionMatch(msg, text)
	return text and strfind(msg, text)
end

function Module:QuestTool_SetGlow(msg)
	if GetOverrideBarIndex() and (activeQuests[59585] or activeQuests[64271]) then
		for i = 1, 3 do
			local button = _G["ActionButton" .. i]
			local _, spellID = GetActionInfo(button.action)
			local name = spellID and GetSpellInfo(spellID)
			if fixedStrings[name] and isActionMatch(msg, fixedStrings[name]) or isActionMatch(msg, name) then
				K.LibCustomGlow.ButtonGlow_Start(button)
			else
				K.LibCustomGlow.ButtonGlow_Stop(button)
			end
		end
		Module.isGlowing = true
	else
		Module:QuestTool_ClearGlow()
	end
end

function Module:QuestTool_ClearGlow()
	if Module.isGlowing then
		Module.isGlowing = nil
		for i = 1, 3 do
			K.LibCustomGlow.ButtonGlow_Stop(_G["ActionButton" .. i])
		end
	end
end

function Module:QuestTool_SetQuestUnit()
	if not activeQuests[60739] and not activeQuests[62453] then
		return
	end

	local guid = UnitGUID("mouseover")
	local npcID = guid and K.GetNPCID(guid)
	if questNPCs[npcID] then
		self:AddLine(L["QuestTool NPCisTrue"])
	end
end

function Module:QuestTool()
	if not C["Misc"].QuestTool then
		return
	end

	local handler = CreateFrame("Frame", nil, UIParent)
	Module.QuestHandler = handler

	local text = K.CreateFontString(handler, 20)
	text:ClearAllPoints()
	text:SetPoint("TOP", UIParent, 0, -200)
	text:SetWidth(800)
	text:SetWordWrap(true)
	text:Hide()
	Module.QuestTip = text

	-- Check existing quests
	Module:QuestTool_Init()
	K:RegisterEvent("QUEST_ACCEPTED", function(_, questID) Module:QuestTool_Accept(questID) end)
	K:RegisterEvent("QUEST_REMOVED", function(_, questID) Module:QuestTool_Remove(questID) end)

	-- Override button quests
	if C["ActionBar"].Enable then
		K:RegisterEvent("CHAT_MSG_MONSTER_SAY", function(_, msg) Module:QuestTool_SetGlow(msg) end)
		K:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN", function() Module:QuestTool_ClearGlow() end)
	end

	-- Check npc in quests
	GameTooltip:HookScript("OnTooltipSetUnit", function() Module:QuestTool_SetQuestUnit() end)

	-- Auto gossip
	local firstStep
	K:RegisterEvent("GOSSIP_SHOW", function()
		local guid = UnitGUID("npc")
		local npcID = guid and K.GetNPCID(guid)
		if npcID == 174498 then
			SelectGossipOption(3)
		elseif npcID == 174371 then
			if GetItemCount(183961) == 0 then
				return
			end

			if GetNumGossipOptions() ~= 5 then
				return
			end

			if firstStep then
				SelectGossipOption(2)
			else
				SelectGossipOption(5)
				firstStep = true
			end
		end
	end)
end

Module:RegisterMisc("QuestTool", Module.QuestTool)]]
