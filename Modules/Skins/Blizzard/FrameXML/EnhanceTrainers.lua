local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Skins")

-- Set increased height of skill trainer frame and maximum number of skills listed
local tall, numTallTrainers = 73, 17

-- Make the frame double-wide
UIPanelWindows["ClassTrainerFrame"] = {
	area = "override",
	pushable = 0,
	xoffset = -16,
	yoffset = 12,
	bottomClampOverride = 140 + 12,
	width = 685,
	height = 487,
	whileDead = 1
}

function Module:Trainer_OnEvent(addon)
	if addon == "Blizzard_TrainerUI" then
		Module:EnhancedTrainer()
		K:UnregisterEvent("ADDON_LOADED", Module.Trainer_OnEvent)
	end
end

function Module:TrainerSkin()
	if not C["Skins"].Trainers then return end

	K:RegisterEvent("ADDON_LOADED", Module.Trainer_OnEvent)
end

function Module:EnhancedTrainer()
		-- Size the frame
	_G["ClassTrainerFrame"]:SetSize(714, 487 + tall)

	-- Lower title text slightly
	_G["ClassTrainerNameText"]:ClearAllPoints()
	_G["ClassTrainerNameText"]:SetPoint("TOP", _G["ClassTrainerFrame"], "TOP", 0, -18)

	-- Expand the skill list to full height
	_G["ClassTrainerListScrollFrame"]:ClearAllPoints()
	_G["ClassTrainerListScrollFrame"]:SetPoint("TOPLEFT", _G["ClassTrainerFrame"], "TOPLEFT", 25, -75)
	_G["ClassTrainerListScrollFrame"]:SetSize(295, 336 + tall)

	-- Create additional list rows
	do
		local oldSkillsDisplayed = CLASS_TRAINER_SKILLS_DISPLAYED

		-- Position existing buttons
		for i = 1 + 1, CLASS_TRAINER_SKILLS_DISPLAYED do
			_G["ClassTrainerSkill" .. i]:ClearAllPoints()
			_G["ClassTrainerSkill" .. i]:SetPoint("TOPLEFT", _G["ClassTrainerSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
		end

		-- Create and position new buttons
		_G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + numTallTrainers
		for i = oldSkillsDisplayed + 1, CLASS_TRAINER_SKILLS_DISPLAYED do
			local button = CreateFrame("Button", "ClassTrainerSkill" .. i, ClassTrainerFrame, "ClassTrainerSkillButtonTemplate")
			button:SetID(i)
			button:Hide()
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", _G["ClassTrainerSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
		end

		hooksecurefunc("ClassTrainer_SetToTradeSkillTrainer", function()
			_G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + numTallTrainers
			ClassTrainerListScrollFrame:SetHeight(336 + tall)
			ClassTrainerDetailScrollFrame:SetHeight(336 + tall)
		end)

		hooksecurefunc("ClassTrainer_SetToClassTrainer", function()
			_G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + numTallTrainers - 1
			ClassTrainerListScrollFrame:SetHeight(336 + tall)
			ClassTrainerDetailScrollFrame:SetHeight(336 + tall)
		end)
	end

	-- Set highlight bar width when shown
	hooksecurefunc(_G["ClassTrainerSkillHighlightFrame"], "Show", function()
		ClassTrainerSkillHighlightFrame:SetWidth(290)
	end)

	-- Move the detail frame to the right and stretch it to full height
	_G["ClassTrainerDetailScrollFrame"]:ClearAllPoints()
	_G["ClassTrainerDetailScrollFrame"]:SetPoint("TOPLEFT", _G["ClassTrainerFrame"], "TOPLEFT", 352, -74)
	_G["ClassTrainerDetailScrollFrame"]:SetSize(296, 336 + tall)
	-- _G["ClassTrainerSkillIcon"]:SetHeight(500) -- Debug

	-- Hide detail scroll frame textures
	_G["ClassTrainerDetailScrollFrameTop"]:SetAlpha(0)
	_G["ClassTrainerDetailScrollFrameBottom"]:SetAlpha(0)

	-- Hide expand tab (left of All button)
	_G["ClassTrainerExpandTabLeft"]:Hide()

	-- Get frame textures
	local regions = {_G["ClassTrainerFrame"]:GetRegions()}

	-- Set top left texture
	regions[2]:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\TradeSkillFrame\\Leatrix_Plus.blp")
	regions[2]:SetTexCoord(0.25, 0.75, 0, 1)
	regions[2]:SetSize(512, 512)

	-- Set top right texture
	regions[3]:ClearAllPoints()
	regions[3]:SetPoint("TOPLEFT", regions[2], "TOPRIGHT", 0, 0)
	regions[3]:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\TradeSkillFrame\\Leatrix_Plus.blp")
	regions[3]:SetTexCoord(0.75, 1, 0, 1)
	regions[3]:SetSize(256, 512)

	-- Hide bottom left and bottom right textures
	regions[4]:Hide()
	regions[5]:Hide()

	-- Hide skills list dividing bar
	regions[9]:Hide()
	ClassTrainerHorizontalBarLeft:Hide()

	-- Set skills list backdrop
	local RecipeInset = _G["ClassTrainerFrame"]:CreateTexture(nil, "ARTWORK")
	RecipeInset:SetSize(304, 361 + tall)
	RecipeInset:SetPoint("TOPLEFT", _G["ClassTrainerFrame"], "TOPLEFT", 16, -72)
	RecipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")

	-- Set detail frame backdrop
	local DetailsInset = _G["ClassTrainerFrame"]:CreateTexture(nil, "ARTWORK")
	DetailsInset:SetSize(302, 339 + tall)
	DetailsInset:SetPoint("TOPLEFT", _G["ClassTrainerFrame"], "TOPLEFT", 348, -72)
	DetailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")

	-- Move bottom button row
	_G["ClassTrainerTrainButton"]:ClearAllPoints()
	_G["ClassTrainerTrainButton"]:SetPoint("RIGHT", _G["ClassTrainerCancelButton"], "LEFT", -1, 0)

	-- Position and size close button
	_G["ClassTrainerCancelButton"]:SetSize(80, 22)
	_G["ClassTrainerCancelButton"]:SetText(CLOSE)
	_G["ClassTrainerCancelButton"]:ClearAllPoints()
	_G["ClassTrainerCancelButton"]:SetPoint("BOTTOMRIGHT", _G["ClassTrainerFrame"], "BOTTOMRIGHT", -42, 54)

	-- Position close box
	_G["ClassTrainerFrameCloseButton"]:ClearAllPoints()
	_G["ClassTrainerFrameCloseButton"]:SetPoint("TOPRIGHT", _G["ClassTrainerFrame"], "TOPRIGHT", -30, -8)

	-- Position dropdown menus
	ClassTrainerFrameFilterDropDown:ClearAllPoints()
	ClassTrainerFrameFilterDropDown:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 501, -40)

	-- Position money frame
	ClassTrainerMoneyFrame:ClearAllPoints()
	ClassTrainerMoneyFrame:SetPoint("TOPLEFT", _G["ClassTrainerFrame"], "TOPLEFT", 143, -49)
	ClassTrainerGreetingText:Hide()

	----------------------------------------------------------------------
	-- Create train all button
	local trainAllButton = CreateFrame("Button", "TrainAllButton", ClassTrainerFrame, "UIPanelButtonTemplate")
   trainAllButton:SetSize(80, 22)
   trainAllButton:SetText("Train All")
   trainAllButton:SetPoint("BOTTOMLEFT", ClassTrainerFrame, "BOTTOMLEFT", 344, 54)

   -- Button tooltip
   trainAllButton:SetScript("OnEnter", function(self)
   	-- Get number of available skills and total cost
   	local count, cost = 0, 0
   	for i = 1, GetNumTrainerServices() do
      	local _, _, isAvail = GetTrainerServiceInfo(i)
      	if isAvail == "available" then
         	count = count + 1
         	cost = cost + GetTrainerServiceCost(i)
      	end
   	end
   	-- Show tooltip
   	if count > 0 then
      	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 4)
      	GameTooltip:ClearLines()
      	if count > 1 then
         	GameTooltip:AddLine("Train " .. count .. " skills for " .. GetCoinTextureString(cost))
      	else
         	GameTooltip:AddLine("Train " .. count .. " skill for " .. GetCoinTextureString(cost))
      	end
      	GameTooltip:Show()
   	end
   end)

   -- Button click handler
   trainAllButton:SetScript("OnClick", function(self)
       for i = 1, GetNumTrainerServices() do
           local _, _, isAvail = GetTrainerServiceInfo(i)
           if isAvail == "available" then
               BuyTrainerService(i)
           end
       end
   end)

   -- Enable button only when skills are available
	local skillsAvailable
	hooksecurefunc("ClassTrainerFrame_Update", function()
		skillsAvailable = false
		for i = 1, GetNumTrainerServices() do
			local void, void, isAvail = GetTrainerServiceInfo(i)
			if isAvail and isAvail == "available" then
				skillsAvailable = true
			end
		end
		trainAllButton:SetEnabled(skillsAvailable)
		-- Refresh tooltip
		if trainAllButton:IsMouseOver() and skillsAvailable then
			trainAllButton:GetScript("OnEnter")(trainAllButton)
		end
	end)
end