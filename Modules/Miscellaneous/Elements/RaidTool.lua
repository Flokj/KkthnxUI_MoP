local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]
local Module = K:GetModule("Miscellaneous")

local next, pairs, mod, select = next, pairs, mod, select

local IsInGroup, IsInRaid, IsInInstance = IsInGroup, IsInRaid, IsInInstance
local UnitIsGroupLeader, UnitIsGroupAssistant = UnitIsGroupLeader, UnitIsGroupAssistant
local IsPartyLFG, IsLFGComplete = IsPartyLFG, IsLFGComplete
local GetInstanceInfo, GetNumGroupMembers, GetRaidRosterInfo, GetRaidTargetIndex, SetRaidTarget = GetInstanceInfo, GetNumGroupMembers, GetRaidRosterInfo, GetRaidTargetIndex, SetRaidTarget
local GetTime, SendChatMessage = GetTime, SendChatMessage
local IsAltKeyDown, IsControlKeyDown, IsShiftKeyDown, InCombatLockdown = IsAltKeyDown, IsControlKeyDown, IsShiftKeyDown, InCombatLockdown
local UnitExists, UninviteUnit = UnitExists, UninviteUnit
local DoReadyCheck, GetReadyCheckStatus = DoReadyCheck, GetReadyCheckStatus
local LeaveParty = LeaveParty
local ConvertToRaid = ConvertToRaid
local ConvertToParty = ConvertToParty

function Module:RaidTool_Visibility(frame)
	if IsInGroup() then
		frame:Show()
	else
		frame:Hide()
	end
end

function Module:RaidTool_Header()
	local frame = CreateFrame("Button", nil, UIParent)
	frame:SetSize(120, 28)
	frame:SetFrameLevel(2)
	frame:SkinButton()
	K.Mover(frame, "Raid Tool", "RaidManager", { "TOP", UIParent, "TOP", 0, -4 })

	-- Fake icon
	local left = CreateFrame("Button", nil, frame)
	left:SetPoint("LEFT", frame, "RIGHT", 6, 0)
	left:SetSize(28, 28)
	left:SkinButton()
	local leftString = K.CreateFontString(left, 14, GetNumGroupMembers(), "", true)

	-- Add tooltip
	left:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine("Group Members", 0.6, 0.8, 1)
		GameTooltip:AddDoubleLine("Current Count:", K.InfoColor .. GetNumGroupMembers())
		if IsInGroup() then
			local tank = UnitGroupRolesAssigned("player") == "TANK"
			local healer = UnitGroupRolesAssigned("player") == "HEALER"
			local dps = UnitGroupRolesAssigned("player") == "DAMAGER"
			local role = (tank and "|A:UI-LFG-RoleIcon-Tank-Micro-GroupFinder:16:16|a" or healer and "|A:UI-LFG-RoleIcon-Healer-Micro-GroupFinder:16:16|a" or dps and "|A:UI-LFG-RoleIcon-DPS-Micro-GroupFinder:16:16|a") or "None"

			GameTooltip:AddDoubleLine("Role:", K.InfoColor .. role)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Actions:", 0.6, 0.8, 1)
			GameTooltip:AddDoubleLine(K.LeftButton .. "Role Check", K.InfoColor .. "Initiate a role check")
		else
			GameTooltip:AddLine("You are not in a group.", 1, 0, 0)
		end

		-- Special Easter Egg for Swiver
		if K.Name == "Swiver" then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("No more spamming |cffFF7D0ASwiver|r!", 0.9, 0.1, 0.1)
		end

		GameTooltip:Show()
	end)
	left:SetScript("OnLeave", K.HideTooltip)

	left:SetScript("OnClick", function(self, btn)
		if btn == "LeftButton" then
			if IsInGroup() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
				InitiateRolePoll()
			else
				UIErrorsFrame:AddMessage("You must be the group leader or assistant to initiate a role check.", 1, 0, 0)
			end
		end
	end)

	Module.RaidTool_Visibility(Module, frame)
	K:RegisterEvent("GROUP_ROSTER_UPDATE", function()
		Module.RaidTool_Visibility(Module, frame)
		leftString:SetText(GetNumGroupMembers())
	end)

	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnClick", function(self, btn)
		if btn == "LeftButton" then
			local menu = self.menu
			K.TogglePanel(menu)

			if menu:IsShown() then
				menu:ClearAllPoints()
				if Module:IsFrameOnTop(self) then
					menu:SetPoint("TOP", self, "BOTTOM", 0, -6)
				else
					menu:SetPoint("BOTTOM", self, "TOP", 0, 6)
				end

				self.buttons[2].text:SetText(IsInRaid() and CONVERT_TO_PARTY or CONVERT_TO_RAID)
			end
		end
	end)

	-- Right-Click to Leave Party on Double-Click
	frame:SetScript("OnDoubleClick", function(_, btn)
		if btn == "RightButton" and (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsLFGComplete() or not IsInInstance()) then
			LeaveParty()
		end
	end)

	return frame
end

function Module:IsFrameOnTop(frame)
	local y = select(2, frame:GetCenter())
	local screenHeight = UIParent:GetTop()
	return y > screenHeight / 2
end

function Module:GetRaidMaxGroup()
	local _, instType, difficulty = GetInstanceInfo()
	if (instType == "party" or instType == "scenario") and not IsInRaid() then
		return 1
	elseif instType ~= "raid" then
		return 8
	elseif difficulty == 8 or difficulty == 1 or difficulty == 2 or difficulty == 24 then
		return 1
	elseif difficulty == 14 or difficulty == 15 then
		return 6
	elseif difficulty == 16 then
		return 4
	elseif difficulty == 3 or difficulty == 5 then
		return 2
	elseif difficulty == 9 then
		return 8
	else
		return 5
	end
end

function Module:RaidTool_RoleCount(parent)
	local roleIndex = { "TANK", "HEALER", "DAMAGER" }

	local frame = CreateFrame("Frame", nil, parent)
	frame:SetAllPoints()
	local role = {}
	for i = 1, 3 do
		role[i] = frame:CreateTexture(nil, "OVERLAY")
		role[i]:SetPoint("LEFT", 36 * i - 27, 0)
		role[i]:SetSize(18, 18)
		K.ReskinSmallRole(role[i], roleIndex[i])
		role[i].text = K.CreateFontString(frame, 13, "0", "")
		role[i].text:ClearAllPoints()
		role[i].text:SetPoint("CENTER", role[i], "RIGHT", 8, 0)
	end

	local raidCounts = {
		totalTANK = 0,
		totalHEALER = 0,
		totalDAMAGER = 0,
	}

	local function updateRoleCount()
		for k in pairs(raidCounts) do
			raidCounts[k] = 0
		end

		local maxgroup = Module:GetRaidMaxGroup()
		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup, _, _, _, _, online, isDead, _, _, assignedRole = GetRaidRosterInfo(i)
			if name and online and subgroup <= maxgroup and not isDead and assignedRole ~= "NONE" then
				raidCounts["total" .. assignedRole] = raidCounts["total" .. assignedRole] + 1
			end
		end

		role[1].text:SetText(raidCounts.totalTANK)
		role[2].text:SetText(raidCounts.totalHEALER)
		role[3].text:SetText(raidCounts.totalDAMAGER)
	end

	local eventList = {
		"GROUP_ROSTER_UPDATE",
		"UPDATE_ACTIVE_BATTLEFIELD",
		"UNIT_FLAGS",
		"PLAYER_FLAGS_CHANGED",
		"PLAYER_ENTERING_WORLD",
	}
	for _, event in next, eventList do
		K:RegisterEvent(event, updateRoleCount)
	end

	parent.roleFrame = frame
end

function Module:RaidTool_UpdateRes(elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.1 then
		local charges, _, started, duration = GetSpellCharges(20484)
		if charges then
			local timer = duration - (GetTime() - started)
			if timer < 0 then
				self.Timer:SetText("--:--")
			else
				self.Timer:SetFormattedText("%d:%.2d", timer / 60, timer % 60)
			end
			self.Count:SetText(charges)
			if charges == 0 then
				self.Count:SetTextColor(1, 0, 0)
			else
				self.Count:SetTextColor(0, 1, 0)
			end
			self.__owner.resFrame:SetAlpha(1)
			self.__owner.roleFrame:SetAlpha(0)
		else
			self.__owner.resFrame:SetAlpha(0)
			self.__owner.roleFrame:SetAlpha(1)
		end

		self.elapsed = 0
	end
end

function Module:RaidTool_CombatRes(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetAllPoints()
	frame:SetAlpha(0)
	local res = CreateFrame("Frame", nil, frame)
	res:SetSize(22, 22)
	res:SetPoint("LEFT", 5, 0)

	res.Icon = res:CreateTexture(nil, "ARTWORK")
	res.Icon:SetTexture(GetSpellTexture(20484))
	res.Icon:SetAllPoints()
	res.Icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])
	res.__owner = parent

	res.Count = K.CreateFontString(res, 16, "0", "")
	res.Count:ClearAllPoints()
	res.Count:SetPoint("LEFT", res, "RIGHT", 10, 0)
	res.Timer = K.CreateFontString(frame, 16, "00:00", "", false, "RIGHT", -5, 0)
	res:SetScript("OnUpdate", Module.RaidTool_UpdateRes)

	parent.resFrame = frame
end

function Module:RaidTool_ReadyCheck(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetPoint("TOP", parent, "BOTTOM", 0, -6)
	frame:SetSize(120, 50)
	frame:Hide()
	frame:SetScript("OnMouseUp", function(self)
		self:Hide()
	end)
	frame:CreateBorder()
	K.CreateFontString(frame, 14, READY_CHECK, "", true, "TOP", 0, -8)
	local rc = K.CreateFontString(frame, 14, "", "", false, "TOP", 0, -28)

	local count, total
	local function hideRCFrame()
		frame:Hide()
		rc:SetText("")
		count, total = 0, 0
	end

	local function updateReadyCheck(event)
		if event == "READY_CHECK_FINISHED" then
			if count == total then
				rc:SetTextColor(0, 1, 0)
			else
				rc:SetTextColor(1, 0, 0)
			end
			K.Delay(5, hideRCFrame)
		else
			count, total = 0, 0

			frame:ClearAllPoints()
			if Module:IsFrameOnTop(parent) then
				frame:SetPoint("TOP", parent, "BOTTOM", 0, -6)
			else
				frame:SetPoint("BOTTOM", parent, "TOP", 0, 6)
			end
			frame:Show()

			local maxgroup = Module:GetRaidMaxGroup()
			for i = 1, GetNumGroupMembers() do
				local name, _, subgroup, _, _, _, _, online = GetRaidRosterInfo(i)
				if name and online and subgroup <= maxgroup then
					total = total + 1
					local status = GetReadyCheckStatus(name)
					if status and status == "ready" then
						count = count + 1
					end
				end
			end
			rc:SetText(count .. " / " .. total)
			if count == total then
				rc:SetTextColor(0, 1, 0)
			else
				rc:SetTextColor(1, 1, 0)
			end
		end
	end
	K:RegisterEvent("READY_CHECK", updateReadyCheck)
	K:RegisterEvent("READY_CHECK_CONFIRM", updateReadyCheck)
	K:RegisterEvent("READY_CHECK_FINISHED", updateReadyCheck)
end

function Module:RaidTool_BuffChecker(parent)
	local frame = CreateFrame("Button", nil, parent)
	frame:SetPoint("RIGHT", parent, "LEFT", -6, 0)
	frame:SetSize(28, 28)
	frame:SkinButton()

	local icon = frame:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("TOPLEFT", frame, 6, -6)
	icon:SetPoint("BOTTOMRIGHT", frame, -6, 6)
	icon:SetAtlas("common-icon-checkmark-yellow")

	frame:HookScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine("Raid Tool", 0.6, 0.8, 1)
		GameTooltip:AddLine("Manage your raid with useful tools.", 1, 1, 1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Actions:", 0.6, 0.8, 1)
		GameTooltip:AddDoubleLine(K.LeftButton .. " Ready Check", K.InfoColor .. "Initiate a ready check")
		GameTooltip:AddDoubleLine(K.RightButton .. " Countdown", K.InfoColor .. "Start a countdown timer")

		GameTooltip:Show()
	end)
	frame:HookScript("OnLeave", K.HideTooltip)

	local reset = true
	K:RegisterEvent("PLAYER_REGEN_ENABLED", function()
		reset = true
	end)

	frame:HookScript("OnMouseDown", function(_, btn)
		if btn == "LeftButton" then
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage(K.InfoColor .. ERR_NOT_IN_COMBAT)
				return
			end
			if IsInGroup() and (UnitIsGroupLeader("player") or (UnitIsGroupAssistant("player") and IsInRaid())) then
				DoReadyCheck()
			else
				UIErrorsFrame:AddMessage(K.InfoColor .. ERR_NOT_LEADER)
			end
		elseif btn == "RightButton" then
			if IsInGroup() and (UnitIsGroupLeader("player") or (UnitIsGroupAssistant("player") and IsInRaid())) then
				if C_AddOns.IsAddOnLoaded("DBM-Core") then
					if reset then
						SlashCmdList["DEADLYBOSSMODS"]("pull " .. C["Misc"].DBMCount)
					else
						SlashCmdList["DEADLYBOSSMODS"]("pull 0")
					end
					reset = not reset
				elseif C_AddOns.IsAddOnLoaded("BigWigs") then
					if not SlashCmdList["BIGWIGSPULL"] then
						LoadAddOn("BigWigs_Plugins")
					end
					if reset then
						SlashCmdList["BIGWIGSPULL"](C["Misc"].DBMCount)
					else
						SlashCmdList["BIGWIGSPULL"]("0")
					end
					reset = not reset
				elseif K:GetModule("Announcements") and K:GetModule("Announcements").StartPull then
					K:GetModule("Announcements").StartPull(5) -- Start a 5-second pull timer
				else
					UIErrorsFrame:AddMessage(K.InfoColor .. "You need DBM or BigWigs to use this feature.")
				end
			else
				UIErrorsFrame:AddMessage(K.InfoColor .. ERR_NOT_LEADER)
			end
		end
	end)
end

function Module:RaidTool_CreateMenu(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetPoint("TOP", parent, "BOTTOM", 0, -6)
	frame:SetSize(132, 70)
	frame:CreateBorder()
	frame:Hide()

	local function updateDelay(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed > 0.1 then
			if not frame:IsMouseOver() then
				self:Hide()
				self:SetScript("OnUpdate", nil)
			end

			self.elapsed = 0
		end
	end

	frame:SetScript("OnLeave", function(self)
		self:SetScript("OnUpdate", updateDelay)
	end)

	StaticPopupDialogs["Group_Disband"] = {
		text = L["Raid Disbanding"],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage(K.InfoColor .. ERR_NOT_IN_COMBAT)
				return
			end
			if IsInRaid() then
				SendChatMessage(L["Raid Disbanding Info"], "RAID")
				for i = 1, GetNumGroupMembers() do
					local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
					if online and name ~= K.Name then
						UninviteUnit(name)
					end
				end
			else
				for i = MAX_PARTY_MEMBERS, 1, -1 do
					if UnitExists("party" .. i) then
						UninviteUnit(UnitName("party" .. i))
					end
				end
			end
			LeaveParty()
		end,
		timeout = 0,
		whileDead = 1,
	}

	local buttons = {
		{
			TEAM_DISBAND,
			function()
				if UnitIsGroupLeader("player") then
					StaticPopup_Show("Group_Disband")
				else
					UIErrorsFrame:AddMessage(K.InfoColor .. ERR_NOT_LEADER)
				end
			end,
		},
		{
			CONVERT_TO_RAID,
			function()
				if UnitIsGroupLeader("player") and GetNumGroupMembers() <= 5 then
					if IsInRaid() then
						ConvertToParty()
					else
						ConvertToRaid()
					end
					frame:Hide()
					frame:SetScript("OnUpdate", nil)
				else
					UIErrorsFrame:AddMessage(K.InfoColor .. ERR_NOT_LEADER)
				end
			end,
		},
	}

	local bu = {}
	for i, j in pairs(buttons) do
		bu[i] = CreateFrame("Button", nil, frame)
		bu[i]:SetSize(120, 26)
		bu[i]:SkinButton()
		bu[i].text = K.CreateFontString(bu[i], 12, j[1], "", true)
		
		if i == 1 then
		    bu[i]:SetPoint("TOP", frame, "TOP", 0, -6)
		else
		    bu[i]:SetPoint("TOP", bu[i-1], "BOTTOM", 0, -6)
		end

		bu[i]:SetScript("OnClick", j[2])
	end

	parent.menu = frame
	parent.buttons = bu
end

local iconTexture = {
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8",
	"Interface\\Buttons\\UI-GroupLoot-Pass-Up",
}
local maxButtons = #iconTexture

function Module:RaidTool_EasyMarker()
	if not C["Misc"].EasyMarking then return end
	local menuList = {}

	local function GetMenuTitle(text, ...)
		return (... and K.RGBToHex(...) or "") .. text
	end

	local function SetRaidTargetByIndex(_, arg1)
		SetRaidTarget("target", arg1)
	end

	local mixins = {
		UnitPopupRaidTarget8ButtonMixin,
		UnitPopupRaidTarget7ButtonMixin,
		UnitPopupRaidTarget6ButtonMixin,
		UnitPopupRaidTarget5ButtonMixin,
		UnitPopupRaidTarget4ButtonMixin,
		UnitPopupRaidTarget3ButtonMixin,
		UnitPopupRaidTarget2ButtonMixin,
		UnitPopupRaidTarget1ButtonMixin,
		UnitPopupRaidTargetNoneButtonMixin,
	}
	for index, mixin in pairs(mixins) do
		local t1, t2, t3, t4 = mixin:GetTextureCoords()
		menuList[index] = {
			text = GetMenuTitle(mixin:GetText(), mixin:GetColor()),
			icon = mixin:GetIcon(),
			tCoordLeft = t1,
			tCoordRight = t2,
			tCoordTop = t3,
			tCoordBottom = t4,
			arg1 = 9 - index,
			func = SetRaidTargetByIndex,
		}
	end

	local function GetModifiedState()
		local index = C["Misc"].EasyMarkKey.Value
		if index == 1 then
			return IsControlKeyDown()
		elseif index == 2 then
			return IsAltKeyDown()
		elseif index == 3 then
			return IsShiftKeyDown()
		elseif index == 4 then
			return false
		end
	end

	WorldFrame:HookScript("OnMouseDown", function(_, btn)
		if btn == "LeftButton" and GetModifiedState() and UnitExists("mouseover") then
			if not IsInGroup() or (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
				local index = GetRaidTargetIndex("mouseover")
				for i = 1, 8 do
					local menu = menuList[i]
					if menu.arg1 == index then
						menu.checked = true
					else
						menu.checked = false
					end
				end
				K.LibEasyMenu.Create(menuList, K.EasyMenu, "cursor", 0, 0, "MENU", 1)
			end
		end
	end)
end

function Module:RaidTool_WorldMarker()
	local frame = CreateFrame("Frame", "KKUI_WorldMarkers", UIParent)
	frame:SetPoint("RIGHT", -100, 0)
	K.CreateMoverFrame(frame, nil, true)
	K.RestoreMoverFrame(frame)
	frame:CreateBorder()
	frame.buttons = {}

	for i = 1, maxButtons do
		local button = CreateFrame("Button", nil, frame, "SecureActionButtonTemplate")
		button:SetSize(24, 24)
		button.Icon = button:CreateTexture(nil, "ARTWORK")
		button.Icon:SetAllPoints()
		button.Icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])
		button.Icon:SetTexture(iconTexture[i])
		button:SetHighlightTexture(iconTexture[i])
		button:SetPushedTexture(iconTexture[i])

		if i ~= maxButtons then
			button:RegisterForClicks("AnyDown")
			button:SetAttribute("type", "macro")
			button:SetAttribute("macrotext1", format("/wm %d", i))
			button:SetAttribute("macrotext2", format("/cwm %d", i))
		else
			button:SetScript("OnClick", ClearRaidMarker)
		end
		frame.buttons[i] = button
	end

	Module:RaidTool_UpdateGrid()
end

local markerTypeToRow = {
	[1] = 3,
	[2] = 9,
	[3] = 1,
	[4] = 3,
}

function Module:RaidTool_UpdateGrid()
	local frame = _G["KKUI_WorldMarkers"]
	if not frame then return end

	local size, margin = C["Misc"].MarkerBarSize, 6
	local showType = C["Misc"].ShowMarkerBar.Value
	local perRow = markerTypeToRow[showType]

	for i = 1, maxButtons do
		local button = frame.buttons[i]
		button:SetSize(size, size)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("TOPLEFT", frame, margin, -margin)
		elseif mod(i - 1, perRow) == 0 then
			button:SetPoint("TOP", frame.buttons[i - perRow], "BOTTOM", 0, -margin)
		else
			button:SetPoint("LEFT", frame.buttons[i - 1], "RIGHT", margin, 0)
		end
	end

	local column = min(maxButtons, perRow)
	local rows = ceil(maxButtons / perRow)
	frame:SetWidth(column * size + (column - 1) * margin + 2 * margin)
	frame:SetHeight(size * rows + (rows - 1) * margin + 2 * margin)
	frame:SetShown(showType ~= 4)
end

function Module:RaidTool_Misc()
	-- UIWidget reanchor
	if not UIWidgetTopCenterContainerFrame:IsMovable() then -- can be movable for some addons, eg BattleInfo
		UIWidgetTopCenterContainerFrame:ClearAllPoints()
		UIWidgetTopCenterContainerFrame:SetPoint("TOP", 0, -46)
	end
end

function Module:RaidTool_Init()
	if not C["Misc"].RaidTool then return end
		
	local frame = Module:RaidTool_Header()
	Module:RaidTool_RoleCount(frame)
	Module:RaidTool_CombatRes(frame)
	Module:RaidTool_ReadyCheck(frame)
	Module:RaidTool_BuffChecker(frame)
	Module:RaidTool_CreateMenu(frame)

	Module:RaidTool_EasyMarker()
	Module:RaidTool_WorldMarker()
	Module:RaidTool_Misc()
end
Module:RegisterMisc("RaidTool", Module.RaidTool_Init)
