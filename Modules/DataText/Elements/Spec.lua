local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("DataText")

local format, strsub = string.format, strsub
local TALENT, SHOW_SPEC_LEVEL, FEATURE_BECOMES_AVAILABLE_AT_LEVEL, NONE = TALENT, SHOW_SPEC_LEVEL, FEATURE_BECOMES_AVAILABLE_AT_LEVEL, NONE
local UnitLevel, ToggleTalentFrame, UnitCharacterPoints = UnitLevel, ToggleTalentFrame, UnitCharacterPoints
local talentString = "%s (%s)"
local unspendPoints = gsub(CHARACTER_POINTS1_COLON, HEADER_COLON, "")

local GetTalentInfo = C_SpecializationInfo.GetTalentInfo
local GetSpecialization = C_SpecializationInfo.GetSpecialization
local GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo
local SetSpecialization = C_SpecializationInfo.SetSpecialization

local function addIcon(texture)
	texture = texture and "|T" .. texture .. ":12:16:0:0:50:50:4:46:4:46|t" or ""
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
		self.text:SetText(K.MyClassColor .. name .. icon)
	else
		self.text:SetText(SPECIALIZATION .. ": ".. K.MyClassColor .. NONE)
	end
end

local function OnEnter(self)
	if not currentSpecIndex or currentSpecIndex == 5 then return end

	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint(K.GetAnchors(self))
	GameTooltip:ClearLines()

	GameTooltip:AddLine(TALENTS_BUTTON, 0, 0.6, 1)
	GameTooltip:AddLine(" ")

	local specID, specName, _, specIcon = GetSpecializationInfo(currentSpecIndex)
	GameTooltip:AddLine(addIcon(specIcon) .." " .. specName, 0.6, 0.8, 1)
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

local function OnMouseUp(self, btn)
	if UnitLevel("player") < SHOW_SPEC_LEVEL then
		UIErrorsFrame:AddMessage(K.InfoColor .. format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_SPEC_LEVEL))
	elseif btn == "RightButton" then
		if InCombatLockdown() then return end
		if GetNumTalentGroups() < 2 then return end
		local idx = GetActiveTalentGroup()
		SetActiveTalentGroup(idx == 1 and 2 or 1)
	else
		--if InCombatLockdown() then UIErrorsFrame:AddMessage(K.InfoColor..ERR_NOT_IN_COMBAT) return end -- fix by LibShowUIPanel
		ToggleTalentFrame()
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
