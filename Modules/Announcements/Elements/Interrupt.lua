local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]
local Module = K:GetModule("Announcements")

local string_format = string.format

local AURA_TYPE_BUFF = AURA_TYPE_BUFF
local GetInstanceInfo = GetInstanceInfo
local GetSpellLink = GetSpellLink
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local IsArenaSkirmish = IsArenaSkirmish
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsPartyLFG = IsPartyLFG
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid

local infoType = {}

local spellBlackList = {
	[15752] = true, -- Linken's Boomerang Disarm
	[19647] = true, -- Spell Lock - Rank 2 (Warlock)
	[13491] = true, -- Iron Knuckles
	[16979] = true, -- Feral Charge (Druid)
	[2139] = true, -- Counterspell (Mage)
	[1766] = true, -- Kick (Rogue)
	[26679] = true, -- Deadly Throw
	[6552] = true, -- Pummel
	[22570] = true, -- Maim
	[29443] = true, -- Clutch of Foresight
	[47528] = true, -- Mind Freeze
	[57994] = true, -- Wind Shear
	[26090] = true, -- Pummel (Pet)
}

local function getAlertChannel()
	local inRaid = IsInRaid()
	local inPartyLFG = IsPartyLFG()

	local _, instanceType = GetInstanceInfo()
	if instanceType == "arena" then
		local isSkirmish = IsArenaSkirmish()
		local _, isRegistered = IsActiveBattlefieldArena()
		if isSkirmish or not isRegistered then
			inPartyLFG = true
		end
		inRaid = false -- IsInRaid() returns true for arenas and they should not be considered a raid
	end

	local alertChannel = C["Announcements"].AlertChannel.Value
	local channel = "EMOTE"
	if alertChannel == 1 then
		channel = inPartyLFG and "INSTANCE_CHAT" or "PARTY"
	elseif alertChannel == 2 then
		channel = inPartyLFG and "INSTANCE_CHAT" or (inRaid and "RAID" or "PARTY")
	elseif alertChannel == 3 and inRaid then
		channel = inPartyLFG and "INSTANCE_CHAT" or "RAID"
	elseif alertChannel == 4 and instanceType ~= "none" then
		channel = "SAY"
	elseif alertChannel == 5 and instanceType ~= "none" then
		channel = "YELL"
	end

	return channel
end

function Module:InterruptAlert_Toggle()
	infoType["SPELL_STOLEN"] = C["Announcements"].DispellAlert and L["Steal"]
	infoType["SPELL_DISPEL"] = C["Announcements"].DispellAlert and L["Dispel"]
	infoType["SPELL_INTERRUPT"] = C["Announcements"].InterruptAlert and L["Interrupt"]
	infoType["SPELL_AURA_BROKEN_SPELL"] = C["Announcements"].BrokenAlert and L["Broken Spell"]
end

function Module:InterruptAlert_IsEnabled()
	for _, value in pairs(infoType) do
		if value then return true end
	end
end

function Module:IsAllyPet(sourceFlags)
	if K.IsMyPet(sourceFlags) or sourceFlags == K.PartyPetFlags or sourceFlags == K.RaidPetFlags then
		return true
	else
		return false
	end
end

function Module:InterruptAlert_Update(...)
	local _, eventType, _, sourceGUID, sourceName, sourceFlags, _, _, destName, _, _, spellID, _, _, extraskillID, _, _, auraType = ...
	if not sourceGUID or sourceName == destName then return end

	local isPlayerOrAllyPet = sourceName == K.Name or Module:IsAllyPet(sourceFlags)

	if UnitInRaid(sourceName) or UnitInParty(sourceName) or Module:IsAllyPet(sourceFlags) then
		local infoText = infoType[eventType]
		if infoText then
			local sourceSpellID, destSpellID
			if infoText == L["Broken Spell"] then
				if auraType and auraType == AURA_TYPE_BUFF or spellBlackList[spellID] then return end
				sourceSpellID, destSpellID = extraskillID, spellID
			elseif infoText == L["Interrupt"] then
				if C["Announcements"].OwnInterrupt and not isPlayerOrAllyPet then return end
				sourceSpellID, destSpellID = spellID, extraskillID
			else
				if C["Announcements"].OwnDispell and not isPlayerOrAllyPet then return end
				sourceSpellID, destSpellID = spellID, extraskillID
			end

			if sourceSpellID and destSpellID then
				if infoText == L["Broken Spell"] then
					SendChatMessage(string_format(infoText, sourceName, GetSpellLink(destSpellID)), getAlertChannel())
				else
					SendChatMessage(string_format(infoText, GetSpellLink(destSpellID)), getAlertChannel())
				end
			end
		end
	end
end

function Module:InterruptAlert_CheckGroup()
	if IsInGroup() and (not C["Announcements"].InstAlertOnly or (IsInInstance() and not IsPartyLFG())) then
		K:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Module.InterruptAlert_Update)
	else
		K:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Module.InterruptAlert_Update)
	end
end

function Module:CreateInterruptAnnounce()
	Module:InterruptAlert_Toggle()

	if Module:InterruptAlert_IsEnabled() then
		Module:InterruptAlert_CheckGroup()
		K:RegisterEvent("GROUP_LEFT", Module.InterruptAlert_CheckGroup)
		K:RegisterEvent("GROUP_JOINED", Module.InterruptAlert_CheckGroup)
		K:RegisterEvent("PLAYER_ENTERING_WORLD", Module.InterruptAlert_CheckGroup)
	else
		K:UnregisterEvent("GROUP_LEFT", Module.InterruptAlert_CheckGroup)
		K:UnregisterEvent("GROUP_JOINED", Module.InterruptAlert_CheckGroup)
		K:UnregisterEvent("PLAYER_ENTERING_WORLD", Module.InterruptAlert_CheckGroup)
		K:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Module.InterruptAlert_Update)
	end
end
