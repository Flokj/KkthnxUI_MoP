local K, C, L = unpack(KkthnxUI)
local Module = K:GetModule("Chat")

local string_find, string_gsub = string.find, string.gsub
local BetterDate = BetterDate
local INTERFACE_ACTION_BLOCKED = INTERFACE_ACTION_BLOCKED
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime

local timestampFormat = {
	[2] = "[%I:%M %p] ",
	[3] = "[%I:%M:%S %p] ",
	[4] = "[%H:%M] ",
	[5] = "[%H:%M:%S] ",
}

local IsDeveloper = K.isDeveloper
local WhisperColorEnabled = C["Chat"].WhisperColor
local TimestampFormat = C["Chat"].TimestampFormat.Value

local function GetCurrentTime()
	local locTime = time()
	local realmTime = not GetCVarBool("timeMgrUseLocalTime") and C_DateAndTime_GetCurrentCalendarTime()

	if realmTime then
		realmTime.day, realmTime.min, realmTime.sec = realmTime.monthDay, realmTime.minute, date("%S")
		realmTime = time(realmTime)
	end

	return locTime, realmTime
end

function Module:SetupChannelNames(text, ...)
	if string_find(text, INTERFACE_ACTION_BLOCKED) and not IsDeveloper then return end

	local r, g, b = ...
	if WhisperColorEnabled and string_find(text, L["To"] .. " |H[BN]*player.+%]") then
		r, g, b = r * 0.7, g * 0.7, b * 0.7
	end

	if TimestampFormat > 1 then
		local locTime, realmTime = GetCurrentTime()
		local defaultTimestamp = GetCVar("showTimestamps")

		if defaultTimestamp == "none" then
			defaultTimestamp = nil
		end

		local oldTimeStamp = defaultTimestamp and gsub(BetterDate(defaultTimestamp, locTime), "%[([^]]*)%]", "%%[%1%%]")
		if oldTimeStamp then
			text = gsub(text, oldTimeStamp, "")
		end

		local timeStamp = BetterDate(K.GreyColor .. timestampFormat[TimestampFormat] .. "|r", realmTime or locTime)
		text = timeStamp .. text
	end

	if C["Chat"].OldChatNames then
		return self.oldAddMessage(self, text, r, g, b)
	else
		return self.oldAddMessage(self, string_gsub(text, "|h%[(%d+)%..-%]|h", "|h[%1]|h"), r, g, b)
	end
end

local function renameChatFrames()
	for i = 1, _G.NUM_CHAT_WINDOWS do
		if i ~= 2 then
			local chatFrame = _G["ChatFrame" .. i]
			chatFrame.oldAddMessage = chatFrame.AddMessage
			chatFrame.AddMessage = Module.SetupChannelNames
		end
	end
end

local function renameChatStrings()
	for i = 1, _G.NUM_CHAT_WINDOWS do
		if i ~= 2 then
			local chatFrame = _G["ChatFrame" .. i]
			chatFrame.oldAddMsg = chatFrame.AddMessage
			chatFrame.AddMessage = Module.SetupChannelNames
		end
	end

	-- Online/Offline
	_G.ERR_FRIEND_ONLINE_SS = string_gsub(_G.ERR_FRIEND_ONLINE_SS, "%]%|h", "]|h|cff00c957")
	_G.ERR_FRIEND_OFFLINE_S = string_gsub(_G.ERR_FRIEND_OFFLINE_S, "%%s", "%%s|cffff7f50")

	_G.BN_INLINE_TOAST_FRIEND_OFFLINE = "|TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61|t%s has gone |cffff0000offline|r."
	_G.BN_INLINE_TOAST_FRIEND_ONLINE = "|TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61|t%s has come |cff00ff00online|r."


	-- Whisper
	_G.CHAT_WHISPER_INFORM_GET = L["To"] .. " %s "
	_G.CHAT_WHISPER_GET = L["From"] .. " %s "
	_G.CHAT_BN_WHISPER_INFORM_GET = L["To"] .. " %s "
	_G.CHAT_BN_WHISPER_GET = L["From"] .. " %s "

	-- Say/Yell
	_G.CHAT_SAY_GET = "%s "
	_G.CHAT_YELL_GET = "%s "

	-- Loot mods
	_G.LOOT_ITEM = "%s + %s"
	_G.LOOT_ITEM_MULTIPLE = "%s + % sx%d"
	_G.LOOT_ITEM_CREATED_SELF = "+ %s"
	_G.LOOT_ITEM_CREATED_SELF_MULTIPLE = "+ %sx%d"
	_G.LOOT_ITEM_SELF = "+ %s"
	_G.LOOT_ITEM_SELF_MULTIPLE = "+ %sx%d"
	_G.LOOT_ITEM_PUSHED_SELF = "+ %s"
	_G.LOOT_ITEM_PUSHED_SELF_MULTIPLE = "+ %sx%d"
	_G.CREATED_ITEM = "%s + %s"
	_G.CREATED_ITEM_MULTIPLE = "%s + % sx%d"
	_G.LOOT_MONEY = "%s|cff00a956+|r |cffffffff%s"
	_G.YOU_LOOT_MONEY = "|cff00a956+|r |cffffffff%s"
	_G.LOOT_MONEY_SPLIT = "|cff00a956+|r |cffffffff%s"
	_G.CURRENCY_GAINED = "|cff00a956+|r |cffffffff%s"
	_G.CURRENCY_GAINED_MULTIPLE = "|cff00a956+|r |cffffffff%s %d"
	_G.LOOT_ROLL_ALL_PASSED = "|HlootHistory:%d|h[L]|h All passed on: %s"
	_G.LOOT_ROLL_PASSED_AUTO = "|HlootHistory:%d|h[L]|h %s passed %s, auto."
	_G.LOOT_ROLL_PASSED_SELF_AUTO = "|HlootHistory:%d|h[L]|h pass \"%s\", (auto)"
	_G.LOOT_ROLL_WON = "|HlootHistory:%d|h[L]|h %s wins %s"
	_G.LOOT_ROLL_YOU_WON = "|HlootHistory:%d|h[L]|h You won %s"
	_G.LOOT_ROLL_WON_NO_SPAM_NEED = "|HlootHistory:%d|h[L]|h %s wins %s |cff818181(\"Need\" – %d)|r"
	_G.LOOT_ROLL_WON_NO_SPAM_GREED = "|HlootHistory:%d|h[L]|h %s wins %s |cff818181(\"Greed\" – %d)|r"
	_G.LOOT_ROLL_YOU_WON_NO_SPAM_NEED = "|HlootHistory:%d|h[L]|h You won %s |cff818181(\"Need\" – %d)|r"
	_G.LOOT_ROLL_YOU_WON_NO_SPAM_GREED = "|HlootHistory:%d|h[L]|h You won %s |cff818181(\"Greed\" – %d)|r"

	_G.COPPER_AMOUNT = "%d|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t"
	_G.SILVER_AMOUNT = "%d|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t"
	_G.GOLD_AMOUNT = "%d|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t"

	-- Chat mods
	_G.ACHIEVEMENT_BROADCAST = "%s achieved \"%s\"!"
	_G.CHAT_YOU_CHANGED_NOTICE = "|Hchannel:%d|h[%s]|h"
	_G.ERR_SKILL_UP_SI = "|3-6(%s) |cff1eff00%d|r"
	_G.FACTION_STANDING_DECREASED = "|3-7(%s) -%d"
	_G.FACTION_STANDING_INCREASED = "|3-7(%s) +%d"

	-- Chat colours
	_G.NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
	_G.TRIVIAL_QUEST_DISPLAY = "|cffffffff%s (low level)|r"

	-- Misc
	_G.ERR_AUCTION_SOLD_S = "|cff1eff00\"%s\"|r |cffffffffsold.|r"

	if C["Chat"].OldChatNames then return end

	-- Guild
	_G.CHAT_GUILD_GET = "|Hchannel:GUILD|h[G]|h %s "
	_G.CHAT_OFFICER_GET = "|Hchannel:OFFICER|h[O]|h %s "

	-- Raid
	_G.CHAT_RAID_GET = "|Hchannel:RAID|h[R]|h %s "
	_G.CHAT_RAID_WARNING_GET = "[RW] %s "
	_G.CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h[RL]|h %s "

	-- Party
	_G.CHAT_PARTY_GET = "|Hchannel:PARTY|h[P]|h %s "
	_G.CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|h[PL]|h %s "
	_G.CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|h[PG]|h %s "

	-- Instance
	_G.CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE|h[I]|h %s "
	_G.CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE|h[IL]|h %s "

	-- Flags
	_G.CHAT_FLAG_AFK = "[AFK] "
	_G.CHAT_FLAG_DND = "[DND] "
	_G.CHAT_FLAG_GM = "[GM] "
end

function Module:CreateChatRename()
	renameChatFrames()
	renameChatStrings()
end