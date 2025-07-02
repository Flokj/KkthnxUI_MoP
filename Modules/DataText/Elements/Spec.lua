local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("DataText")

local GetTalentInfo = C_SpecializationInfo.GetTalentInfo
local GetSpecialization = C_SpecializationInfo.GetSpecialization
local GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo
local SetSpecialization = C_SpecializationInfo.SetSpecialization

local function addIcon(texture)
	texture = texture and "|T" .. texture .. ":16:16:0:0:50:50:4:46:4:46|t" or ""
	return texture
end

local currentSpecIndex, currentLootIndex, newMenu, numSpecs, numLocal

local eventList = {
	"PLAYER_ENTERING_WORLD",
	"ACTIVE_PLAYER_SPECIALIZATION_CHANGED",
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

	local specID, specName, _, specIcon = GetSpecializationInfo(currentSpecIndex)
	GameTooltip:AddLine(addIcon(specIcon) .. " " .. specName, 0.6, 0.8, 1)
--[[]
	for t = 1, MAX_TALENT_TIERS do
		for c = 1, 3 do
			local _, name, icon, selected = GetTalentInfo(t, c, 1)
			if selected then
				GameTooltip:AddLine(addIcon(icon).." "..name, 1,1,1)
			end
		end
	end
]]

	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(" ", K.LeftButton .. "Toggle TalentFrame" .. " ", 1, 1, 1, 0.6, 0.8, 1)
	--GameTooltip:AddDoubleLine(" ", K.RightButton.."Change Spec" .. " ", 1, 1, 1, 0.6, 0.8, 1)
	GameTooltip:Show()
end

local OnLeave = K.HideTooltip

local function selectSpec(_, specIndex)
	if currentSpecIndex == specIndex then return end
	SetSpecialization(specIndex)
	DropDownList1:Hide()
end

local function checkSpec(self)
	return currentSpecIndex == self.arg1
end

local function selectLootSpec(_, index)
	SetLootSpecialization(index)
	DropDownList1:Hide()
end

local function checkLootSpec(self)
	return currentLootIndex == self.arg1
end

local function refreshDefaultLootSpec()
	if not currentSpecIndex or currentSpecIndex == 5 then return end
	local mult = 3 + numSpecs
	newMenu[numLocal - mult].text = format(LOOT_SPECIALIZATION_DEFAULT, (select(2, GetSpecializationInfo(currentSpecIndex))) or NONE)
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
		{ text = SPECIALIZATION, isTitle = true, notCheckable = true },
		seperatorMenu,
		{ text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
		{ text = "", arg1 = 0, func = selectLootSpec, checked = checkLootSpec },
	}

	for i = 1, 4 do
		local id, name = GetSpecializationInfo(i)
		if id then
			numSpecs = (numSpecs or 0) + 1
			tinsert(newMenu, i + 1, { text = name, arg1 = i, func = selectSpec, checked = checkSpec })
			tinsert(newMenu, { text = name, arg1 = id, func = selectLootSpec, checked = checkLootSpec })
		end
	end

	numLocal = #newMenu

	refreshDefaultLootSpec()
	K:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED", refreshDefaultLootSpec)
end

local function OnMouseUp(self, btn)
	if not currentSpecIndex or currentSpecIndex == 5 then return end

	if btn == "LeftButton" then
		if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end -- fix by LibShowUIPanel
		ToggleTalentFrame()
	else
	--	BuildSpecMenu()
	--	EasyMenu(newMenu, B.EasyMenu, self, -80, 100, "MENU", 1)
	--	GameTooltip:Hide()
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

	K.Mover(SpecDataText.Text, "SpecDataText", "SpecDataText", { "LEFT", UIParent, "LEFT", 24, -230 }, 100, 16)

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
end
