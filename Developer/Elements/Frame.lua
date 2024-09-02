local K, C = KkthnxUI[1], KkthnxUI[2]

local math_ceil = math.ceil
local math_floor = math.floor
local print = print
local string_find = string.find
local string_format = string.format
local string_split = string.split
local table_wipe = table.wipe
local tostring = tostring

local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage
local DESCRIPTION = DESCRIPTION
local EJ_GetCurrentTier = EJ_GetCurrentTier
local EJ_GetEncounterInfoByIndex = EJ_GetEncounterInfoByIndex
local EJ_GetInstanceInfo = EJ_GetInstanceInfo
local EJ_SelectInstance = EJ_SelectInstance
local EnumerateFrames = EnumerateFrames
local GetInstanceInfo = GetInstanceInfo
local GetScreenHeight = GetScreenHeight
local GetScreenWidth = GetScreenWidth
local GetSpellDescription = GetSpellDescription
local GetSpellInfo = GetSpellInfo
local GetSpellTexture = GetSpellTexture
local IsInGuild = IsInGuild
local IsInRaid = IsInRaid
local MouseIsOver = MouseIsOver
local NAME = NAME
local SlashCmdList = SlashCmdList
local UNKNOWN = UNKNOWN
local UnitGUID = UnitGUID
local UnitName = UnitName

-- KkthnxUI DevTools:
-- /getenc, get selected encounters info
-- /getid, get instance id
-- /getnpc, get npc name and id
-- /kf, get frame names
-- /kg, show grid on WorldFrame
-- /ks, get spell name and description
-- /kt, get gametooltip names

-- Commands
SlashCmdList["KKTHNXUI_ENUMTIP"] = function()
	local enumf = EnumerateFrames()
	while enumf do
		-- stylua: ignore
		if (enumf:GetObjectType() == "GameTooltip" or string_find((enumf:GetName() or ""):lower(), "tip")) and enumf:IsVisible() and enumf:GetPoint() then
			print(enumf:GetName())
		end

		enumf = EnumerateFrames(enumf)
	end
end
_G.SLASH_KKTHNXUI_ENUMTIP1 = "/gettip"
_G.SLASH_KKTHNXUI_ENUMTIP2 = "/gettooltip"

SlashCmdList["KKTHNXUI_ENUMFRAME"] = function()
	local frame = EnumerateFrames()
	local chatModule = K:GetModule("Chat")
	while frame do
		if frame:IsVisible() and MouseIsOver(frame) then
			print(frame:GetName() or string_format(UNKNOWN .. ": [%s]", tostring(frame)))
			chatModule:ChatCopy_OnClick("LeftButton")
		end

		frame = EnumerateFrames(frame)
	end
end
_G.SLASH_KKTHNXUI_ENUMFRAME1 = "/getframe"

SlashCmdList["KKTHNXUI_DUMPSPELL"] = function(arg)
	local name, _, icon, _, _, _, spellID = GetSpellInfo(arg)
	if not name then
		print("Please enter a spell ID --> /getspell ID")
		return
	end

	local link = GetSpellLink(spellID)
	print(K.InfoColor .. "------------------------")
	print(" |T" .. GetSpellTexture(spellID) .. ":16:16:::64:64:5:59:5:59|t", K.InfoColor .. (link or "nil"))
	print(K.InfoColor .. "------------------------")
end
_G.SLASH_KKTHNXUI_DUMPSPELL1 = "/getspell"

SlashCmdList["INSTANCEID"] = function()
	local name, _, _, _, _, _, _, id = GetInstanceInfo()
	print(name, id)
end
_G.SLASH_INSTANCEID1 = "/getinstance"

SlashCmdList["KKTHNXUI_NPCID"] = function()
	local name = UnitName("target")
	local guid = UnitGUID("target")
	if name and guid then
		local npcID = K.GetNPCID(guid)
		print(name, K.InfoColor .. (npcID or "nil"))
	end
end
_G.SLASH_KKTHNXUI_NPCID1 = "/getnpc"

SlashCmdList["KKTHNXUI_GETFONT"] = function(msg)
	local font = _G[msg]
	if not font then
		print(msg, "not found.")
		return
	end

	local a, b, c = font:GetFont()
	print(msg, a, b, c)
end
_G.SLASH_KKTHNXUI_GETFONT1 = "/getfont"

do
	local versionList = {}
	C_ChatInfo_RegisterAddonMessagePrefix("KKUI_VersonCheck")

	local function PrintVerCheck()
		print("------------------------")
		for name, version in pairs(versionList) do
			print(name .. " " .. version)
		end
	end

	local function SendVerCheck(channel)
		table_wipe(versionList)
		C_ChatInfo_SendAddonMessage("KKUI_VersonCheck", "VersionCheck", channel)
		C_Timer.After(3, PrintVerCheck)
	end

	local function VerCheckListen(_, ...)
		local prefix, msg, distType, sender = ...

		if prefix == "KKUI_VersonCheck" then
			if msg == "VersionCheck" then
				C_ChatInfo_SendAddonMessage("KKUI_VersonCheck", "MyVer-" .. K.Version, distType)
			elseif string_find(msg, "MyVer") then
				local _, version = string_split("-", msg)
				versionList[sender] = version .. " - " .. distType
			end
		end
	end
	K:RegisterEvent("CHAT_MSG_ADDON", VerCheckListen)

	SlashCmdList["KKTHNXUI_VER_CHECK"] = function(msg)
		local channel
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			channel = "INSTANCE_CHAT"
		elseif IsInRaid() then
			channel = "RAID"
		elseif IsInGuild() and not IsInGroup() then
			channel = "GUILD"
		elseif IsInGroup() then
			channel = "PARTY"
		end

		if msg ~= "" then
			channel = msg
		end

		if channel then
			SendVerCheck(channel)
		end
	end

	_G.SLASH_KKTHNXUI_VER_CHECK1 = "/kkver"
end

SlashCmdList["KKTHNXUI_GET_ENCOUNTERS"] = function()
	if not _G.EncounterJournal then
		return
	end

	local tierID = EJ_GetCurrentTier()
	local instID = EncounterJournal.instanceID
	EJ_SelectInstance(instID)
	local instName = EJ_GetInstanceInfo()
	print(" ")
	print("TIER = " .. tierID)
	print("INSTANCE = " .. instID .. " -- " .. instName)
	print("BOSS")
	print(" ")

	local i = 0
	while true do
		i = i + 1
		local name, _, boss = EJ_GetEncounterInfoByIndex(i)
		if not name then
			return
		end

		print("BOSS = " .. boss .. " -- " .. name)
	end
end
_G.SLASH_KKTHNXUI_GET_ENCOUNTERS1 = "/getencounter"

-- Inform us of the patch info we play on.
SlashCmdList["WOWVERSION"] = function()
	print(K.InfoColor .. "------------------------")
	K.Print("Build: ", K.WowBuild)
	K.Print("Released: ", K.WowRelease)
	K.Print("Interface: ", K.TocVersion)
	print(K.InfoColor .. "------------------------")
end
_G.SLASH_WOWVERSION1 = "/getpatch"
_G.SLASH_WOWVERSION2 = "/getbuild"
_G.SLASH_WOWVERSION3 = "/getinterface"

-- Grids
local grid
local boxSize = 32
local function Grid_Create()
	grid = CreateFrame("Frame", nil, UIParent)
	grid.boxSize = boxSize
	grid:SetAllPoints(UIParent)

	local size = 2
	local width = GetScreenWidth()
	local ratio = width / GetScreenHeight()
	local height = GetScreenHeight() * ratio

	local wStep = width / boxSize
	local hStep = height / boxSize

	for i = 0, boxSize do
		local tx = grid:CreateTexture(nil, "BACKGROUND")
		if i == boxSize / 2 then
			tx:SetColorTexture(1, 0, 0, 0.5)
		else
			tx:SetColorTexture(0, 0, 0, 0.5)
		end
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", i * wStep - (size / 2), 0)
		tx:SetPoint("BOTTOMRIGHT", grid, "BOTTOMLEFT", i * wStep + (size / 2), 0)
	end
	height = GetScreenHeight()

	do
		local tx = grid:CreateTexture(nil, "BACKGROUND")
		tx:SetColorTexture(1, 0, 0, 0.5)
		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height / 2) + (size / 2))
		tx:SetPoint("BOTTOMRIGHT", grid, "TOPRIGHT", 0, -(height / 2 + size / 2))
	end

	for i = 1, math_floor((height / 2) / hStep) do
		local tx = grid:CreateTexture(nil, "BACKGROUND")
		tx:SetColorTexture(0, 0, 0, 0.5)

		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height / 2 + i * hStep) + (size / 2))
		tx:SetPoint("BOTTOMRIGHT", grid, "TOPRIGHT", 0, -(height / 2 + i * hStep + size / 2))

		tx = grid:CreateTexture(nil, "BACKGROUND")
		tx:SetColorTexture(0, 0, 0, 0.5)

		tx:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -(height / 2 - i * hStep) + (size / 2))
		tx:SetPoint("BOTTOMRIGHT", grid, "TOPRIGHT", 0, -(height / 2 - i * hStep + size / 2))
	end
end

local function Grid_Show()
	if not grid then
		Grid_Create()
	elseif grid.boxSize ~= boxSize then
		grid:Hide()
		Grid_Create()
	else
		grid:Show()
	end
end

local isAligning = false
SlashCmdList["KKUI_TOGGLEGRID"] = function(arg)
	if isAligning or arg == "1" then
		if grid then
			grid:Hide()
		end
		isAligning = false
	else
		boxSize = (math_ceil((tonumber(arg) or boxSize) / 32) * 32)
		if boxSize > 256 then
			boxSize = 256
		end
		Grid_Show()
		isAligning = true
	end
end
_G.SLASH_KKUI_TOGGLEGRID1 = "/showgrid"
_G.SLASH_KKUI_TOGGLEGRID2 = "/align"
_G.SLASH_KKUI_TOGGLEGRID3 = "/grid"

-- Test UnitFrames (ShestakUI)
local moving = false
SlashCmdList.TEST_UF = function()
	if InCombatLockdown() then
		print("|cffffff00" .. ERR_NOT_IN_COMBAT .. "|r")
		return
	end

	if not moving then
		for _, frames in pairs({ "oUF_Target", "oUF_TargetTarget", "oUF_Pet", "oUF_Focus", "oUF_FocusTarget" }) do
			if _G[frames] then
				_G[frames].oldunit = _G[frames].unit
				_G[frames]:SetAttribute("unit", "player")
			end
		end

		if C["Arena"].Enable then
			for i = 1, 5 do
				_G["oUF_Arena" .. i].oldunit = _G["oUF_Arena" .. i].unit
				_G["oUF_Arena" .. i].Trinket.Hide = K.Noop
				_G["oUF_Arena" .. i].Trinket.Icon:SetTexture("Interface\\Icons\\INV_Jewelry_Necklace_37")
				_G["oUF_Arena" .. i]:SetAttribute("unit", "player")
			end
		end

		if C["Boss"].Enable then
			for i = 1, MAX_BOSS_FRAMES do
				_G["oUF_Boss" .. i].oldunit = _G["oUF_Boss" .. i].unit
				_G["oUF_Boss" .. i]:SetAttribute("unit", "player")
			end
		end
		moving = true
	else
		for _, frames in pairs({ "oUF_Target", "oUF_TargetTarget", "oUF_Pet", "oUF_Focus", "oUF_FocusTarget" }) do
			if _G[frames] then
				_G[frames].unit = _G[frames].oldunit
				_G[frames]:SetAttribute("unit", _G[frames].unit)
			end
		end

		if C["Arena"].Enable then
			for i = 1, 5 do
				_G["oUF_Arena" .. i].Trinket.Hide = nil
				_G["oUF_Arena" .. i].unit = _G["oUF_Arena" .. i].oldunit
				_G["oUF_Arena" .. i]:SetAttribute("unit", _G["oUF_Arena" .. i].unit)
			end
		end

		if C["Boss"].Enable then
			for i = 1, MAX_BOSS_FRAMES do
				_G["oUF_Boss" .. i].unit = _G["oUF_Boss" .. i].oldunit
				_G["oUF_Boss" .. i]:SetAttribute("unit", _G["oUF_Boss" .. i].unit)
			end
		end
		moving = false
	end
end
SLASH_TEST_UF1 = "/testui"
