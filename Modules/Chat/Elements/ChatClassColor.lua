local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Chat")

local GuidCache = {}
local ClassNames = {}

local chatEvents = {
	"CHAT_MSG_BATTLEGROUND",
	"CHAT_MSG_BATTLEGROUND_LEADER",
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
	"CHAT_MSG_LOOT",
	"CHAT_MSG_CURRENCY",
}

local isCalling = false
function Module:GetPlayerInfoByGUID(guid)
	if isCalling then return end

	local data = GuidCache[guid]
	if not data then
		isCalling = true
		local ok, localizedClass, englishClass, localizedRace, englishRace, sex, name, realm = pcall(GetPlayerInfoByGUID, guid)
		isCalling = false

		if not (ok and englishClass) then return end

		if realm == "" then realm = nil end
		local nameWithRealm
		if name and name ~= "" then
			nameWithRealm = (realm and name.."-"..realm) or name.."-"..K.Realm
		end

		data = {
			localizedClass = localizedClass,
			englishClass = englishClass,
			localizedRace = localizedRace,
			englishRace = englishRace,
			sex = sex,
			name = name,
			realm = realm,
			nameWithRealm = nameWithRealm,
		}

		if name then
			ClassNames[strlower(name)] = englishClass
		end
		if nameWithRealm then
			ClassNames[strlower(nameWithRealm)] = englishClass
		end

		GuidCache[guid] = data
	end

	return data
end

function Module:ClassFilter(message)
	local isFirstWord, rebuiltString

	for word in gmatch(message, "%s-%S+%s*") do
		local tempWord = gsub(word,"^[%s%p]-([^%s%p]+)([%-]?[^%s%p]-)[%s%p]*$","%1%2")
		local lowerCaseWord = strlower(tempWord)

		local classMatch = ClassNames[lowerCaseWord]
		local wordMatch = classMatch and lowerCaseWord

		if wordMatch then
			local r, g, b = K.ColorClass(classMatch)
			word = gsub(word, gsub(tempWord, "%-","%%-"), format("\124cff%.2x%.2x%.2x%s\124r", r*255, g*255, b*255, tempWord))
		end

		if not isFirstWord then
			rebuiltString = word
			isFirstWord = true
		else
			rebuiltString = format("%s%s", rebuiltString, word)
		end
	end

	return rebuiltString
end

function Module:UpdateChatColor(event, msg, ...)
	msg = Module:ClassFilter(msg) or msg
	return false, msg, ...
end

function Module:CreateChatClassColor()
	if not C["Chat"].ChatClassColor then return end

	for _, event in pairs(chatEvents) do
		ChatFrame_AddMessageEventFilter(event, Module.UpdateChatColor)
	end

	hooksecurefunc("GetPlayerInfoByGUID",function(...) 
		Module:GetPlayerInfoByGUID(...)
	end)
end