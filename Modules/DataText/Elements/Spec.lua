local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("DataText")

local GetSpecialization = C_SpecializationInfo.GetSpecialization
local GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo
local SetSpecialization = C_SpecializationInfo.SetSpecialization or SetSpecialization

local function addIcon(texture)
	texture = texture and "|T" .. texture .. ":16:16:0:0:50:50:4:46:4:46|t" or ""
	return texture
end

local currentSpecIndex, currentLootIndex, newMenu, numSpecs, numLocal

local eventList = {
	"PLAYER_ENTERING_WORLD",
	"ACTIVE_PLAYER_SPECIALIZATION_CHANGED",
	"PLAYER_LOOT_SPEC_UPDATED"
}

local function OnEvent()
	currentSpecIndex = GetSpecialization()
	if currentSpecIndex and currentSpecIndex < 5 then
		local _, name, _, icon = GetSpecializationInfo(currentSpecIndex)
		if not name then return end
		currentLootIndex = GetLootSpecialization()
		if currentLootIndex == 0 then
			icon = addIcon(icon)
		else
			icon = addIcon(select(4, GetSpecializationInfoByID(currentLootIndex)))
		end
		SpecDataText.Text:SetText(icon .. " " .. K.MyClassColor .. name)
	else
		SpecDataText.Text:SetText(SPECIALIZATION .. ": ".. K.MyClassColor .. NONE)
	end
end

local function OnEnter()
	if not currentSpecIndex or currentSpecIndex == 5 then return end

	GameTooltip:SetOwner(SpecDataText, "ANCHOR_NONE")
	GameTooltip:SetPoint(K.GetAnchors(SpecDataText))
	GameTooltip:ClearLines()

	GameTooltip:AddLine(TALENTS_BUTTON, 0, 0.6, 1)
	GameTooltip:AddLine(" ")

	for i = 1, 2 do
		local specID, specName, _, specIcon = GetSpecializationInfo(i)
		GameTooltip:AddLine(addIcon(specIcon) .. " " .. specName, 0.6, 0.8, 1)
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(" ", K.LeftButton .. "Toggle TalentFrame" .. " ", 1, 1, 1, 0.6, 0.8, 1)
	GameTooltip:AddDoubleLine(" ", K.RightButton .. "Change Spec" .. " ", 1, 1, 1, 0.6, 0.8, 1)
	GameTooltip:Show()
end

local OnLeave = K.HideTooltip

local function selectSpec(_, specIndex)
	if GetActiveTalentGroup() == specIndex then return end
	SetActiveTalentGroup(specIndex)
	DropDownList1:Hide()
end

local function checkSpec(self)
	return GetActiveTalentGroup() == self.arg1
end

local function updateLootSpec()
	OnEvent()
end

local function selectLootSpec(_, index)
	SetLootSpecialization(index)
	DropDownList1:Hide()
	C_Timer.After(1, updateLootSpec) -- no event fired after SetLootSpecialization
end

local function checkLootSpec(self)
	return currentLootIndex == self.arg1
end

local function refreshDefaultLootSpec()
	if not currentSpecIndex or currentSpecIndex == 5 then return end
	newMenu[numLocal].text = format(" "..LOOT_SPECIALIZATION_DEFAULT, (select(2, GetSpecializationInfo(currentSpecIndex))) or NONE)
end

local seperatorMenu = {
	text = "",
	isTitle = true,
	notCheckable = true,
	iconOnly = true,
	icon = "Interface\\Common\\UI-TooltipDivider-Transparent",
	iconInfo = {
		tCoordLeft = 0,
		tCoordRight = 1,
		tCoordTop = 0,
		tCoordBottom = 1,
		tSizeX = 0,
		tSizeY = 8,
		tFitDropDownSizeX = true
	},
}

local function BuildSpecMenu()
	if newMenu then return end

	newMenu = {
		{ text = " " .. SPECIALIZATION, isTitle = true, notCheckable = true },
		{ text = " " .. SPECIALIZATION_PRIMARY, arg1 = 1, func = selectSpec, checked = checkSpec },
		{ text = " " .. SPECIALIZATION_SECONDARY, arg1 = 2, func = selectSpec, checked = checkSpec },
		seperatorMenu,
		{ text = " " .. SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
		{ text = "", arg1 = 0, func = selectLootSpec, checked = checkLootSpec },
	}
	numLocal = #newMenu

	for i = 1, 4 do
		local id, name = GetSpecializationInfo(i)
		if id and id ~= 0 then
			numSpecs = (numSpecs or 0) + 1
			tinsert(newMenu, {text = " "..name, arg1 = id, func = selectLootSpec, checked = checkLootSpec})
		end
	end

	refreshDefaultLootSpec()
	K:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED", refreshDefaultLootSpec)
end

local function OnMouseUp(self, btn)
	if not currentSpecIndex or currentSpecIndex == 5 then return end

	if btn == "LeftButton" then
		if InCombatLockdown() then UIErrorsFrame:AddMessage(K.InfoColor .. ERR_NOT_IN_COMBAT) return end
		ToggleTalentFrame()
	else
		BuildSpecMenu()
		K.LibEasyMenu.Create(newMenu, K.EasyMenu, self, -80, 100, "MENU", 1)
		GameTooltip:Hide()
	end
end

function Module:CreateSpecDataText()
	if not C["DataText"].Spec then
		return
	end

	SpecDataText = CreateFrame("Frame", nil, UIParent)

	SpecDataText.Text = K.CreateFontString(SpecDataText, 12)
	SpecDataText.Text:ClearAllPoints()
	SpecDataText.Text:SetPoint("LEFT", UIParent, "LEFT", 24, -210)

	SpecDataText.Texture = SpecDataText:CreateTexture(nil, "ARTWORK")
	SpecDataText.Texture:SetPoint("RIGHT", SpecDataText.Text, "LEFT", 0, 2)
	SpecDataText.Texture:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\DataText\\talents.blp")
	SpecDataText.Texture:SetSize(24, 24)
	SpecDataText.Texture:SetVertexColor(unpack(C["DataText"].IconColor))

	SpecDataText:SetAllPoints(SpecDataText.Text)

	local function _OnEvent(...)
		OnEvent(...)
	end

	for _, event in pairs(eventList) do
		SpecDataText:RegisterEvent(event)
	end

	SpecDataText:SetScript("OnEvent", _OnEvent)
	SpecDataText:SetScript("OnEnter", OnEnter)
	SpecDataText:SetScript("OnLeave", OnLeave)
	SpecDataText:SetScript("OnMouseUp", OnMouseUp)

	K.Mover(SpecDataText.Text, "SpecDT", "SpecDT", { "LEFT", UIParent, "LEFT", 24, -230 }, 100, 16)
end
