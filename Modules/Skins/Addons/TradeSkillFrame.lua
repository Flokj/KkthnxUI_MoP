local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Skins")

SharedWindowData = {
	area = "override",
	xoffset = -16,
	yoffset = 12,
	bottomClampOverride = 152,
	width = 714,
	height = 487,
	whileDead = 1,
}

local function EnlargeDefaultUIPanel(name, pushed)
	local frame = _G[name]
	if not frame then return end

	UIPanelWindows[name] = SharedWindowData
	UIPanelWindows[name].pushable = pushed

	frame:SetSize(SharedWindowData.width, SharedWindowData.height)
	frame.TitleText:ClearAllPoints()
	frame.TitleText:SetPoint("TOP", frame, 0, -18)

	frame.scrollFrame:ClearAllPoints()
	frame.scrollFrame:SetPoint("TOPRIGHT", frame, -65, -110)
	frame.scrollFrame:SetPoint("BOTTOMRIGHT", frame, -65, 110)
	frame.listScrollFrame:ClearAllPoints()
	frame.listScrollFrame:SetPoint("TOPLEFT", frame, 14, -110)
	frame.listScrollFrame:SetPoint("BOTTOMLEFT", frame, 14, 110)

	local topLeft = frame:CreateTexture(nil, "BACKGROUND")
	topLeft:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\TradeSkillFrame\\TopLeft.blp")
	topLeft:SetPoint("TOPLEFT")
	local top = frame:CreateTexture(nil, "BACKGROUND")
	top:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\TradeSkillFrame\\Top.blp")
	top:SetPoint("TOPLEFT", topLeft, "TOPRIGHT")
	local topRight = frame:CreateTexture(nil, "BACKGROUND")
	topRight:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\TradeSkillFrame\\TopRight.blp")
	topRight:SetPoint("TOPLEFT", top, "TOPRIGHT")
	local bottomLeft = frame:CreateTexture(nil, "BACKGROUND")
	bottomLeft:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\TradeSkillFrame\\BotLeft.blp")
	bottomLeft:SetPoint("BOTTOMLEFT")
	local bottom = frame:CreateTexture(nil, "BACKGROUND")
	bottom:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\TradeSkillFrame\\Bot.blp")
	bottom:SetPoint("BOTTOMLEFT", bottomLeft, "BOTTOMRIGHT")
	local bottomRight = frame:CreateTexture(nil, "BACKGROUND")
	bottomRight:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\TradeSkillFrame\\BotRight.blp")
	bottomRight:SetPoint("BOTTOMLEFT", bottom, "BOTTOMRIGHT")
end

function Module:TradeSkill_OnEvent(addon)
	if addon == "Blizzard_TradeSkillUI" then
		Module:EnhancedTradeSkill()
		K:UnregisterEvent("ADDON_LOADED", Module.TradeSkill_OnEvent)
	end
end

function Module:TradeSkillSkin()
	if not C["Skins"].TradeSkills then return end

	K:RegisterEvent("ADDON_LOADED", Module.TradeSkill_OnEvent)
end

function Module:EnhancedTradeSkill()
	local TradeSkillFrame = _G.TradeSkillFrame
	if TradeSkillFrame:GetWidth() > 700 then return end

	TradeSkillFrame:StripTextures()
	TradeSkillFrame.TitleText = TradeSkillFrameTitleText
	TradeSkillFrame.scrollFrame = _G.TradeSkillDetailScrollFrame
	TradeSkillFrame.listScrollFrame = _G.TradeSkillListScrollFrame
	EnlargeDefaultUIPanel("TradeSkillFrame", 1)

	_G.TRADE_SKILLS_DISPLAYED = 20
	for i = 2, _G.TRADE_SKILLS_DISPLAYED do
		local button = _G["TradeSkillSkill"..i]
		if not button then
			button = CreateFrame("Button", "TradeSkillSkill"..i, TradeSkillFrame, "TradeSkillSkillButtonTemplate")
			button:SetID(i)
			button:Hide()
		end
		button:SetPoint("TOPLEFT", _G["TradeSkillSkill"..(i-1)], "BOTTOMLEFT", 0, 1)
	end

	TradeSkillCancelButton:ClearAllPoints()
	TradeSkillCancelButton:SetPoint("BOTTOMRIGHT", TradeSkillFrame, "BOTTOMRIGHT", -42, 54)
	TradeSkillCreateButton:ClearAllPoints()
	TradeSkillCreateButton:SetPoint("RIGHT", TradeSkillCancelButton, "LEFT", -1, 0)
	TradeSkillInvSlotDropDown:ClearAllPoints()
	TradeSkillInvSlotDropDown:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 510, -40)
	TradeSkillFrameAvailableFilterCheckButton:SetPoint("TOPLEFT", 550, -70)

	TradeSkillDetailScrollFrame:SetPoint("TOPRIGHT", -65, -105)

	if C["Skins"].BlizzardFrames then
		TradeSkillFrame:SetHeight(512)
		TradeSkillCancelButton:SetPoint("BOTTOMRIGHT", TradeSkillFrame, "BOTTOMRIGHT", -42, 78)
	else
		TradeSkillFrameBottomLeftTexture:Hide()
		TradeSkillFrameBottomRightTexture:Hide()
		TradeSkillFrameCloseButton:ClearAllPoints()
		TradeSkillFrameCloseButton:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -30, -8)
	end
end
