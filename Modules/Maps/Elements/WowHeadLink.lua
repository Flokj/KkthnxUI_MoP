local K, C, L = KkthnxUI[1], KkthnxUI[2], KkthnxUI[3]
local Module = K:GetModule("WorldMap")

local GameTooltip = GameTooltip
local GetAchievementLink = GetAchievementLink
local GetQuestLink = GetQuestLink
local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc
local setmetatable = setmetatable

-- Wowhead Links
function Module:CreateWowHeadLinks()
	if not C["Misc"].ShowWowHeadLinks or IsAddOnLoaded("Leatrix_Maps") then
		return
	end

	-- Add wowhead link by Goldpaw "Lars" Norberg
	local subDomain = (setmetatable({
		ruRU = "ru",
		frFR = "fr",
		deDE = "de",
		esES = "es",
		esMX = "es",
		ptBR = "pt",
		ptPT = "pt",
		itIT = "it",
		koKR = "ko",
		zhTW = "cn",
		zhCN = "cn",
	}, {
		__index = function(t, v)
			return "www"
		end,
	}))[K.Locale]

	local wowheadLoc = subDomain .. ".wowhead.com"
	local urlQuestIcon = [[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:0:0:0:0|t]]

	-- Create editbox
	local WorldMapEditBox = CreateFrame("EditBox", nil, QuestLogFrame)
	WorldMapEditBox:SetFrameLevel(999)
	WorldMapEditBox:ClearAllPoints()
	WorldMapEditBox:SetPoint("TOPLEFT", 70, 4)
	WorldMapEditBox:SetHeight(16)
	WorldMapEditBox:SetFontObject("GameFontNormal")
	WorldMapEditBox:SetBlinkSpeed(0)
	WorldMapEditBox:SetAutoFocus(false)
	WorldMapEditBox:EnableKeyboard(false)
	WorldMapEditBox:SetHitRectInsets(0, 90, 0, 0)
	WorldMapEditBox:SetScript("OnKeyDown", function() end)
	WorldMapEditBox:SetScript("OnMouseUp", function()
		if WorldMapEditBox:IsMouseOver() then
			WorldMapEditBox:HighlightText()
		else
			WorldMapEditBox:HighlightText(0, 0)
		end
	end)

	-- Create hidden font string (used for setting width of editbox)
	WorldMapEditBox.FakeText = WorldMapEditBox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	WorldMapEditBox.FakeText:Hide()

	-- Function to set editbox value
	local function SetQuestInBox(questListID)
		local questTitle, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(questListID)
		if questID and not isHeader then
			-- Hide editbox if quest ID is invalid
			if questID == 0 then
				WorldMapEditBox:Hide()
			else
				WorldMapEditBox:Show()
			end
			-- Set editbox text
			WorldMapEditBox:SetText("https://" .. wowheadLoc .. "/quest=" .. questID)
			-- Set hidden fontstring then resize editbox to match
			WorldMapEditBox.FakeText:SetText(WorldMapEditBox:GetText())
			WorldMapEditBox:SetWidth(WorldMapEditBox.FakeText:GetStringWidth() + 90)
			-- Get quest title for tooltip
			local questLink = GetQuestLink(questID) or nil
			if questLink then
				WorldMapEditBox.tiptext = questLink:match("%[(.-)%]") .. "|n" .. L["Press To Copy"]
			else
				WorldMapEditBox.tiptext = ""
				if WorldMapEditBox:IsMouseOver() and GameTooltip:IsShown() then
					GameTooltip:Hide()
				end
			end
		end
	end

	-- Set URL when quest is selected
	hooksecurefunc("QuestLog_SetSelection", function(questListID)
		SetQuestInBox(questListID)
	end)

	-- Create tooltip
	WorldMapEditBox:HookScript("OnEnter", function()
		WorldMapEditBox:HighlightText()
		WorldMapEditBox:SetFocus()
		GameTooltip:SetOwner(WorldMapEditBox, "ANCHOR_BOTTOM", 0, -10)
		GameTooltip:SetText(WorldMapEditBox.tiptext, nil, nil, nil, nil, true)
		GameTooltip:Show()
	end)

	WorldMapEditBox:HookScript("OnLeave", function()
		WorldMapEditBox:HighlightText(0, 0)
		WorldMapEditBox:ClearFocus()
		GameTooltip:Hide()
	end)
end
