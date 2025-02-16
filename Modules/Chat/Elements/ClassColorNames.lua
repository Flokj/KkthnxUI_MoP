local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Chat")

-- Упрощение вызовов функций строк
local gsub = string.gsub

-- Список событий чата
local chatEvents = {
    "CHAT_MSG_BN_WHISPER",
    "CHAT_MSG_BN_WHISPER_INFORM",
    "CHAT_MSG_CHANNEL",
    "CHAT_MSG_GUILD",
    "CHAT_MSG_INSTANCE_CHAT",
    "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_OFFICER",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID",
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_SAY",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_WHISPER_INFORM",
    "CHAT_MSG_YELL",
    "CHAT_MSG_SYSTEM",
}

-- Функция окрашивания имени игрока в цвет его класса
local function ColorizeName(name)
    if not name or name == "" then return name end
    local _, class = UnitClass(name)
    if class and RAID_CLASS_COLORS[class] then
        return string.format("|c%s%s|r", RAID_CLASS_COLORS[class].colorStr, name)
    end
    return name
end

-- Функция обработки чата
local function OnChatMessage(self, event, msg, author, ...)
    -- Окрашивание имени отправителя
    local coloredAuthor = ColorizeName(author)

    -- Окрашивание имен в самом тексте сообщения
    msg = gsub(msg, "([%a%dА-Яа-яЁё]+)", function(word)
        return ColorizeName(word) or word
    end)

    return false, msg, coloredAuthor, ...
end

-- Функция подключения фильтра сообщений
function Module:EnableClassColorNames()
	if not C["Chat"].ClassColorNames then return	end
	
    for _, event in ipairs(chatEvents) do
        ChatFrame_AddMessageEventFilter(event, OnChatMessage)
    end
end