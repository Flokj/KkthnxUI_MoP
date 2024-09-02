local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Announcements")

local debugMode = false
local completedQuest, initComplete = {}
local strmatch, strfind, gsub, format = string.match, string.find, string.gsub, string.format
local mod, tonumber, pairs, floor = mod, tonumber, pairs, math.floor
local soundKitID = SOUNDKIT.ALARM_CLOCK_WARNING_3
local QUEST_COMPLETE, LE_QUEST_FREQUENCY_DAILY = QUEST_COMPLETE, LE_QUEST_FREQUENCY_DAILY

-- Get the text for the quest acceptance message
local function acceptText(link, daily)
	-- If the quest is a daily quest, format the message with "Accepted" and "Daily"
	if daily then
		return format("%s [%s]%s", "Accepted", DAILY, link)
	-- If the quest is not a daily quest, format the message with "Accepted"
	else
		return format("%s %s", "Accepted", link)
	end
end

-- Get the text for the quest completion message
local function completeText(link)
	-- Play a sound
	PlaySound(soundKitID, "Master")
	-- Format the message with "Completed" and the quest title
	return format("%s (%s)", link, QUEST_COMPLETE)
end

-- Send message to the appropriate channel
local function sendQuestMsg(msg)
	-- If OnlyCompleteRing is true, return
	if C["Announcements"].OnlyCompleteRing then return end

	-- If debug mode is enabled, print the message in the chat
	-- If the player is in a LFG party, send the message to the instance chat
	-- If the player is in a raid, send the message to the raid chat
	-- If the player is in a group, send the message to the party chat
	if debugMode and K.isDeveloper then
		print(msg)
	elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		SendChatMessage(msg, "INSTANCE_CHAT")
	elseif IsInRaid() then
		SendChatMessage(msg, "RAID")
	elseif IsInGroup() then
		SendChatMessage(msg, "PARTY")
	end
end

-- Get the pattern for a given quest match
local function getPattern(pattern)
	-- Escape any special characters in the pattern
	pattern = gsub(pattern, "%(", "%%%1")
	pattern = gsub(pattern, "%)", "%%%1")
	-- Replace any wildcard characters with capture groups
	pattern = gsub(pattern, "%%%d?$?.", "(.+)")
	-- Format the pattern to match the entire string
	return format("^%s$", pattern)
end

-- Table of quest match patterns
local questMatches = {
	["Found"] = getPattern(ERR_QUEST_ADD_FOUND_SII),
	["Item"] = getPattern(ERR_QUEST_ADD_ITEM_SII),
	["Kill"] = getPattern(ERR_QUEST_ADD_KILL_SII),
	["PKill"] = getPattern(ERR_QUEST_ADD_PLAYER_KILL_SII),
	["ObjectiveComplete"] = getPattern(ERR_QUEST_OBJECTIVE_COMPLETE_S),
	["QuestComplete"] = getPattern(ERR_QUEST_COMPLETE_S),
	["QuestFailed"] = getPattern(ERR_QUEST_FAILED_S),
}

function Module:FindQuestProgress(_, msg)
	-- Check if the option to announce quest progress is disabled, if so, exit the function
	if not C["Announcements"].QuestProgress then return end

	-- Check if the option to only announce quest progress when the ring is complete is enabled, if so, exit the function
	if C["Announcements"].OnlyCompleteRing then return end

	-- Iterate through the patterns in the `questMatches` table
	for _, pattern in pairs(questMatches) do
		-- Check if the message matches any of the patterns
		if strmatch(msg, pattern) then
			-- Get the current and max values from the message
			local _, _, _, cur, max = strfind(msg, "(.*)[:]%s*([-%d]+)%s*/%s*([-%d]+)%s*$")
			-- Convert the values to numbers
			cur, max = tonumber(cur), tonumber(max)
			if cur and max and max >= 10 then
				-- Check if the progress is a multiple of the max value divided by 5
				if mod(cur, math_floor(max / 5)) == 0 then
					-- Send the message using `sendQuestMsg` function
					sendQuestMsg(msg)
				end
			else
				-- Send the message using `sendQuestMsg` function
				sendQuestMsg(msg)
			end
			break
		end
	end
end

function Module:FindQuestAccept(questLogIndex)
	local name, _, _, _, _, _, frequency = GetQuestLogTitle(questLogIndex)
	if name then
		sendQuestMsg(acceptText(name, frequency == LE_QUEST_FREQUENCY_DAILY))
	end
end

function Module:FindQuestComplete()
	-- Loop through all quests in player's quest log
	for i = 1, GetNumQuestLogEntries() do
		-- Get the quest ID for the current log index
		local name, _, _, _, _, isComplete, _, questID = GetQuestLogTitle(i)
		-- Check if the quest is not a world quest and it is not marked as completed before
		if name and isComplete and not completedQuest[questID] then
			-- Check if this function has been called before
			if initComplete then
				-- Send the message using `sendQuestMsg` function with the quest ID as parameter
				sendQuestMsg(completeText(name))
			end
			-- Mark the quest as completed
			completedQuest[questID] = true
		end
	end
	-- Set the `initComplete` variable to true
	initComplete = true
end

function Module:CreateQuestNotifier()
	if C["Announcements"].QuestNotifier and not K.CheckAddOnState("QuestNotifier") then
		K:RegisterEvent("QUEST_ACCEPTED", Module.FindQuestAccept)
		K:RegisterEvent("QUEST_LOG_UPDATE", Module.FindQuestComplete)
		K:RegisterEvent("UI_INFO_MESSAGE", Module.FindQuestProgress)
	else
		wipe(completedQuest)
		K:UnregisterEvent("QUEST_ACCEPTED", Module.FindQuestAccept)
		K:UnregisterEvent("QUEST_LOG_UPDATE", Module.FindQuestComplete)
		K:UnregisterEvent("UI_INFO_MESSAGE", Module.FindQuestProgress)
	end
end
