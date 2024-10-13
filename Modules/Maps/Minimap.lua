local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:NewModule("Minimap")

local math_floor = math.floor
local mod = mod
local pairs = pairs
local select = select
local table_insert = table.insert
local table_sort = table.sort

local C_Calendar_GetNumPendingInvites = C_Calendar.GetNumPendingInvites
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local GetUnitName = GetUnitName
local InCombatLockdown = InCombatLockdown
local Minimap = Minimap
local UnitClass = UnitClass
local hooksecurefunc = hooksecurefunc

function Module:CreateStyle()
	local minimapBorder = CreateFrame("Frame", "KKUI_MinimapBorder", Minimap)
	minimapBorder:SetAllPoints(Minimap)
	minimapBorder:SetFrameLevel(Minimap:GetFrameLevel())
	minimapBorder:SetFrameStrata("LOW")
	minimapBorder:CreateBorder()

	if not C["Minimap"].MailPulse then return end

	local minimapMailPulse = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
	minimapMailPulse:SetBackdrop({
		edgeFile = "Interface\\AddOns\\KkthnxUI\\Media\\Border\\Border_Glow_Overlay",
		edgeSize = 12,
	})
	minimapMailPulse:SetPoint("TOPLEFT", minimapBorder, -5, 5)
	minimapMailPulse:SetPoint("BOTTOMRIGHT", minimapBorder, 5, -5)
	minimapMailPulse:Hide()

	local anim = minimapMailPulse:CreateAnimationGroup()
	anim:SetLooping("BOUNCE")
	anim.fader = anim:CreateAnimation("Alpha")
	anim.fader:SetFromAlpha(0.8)
	anim.fader:SetToAlpha(0.2)
	anim.fader:SetDuration(1)
	anim.fader:SetSmoothing("OUT")

	-- Add comments to describe the purpose of the function
	local function updateMinimapBorderAnimation(event)
		local borderColor = nil

		-- If player enters combat, set border color to red
		if event == "PLAYER_REGEN_DISABLED" then
			borderColor = { 1, 0, 0, 0.8 }
		elseif not InCombatLockdown() then
			if C_Calendar.GetNumPendingInvites() > 0 or MiniMapMailFrame:IsShown() then
				-- If there are pending calendar invites or minimap mail frame is shown, set border color to yellow
				borderColor = { 1, 1, 0, 0.8 }
			end
		end

		-- If a border color was set, show the minimap mail pulse frame and play the animation
		if borderColor then
			minimapMailPulse:Show()
			minimapMailPulse:SetBackdropBorderColor(unpack(borderColor))
			anim:Play()
		else
			minimapMailPulse:Hide()
			minimapMailPulse:SetBackdropBorderColor(1, 1, 0, 0.8)
			-- Stop the animation
			anim:Stop()
		end
	end
	K:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", updateMinimapBorderAnimation)
	K:RegisterEvent("PLAYER_REGEN_DISABLED", updateMinimapBorderAnimation)
	K:RegisterEvent("PLAYER_REGEN_ENABLED", updateMinimapBorderAnimation)
	K:RegisterEvent("UPDATE_PENDING_MAIL", updateMinimapBorderAnimation)

	MiniMapMailFrame:HookScript("OnHide", function()
		if InCombatLockdown() then
			return
		end

		if anim and anim:IsPlaying() then
			anim:Stop()
			minimapMailPulse:Hide()
		end
	end)
end

function Module:ReskinRegions()
	-- QueueStatus Button
	MiniMapBattlefieldFrame:ClearAllPoints()
	MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -2, -2)
	MiniMapBattlefieldBorder:Hide()
	MiniMapBattlefieldIcon:SetAlpha(0)
	BattlegroundShine:SetTexture(nil)
	MiniMapBattlefieldFrame:SetFrameLevel(999)

	local queueIcon = Minimap:CreateTexture(nil, "OVERLAY")
	queueIcon:SetPoint("CENTER", MiniMapBattlefieldFrame)
	queueIcon:SetSize(50, 50)
	queueIcon:SetTexture("Interface\\Minimap\\Dungeon_Icon")
	queueIcon:Hide()

	local queueIconAnimation = queueIcon:CreateAnimationGroup()
	queueIconAnimation:SetLooping("REPEAT")
	queueIconAnimation.rotation = queueIconAnimation:CreateAnimation("Rotation")
	queueIconAnimation.rotation:SetDuration(2)
	queueIconAnimation.rotation:SetDegrees(360)

	hooksecurefunc("BattlefieldFrame_UpdateStatus", function()
		queueIcon:SetShown(MiniMapBattlefieldFrame:IsShown())
		queueIconAnimation:Play()
		for i = 1, MAX_BATTLEFIELD_QUEUES do
			local status = GetBattlefieldStatus(i)
			if status == "confirm" then
				queueIconAnimation:Stop()
				break
			end
		end
	end)

	local queueStatusDisplay = Module.QueueStatusDisplay
	if queueStatusDisplay then
		queueStatusDisplay.text:ClearAllPoints()
		queueStatusDisplay.text:SetPoint("CENTER", queueIcon, 0, -5)
		queueStatusDisplay.text:SetFontObject(K.UIFont)

		if queueStatusDisplay.title then
			Module:ClearQueueStatus()
		end
	end

	if MiniMapLFGFrame then
		MiniMapLFGFrame:ClearAllPoints()
		MiniMapLFGFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -2, -2)
		MiniMapLFGFrameBorder:Hide()
	end

	-- Difficulty Flags
	local function handleFlag(diff)
		diff:ClearAllPoints()
		diff:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
		diff:SetScale(1.1)
	end
	if MiniMapInstanceDifficulty then
		handleFlag(MiniMapInstanceDifficulty)
	end
	if GuildInstanceDifficulty then
		handleFlag(GuildInstanceDifficulty)
	end

	-- Tracking icon
	MiniMapTracking:SetScale(1.1)
	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetPoint("BOTTOMRIGHT", Minimap, 2, -4)
	MiniMapTracking:SetFrameLevel(999)
	MiniMapTrackingBackground:Hide()
	MiniMapTrackingButtonBorder:Hide()
	MiniMapTrackingIconOverlay:SetAlpha(0)
	local hl = MiniMapTrackingButton:GetHighlightTexture()
	hl:SetColorTexture(1, 1, 1, .25)
	hl:SetAllPoints(MiniMapTrackingIcon)

	-- Mail icon
	MiniMapMailFrame:ClearAllPoints()
	if C["DataText"].Time then
		MiniMapMailFrame:SetPoint("BOTTOM", Minimap, "BOTTOM", -5, 12)
	else
		MiniMapMailFrame:SetPoint("BOTTOM", Minimap, "BOTTOM", -5, -2)
	end
	MiniMapMailIcon:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Minimap\\mail.blp")
	MiniMapMailIcon:SetSize(28, 28)
	MiniMapMailFrame:SetHitRectInsets(11, 2, 13, 7)
	MiniMapMailIcon:SetVertexColor(1, 1, 1)
	MiniMapMailIcon:SetAlpha(0.9)

	-- Invites Icon
	GameTimeCalendarInvitesTexture:ClearAllPoints()
	GameTimeCalendarInvitesTexture:SetParent(Minimap)
	GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")

	local inviteNotification = CreateFrame("Button", nil, UIParent, "BackdropTemplate")
	inviteNotification:SetBackdrop({ edgeFile = "Interface\\AddOns\\KkthnxUI\\Media\\Border\\Border_Glow_Overlay", edgeSize = 12 })
	inviteNotification:SetPoint("TOPLEFT", Minimap, -5, 5)
	inviteNotification:SetPoint("BOTTOMRIGHT", Minimap, 5, -5)
	inviteNotification:SetBackdropBorderColor(1, 1, 0, 0.8)
	inviteNotification:Hide()

	K.CreateFontString(inviteNotification, 12, K.InfoColor .. "Pending Calendar Invite(s)!", "")

	local function updateInviteVisibility()
		inviteNotification:SetShown(C_Calendar_GetNumPendingInvites() > 0)
	end
	K:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", updateInviteVisibility)
	K:RegisterEvent("PLAYER_ENTERING_WORLD", updateInviteVisibility)

	inviteNotification:SetScript("OnClick", function(_, btn)
		inviteNotification:Hide()

		if btn == "LeftButton" then
			ToggleCalendar()
		end

		K:UnregisterEvent("CALENDAR_UPDATE_PENDING_INVITES", updateInviteVisibility)
		K:UnregisterEvent("PLAYER_ENTERING_WORLD", updateInviteVisibility)
	end)
end

function Module:CreatePing()
	local pingFrame = CreateFrame("Frame", nil, Minimap)
	pingFrame:SetSize(Minimap:GetWidth(), 13)
	pingFrame:SetPoint("BOTTOM", _G.Minimap, "BOTTOM", 0, 30)
	pingFrame.text = K.CreateFontString(pingFrame, 13, "", "OUTLINE", false, "CENTER")

	local pingAnimation = pingFrame:CreateAnimationGroup()

	pingAnimation:SetScript("OnPlay", function()
		pingFrame:SetAlpha(0.8)
	end)

	pingAnimation:SetScript("OnFinished", function()
		pingFrame:SetAlpha(0)
	end)

	pingAnimation.fader = pingAnimation:CreateAnimation("Alpha")
	pingAnimation.fader:SetFromAlpha(1)
	pingAnimation.fader:SetToAlpha(0)
	pingAnimation.fader:SetDuration(3)
	pingAnimation.fader:SetSmoothing("OUT")
	pingAnimation.fader:SetStartDelay(3)

	K:RegisterEvent("MINIMAP_PING", function(_, unit)
		if UnitIsUnit(unit, "player") then -- ignore player ping
			return
		end

		local class = select(2, UnitClass(unit))
		local r, g, b = K.ColorClass(class)
		local name = GetUnitName(unit)

		pingAnimation:Stop()
		pingFrame.text:SetText(name)
		pingFrame.text:SetTextColor(r, g, b)
		pingAnimation:Play()
	end)
end

function Module:UpdateMinimapScale()
	local size = C["Minimap"].Size
	Minimap:SetSize(size, size)
	if Minimap.mover then
		Minimap.mover:SetSize(size, size)
	end
end

function GetMinimapShape() -- LibDBIcon
	if not Module.Initialized then
		Module:UpdateMinimapScale()
		Module.Initialized = true
	end

	return "SQUARE"
end

function Module:HideMinimapClock()
	if TimeManagerClockButton then
		TimeManagerClockButton:SetParent(K.UIFrameHider)
		TimeManagerClockButton:UnregisterAllEvents()
	end
end

local GameTimeFrameStyled
function Module:ShowCalendar()
	if C["Minimap"].Calendar then
		if not GameTimeFrameStyled then
			local GameTimeFrame = GameTimeFrame
			local calendarText = GameTimeFrame:CreateFontString(nil, "OVERLAY")
			
			GameTimeFrame:SetParent(Minimap)
			GameTimeFrame:SetFrameLevel(16)
			GameTimeFrame:ClearAllPoints()
			GameTimeFrame:SetPoint("TOPRIGHT", Minimap, -4, -4)
			GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
			GameTimeFrame:SetSize(22, 22)

			calendarText:ClearAllPoints()
			calendarText:SetPoint("CENTER", 0, -4)
			calendarText:SetFontObject(K.UIFont)
			calendarText:SetFont(select(1, calendarText:GetFont()), 12, select(3, calendarText:GetFont()))
			calendarText:SetTextColor(0, 0, 0)
			calendarText:SetShadowOffset(0, 0)
			calendarText:SetAlpha(0.9)

			hooksecurefunc("GameTimeFrame_SetDate", function()
				GameTimeFrame:SetNormalTexture("Interface\\AddOns\\KkthnxUI\\Media\\Minimap\\Calendar.blp")
				GameTimeFrame:SetPushedTexture("Interface\\AddOns\\KkthnxUI\\Media\\Minimap\\Calendar.blp")
				GameTimeFrame:SetHighlightTexture(0)
				GameTimeFrame:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
				GameTimeFrame:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
				calendarText:SetText(C_DateAndTime_GetCurrentCalendarTime().monthDay)
			end)

			GameTimeFrameStyled = true
		end
		GameTimeFrame:Show()
	else
		GameTimeFrame:Hide()
	end
end

local function GetVolumeColor(cur)
	local r, g, b = K.oUF:RGBColorGradient(cur, 100, 1, 1, 1, 1, 0.8, 0, 1, 0, 0)
	return r, g, b
end

local function GetCurrentVolume()
	return K.Round(GetCVar("Sound_MasterVolume") * 100)
end

function Module:CreateSoundVolume()
	if not C["Minimap"].EasyVolume then return end

	local f = CreateFrame("Frame", nil, Minimap)
	f:SetAllPoints()
	local text = K.CreateFontString(f, 30)

	local anim = f:CreateAnimationGroup()
	anim:SetScript("OnPlay", function()
		f:SetAlpha(1)
	end)
	anim:SetScript("OnFinished", function()
		f:SetAlpha(0)
	end)
	anim.fader = anim:CreateAnimation("Alpha")
	anim.fader:SetFromAlpha(1)
	anim.fader:SetToAlpha(0)
	anim.fader:SetDuration(3)
	anim.fader:SetSmoothing("OUT")
	anim.fader:SetStartDelay(1)

	Module.VolumeText = text
	Module.VolumeAnim = anim
end

function Module:Minimap_OnMouseWheel(zoom)
	if IsControlKeyDown() and Module.VolumeText then
		local value = GetCurrentVolume()
		local mult = IsAltKeyDown() and 100 or 2
		value = value + zoom * mult
		if value > 100 then
			value = 100
		end
		if value < 0 then
			value = 0
		end

		SetCVar("Sound_MasterVolume", tostring(value / 100))
		Module.VolumeText:SetText(value .. "%")
		Module.VolumeText:SetTextColor(GetVolumeColor(value))
		Module.VolumeAnim:Stop()
		Module.VolumeAnim:Play()
	else
		if zoom > 0 then
			Minimap_ZoomIn()
		else
			Minimap_ZoomOut()
		end
	end
end

function Module:Minimap_TrackingDropdown()
	local dropdown = CreateFrame("Frame", "KKUI_MiniMapTrackingDropDown", _G.UIParent, "UIDropDownMenuTemplate")
	dropdown:SetID(1)
	dropdown:SetClampedToScreen(true)
	dropdown:Hide()

	_G.UIDropDownMenu_Initialize(dropdown, _G.MiniMapTrackingDropDown_Initialize, "MENU")
	dropdown.noResize = true

	return dropdown
end

function Module:Minimap_OnMouseUp(btn)
	if Module.TrackingDropdown then
		_G.HideDropDownMenu(1, nil, Module.TrackingDropdown)
	end

	local position = Minimap.mover:GetPoint()
	if btn == "MiddleButton" or (btn == "RightButton" and IsShiftKeyDown()) then
		if InCombatLockdown() then
			_G.UIErrorsFrame:AddMessage(K.InfoColor .. _G.ERR_NOT_IN_COMBAT)
			return
		end

	elseif btn == "RightButton" and Module.TrackingDropdown then
		if position:match("LEFT") then
			ToggleDropDownMenu(1, nil, Module.TrackingDropdown, "cursor", 0, 0)
		else
			ToggleDropDownMenu(1, nil, Module.TrackingDropdown, "cursor", -160, 0)
		end
	else
		_G.Minimap_OnClick(self)
	end
end

function Module:UpdateBlipTexture()
	Minimap:SetBlipTexture(C["Minimap"].BlipTexture.Value)
end

function Module:QueueStatusTimeFormat(seconds)
	local hours = math_floor(mod(seconds, 86400) / 3600)
	if hours > 0 then
		return Module.QueueStatusDisplay.text:SetFormattedText("%d" .. K.MyClassColor .. "h", hours)
	end

	local mins = math_floor(mod(seconds, 3600) / 60)
	if mins > 0 then
		return Module.QueueStatusDisplay.text:SetFormattedText("%d" .. K.MyClassColor .. "m", mins)
	end

	local secs = math_floor(seconds, 60)
	if secs > 0 then
		return Module.QueueStatusDisplay.text:SetFormattedText("%d" .. K.MyClassColor .. "s", secs)
	end
end

function Module:QueueStatusSetTime(seconds)
	local timeInQueue = GetTime() - seconds
	Module:QueueStatusTimeFormat(timeInQueue)
	Module.QueueStatusDisplay.text:SetTextColor(1, 1, 1)
end

function Module:QueueStatusOnUpdate(elapsed)
	-- Replicate QueueStatusEntry_OnUpdate throttle
	self.updateThrottle = self.updateThrottle - elapsed
	if self.updateThrottle <= 0 then
		Module:QueueStatusSetTime(self.queuedTime)
		self.updateThrottle = 0.1
	end
end

function Module:SetFullQueueStatus(title, queuedTime, averageWait)
	if not C["Minimap"].QueueStatusText then return end

	local display = Module.QueueStatusDisplay
	if not display.title or display.title == title then
		if queuedTime then
			display.title = title
			display.updateThrottle = 0
			display.queuedTime = queuedTime
			display.averageWait = averageWait
			display:SetScript("OnUpdate", Module.QueueStatusOnUpdate)
		else
			Module:ClearQueueStatus()
		end
	end
end

function Module:SetMinimalQueueStatus(title)
	if Module.QueueStatusDisplay.title == title then
		Module:ClearQueueStatus()
	end
end

function Module:ClearQueueStatus()
	local display = Module.QueueStatusDisplay
	display.text:SetText("")
	display.title = nil
	display.queuedTime = nil
	display.averageWait = nil
	display:SetScript("OnUpdate", nil)
end

function Module:CreateQueueStatusText()
	local display = CreateFrame("Frame", "KKUI_QueueStatusDisplay", _G.QueueStatusMinimapButton)
	display.text = display:CreateFontString(nil, "OVERLAY")

	Module.QueueStatusDisplay = display

	_G.QueueStatusMinimapButton:HookScript("OnHide", Module.ClearQueueStatus)
	hooksecurefunc("QueueStatusEntry_SetMinimalDisplay", Module.SetMinimalQueueStatus)
	hooksecurefunc("QueueStatusEntry_SetFullDisplay", Module.SetFullQueueStatus)
end

function Module:OnEnable()
	if not C["Minimap"].Enable then return end

	-- Shape and Position
	Minimap:SetFrameLevel(10)
	Minimap:SetMaskTexture(C["Media"].Textures.White8x8Texture)
	DropDownList1:SetClampedToScreen(true)

	-- Create the new minimap tracking dropdown frame and initialize it
	Module.TrackingDropdown = Module:Minimap_TrackingDropdown()

	local minimapMover = K.Mover(Minimap, "Minimap", "Minimap", { "TOPRIGHT", UIParent, "TOPRIGHT", -4, -4 })
	Minimap:ClearAllPoints()
	Minimap:SetPoint("TOPRIGHT", minimapMover)
	Minimap.mover = minimapMover

	self:HideMinimapClock()
	self:ShowCalendar()
	self:UpdateBlipTexture()
	self:UpdateMinimapScale()
	if _G.QueueStatusMinimapButton then
		Module:CreateQueueStatusText()
	end

	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", Module.Minimap_OnMouseWheel)
	Minimap:SetScript("OnMouseUp", Module.Minimap_OnMouseUp)

	-- Hide Blizz
	local frames = {
		"MinimapBorderTop",
		"MinimapNorthTag",
		"MinimapBorder",
		"MinimapZoneTextButton",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MiniMapWorldMapButton",
		"MiniMapMailBorder",
		--"MiniMapTracking",
	}

	for _, v in pairs(frames) do
		K.HideInterfaceOption(_G[v])
	end

	MinimapCluster:EnableMouse(false)

	-- Add Elements
	local loadMinimapModules = {
		"CreatePing",
		"CreateRecycleBin",
		"CreateSoundVolume",
		"CreateStyle",
		"ReskinRegions",
	}

	for _, funcName in ipairs(loadMinimapModules) do
		local func = self[funcName]
		if type(func) == "function" then
			local success, err = pcall(func, self)
			if not success then
				error("Error in function " .. funcName .. ": " .. tostring(err), 2)
			end
		end
	end
end
