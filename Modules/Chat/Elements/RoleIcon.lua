local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Chat")

-- Check if a unit has a role assigned
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

-- Chat message types to add role icons to
local ChatMSG = {
	CHAT_MSG_INSTANCE_CHAT = true,
	CHAT_MSG_INSTANCE_CHAT_LEADER = true,
	CHAT_MSG_PARTY = true,
	CHAT_MSG_PARTY_LEADER = true,
	CHAT_MSG_RAID = true,
	CHAT_MSG_RAID_LEADER = true,
	CHAT_MSG_RAID_WARNING = true,
	CHAT_MSG_SAY = true,
	CHAT_MSG_WHISPER = true,
	CHAT_MSG_WHISPER_INFORM = true,
	CHAT_MSG_YELL = true,
}

-- Role icon textures
local IconTex = {
	TANK = "\124T"..[[Interface\AddOns\KkthnxUI\Media\Chat\Roles\Tank.tga]]..":12:12:0:0:64:64:5:59:5:59\124t",
	HEALER	= "\124T"..[[Interface\AddOns\KkthnxUI\Media\Chat\Roles\Healer.tga]]..":12:12:0:0:64:64:5:59:5:59\124t",
	DAMAGER = "\124T"..[[Interface\AddOns\KkthnxUI\Media\Chat\Roles\Damager.tga]]..":12:12:0:0:64:64:5:59:5:59\124t",
}

-- Get colored name with role icon
local GetColoredName = _G.GetColoredName
local function GetChatRoleIcons(event, arg1, arg2, ...)
	local ret = GetColoredName(event, arg1, arg2, ...)
	if ChatMSG[event] then
		local playerRole = UnitGroupRolesAssigned(arg2)
		if playerRole == "NONE" and arg2:match(" *- *".. K.Realm .."$") then
			playerRole = UnitGroupRolesAssigned(arg2:gsub(" *-[^-]+$",""))
		end
		if playerRole and playerRole ~= "NONE" then
			ret = IconTex[playerRole]..""..ret
		end
	end
	return ret
end

-- Create chat role icons
function Module:CreateChatRoleIcon()
	if not C["Chat"].RoleIcons then return	end

	_G.GetColoredName = GetChatRoleIcons
end
