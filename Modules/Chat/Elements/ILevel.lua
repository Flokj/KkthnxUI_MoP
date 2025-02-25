local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Chat")

local pairs = pairs
local string_format = string.format
local string_gsub = string.gsub
local string_match = string.match
local string_rep = string.rep

local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local GetItemInfo = GetItemInfo
local GetItemStats = GetItemStats

local itemCache = {}

local socketWatchList = {
	["BLUE"] = true,
	["RED"] = true,
	["YELLOW"] = true,
	["COGWHEEL"] = true,
	["HYDRAULIC"] = true,
	["META"] = true,
	["PRISMATIC"] = true,
}

local function isItemHasLevel(link)
	local name, _, rarity, level, _, _, _, _, _, _, _, classID = GetItemInfo(link)
	if name and level and rarity > 1 and (classID == LE_ITEM_CLASS_WEAPON or classID == LE_ITEM_CLASS_ARMOR) then
		return name, level
	end
end

local function GetSocketTexture(socket, count)
	return string_rep("|TInterface\\ItemSocketingFrame\\UI-EmptySocket-" .. socket .. ":0|t", count)
end

function Module.IsItemHasGem(link)
	local text = ""
	local stats = GetItemStats(link)
	for stat, count in pairs(stats) do
		local socket = string_match(stat, "EMPTY_SOCKET_(%S+)")
		if socket and socketWatchList[socket] then
			text = text .. GetSocketTexture(socket, count)
		end
	end
	return text
end

local function convertItemLevel(link)
	if itemCache[link] then
		return itemCache[link]
	end

	local itemLink = string_match(link, "|Hitem:.-|h")
	if itemLink then
		local name, itemLevel = isItemHasLevel(itemLink)
		local gems = Module.IsItemHasGem(itemLink)
		if name and itemLevel then
			if C["Chat"].ChatItemLevel and C["Chat"].ChatItemGem then
				link = gsub(link, "|h%[(.-)%]|h", "|h[" .. name .. "(" .. itemLevel .. ")]|h" .. gems)
			elseif C["Chat"].ChatItemLevel then
				link = gsub(link, "|h%[(.-)%]|h", "|h[" .. name .. "(" .. itemLevel .. ")]|h")
			elseif C["Chat"].ChatItemGem then
				link = gsub(link, "|h%[(.-)%]|h", "|h[" .. name .. "]|h" .. gems)
			end
			itemCache[link] = link
		end
	end
	return link
end

function Module:UpdateChatItemLevel(_, msg, ...)
	msg = string_gsub(msg, "(|Hitem:%d+:.-|h.-|h)", convertItemLevel)
	return false, msg, ...
end

function Module:CreateChatItemLevels()
	if C["Chat"].ChatItemLevel or C["Chat"].ChatItemGem then
		local filters = {
			"CHAT_MSG_LOOT", "CHAT_MSG_CHANNEL", "CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_WHISPER", 
			"CHAT_MSG_WHISPER_INFORM", "CHAT_MSG_BN_WHISPER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", 
			"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_GUILD", "CHAT_MSG_BATTLEGROUND", 
			"CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER"
		}
		for _, event in pairs(filters) do
			ChatFrame_AddMessageEventFilter(event, self.UpdateChatItemLevel)
		end
	end
end
