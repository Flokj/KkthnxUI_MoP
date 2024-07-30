local K, C = KkthnxUI[1], KkthnxUI[2]
local r, g, b = K.r, K.g, K.b

local function colorMinimize(f)
	if f:IsEnabled() then
		f.minimize:SetVertexColor(r, g, b)
	end
end

local function clearMinimize(f)
	f.minimize:SetVertexColor(1, 1, 1)
end

local function updateMinorButtonState(button)
	if button:GetChecked() then
		button.bg:SetBackdropColor(1, 0.8, 0, 0.25)
	else
		button.bg:SetBackdropColor(0, 0, 0, 0.25)
	end
end

tinsert(C.defaultThemes, function()
	if not C["Skins"].BlizzardFrames then return end

	for i = 1, 4 do
		local frame = _G["StaticPopup" .. i]
		local bu = _G["StaticPopup" .. i .. "ItemFrame"]
		local close = _G["StaticPopup" .. i .. "CloseButton"]

		local gold = _G["StaticPopup" .. i .. "MoneyInputFrameGold"]
		local silver = _G["StaticPopup" .. i .. "MoneyInputFrameSilver"]
		local copper = _G["StaticPopup" .. i .. "MoneyInputFrameCopper"]

		_G["StaticPopup" .. i .. "ItemFrameNameFrame"]:Hide()
		_G["StaticPopup" .. i .. "ItemFrameIconTexture"]:SetTexCoord(.08, .92, .08, .92)

		bu:SetNormalTexture(0)
		bu:SetHighlightTexture(0)
		bu:SetPushedTexture(0)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", bu.bg, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", bu.bg, 115, 0)
		bg:SetFrameLevel(gold:GetFrameLevel())
		bg:CreateBorder()

		silver:SetPoint("LEFT", gold, "RIGHT", 1, 0)
		copper:SetPoint("LEFT", silver, "RIGHT", 1, 0)

		frame:StripTextures()
		frame:CreateBorder()
		for j = 1, 4 do
			frame["button" .. j]:SkinButton()
		end
		frame.extraButton:SkinButton()
		close:SkinCloseButton()

		_G["StaticPopup" .. i .. "EditBox"].bg = CreateFrame("Frame", nil, _G["StaticPopup" .. i .. "EditBox"], "BackdropTemplate")
		_G["StaticPopup" .. i .. "EditBox"].bg:SetAllPoints(_G["StaticPopup" .. i .. "EditBox"])
		_G["StaticPopup" .. i .. "EditBox"].bg:SetFrameLevel(_G["StaticPopup" .. i .. "EditBox"]:GetFrameLevel())
		_G["StaticPopup" .. i .. "EditBox"].bg:CreateBorder()

		gold.bg = CreateFrame("Frame", nil, gold)
		gold.bg:SetAllPoints(gold)
		gold.bg:SetFrameLevel(gold:GetFrameLevel())
		gold.bg:CreateBorder()

		silver.bg = CreateFrame("Frame", nil, silver)
		silver.bg:SetAllPoints(silver)
		silver.bg:SetFrameLevel(silver:GetFrameLevel())
		silver.bg:CreateBorder()

		copper.bg = CreateFrame("Frame", nil, copper)
		copper.bg:SetAllPoints(copper)
		copper.bg:SetFrameLevel(copper:GetFrameLevel())
		copper.bg:CreateBorder()
	end

	hooksecurefunc("StaticPopup_Show", function(which, _, _, data)
		local info = StaticPopupDialogs[which]

		if not info then return end

		local dialog = nil
		dialog = StaticPopup_FindVisible(which, data)

		if not dialog then
			local index = 1
			if info.preferredIndex then
				index = info.preferredIndex
			end
			for i = index, STATICPOPUP_NUMDIALOGS do
				local frame = _G["StaticPopup" .. i]
				if not frame:IsShown() then
					dialog = frame
					break
				end
			end

			if not dialog and info.preferredIndex then
				for i = 1, info.preferredIndex do
					local frame = _G["StaticPopup" .. i]
					if not frame:IsShown() then
						dialog = frame
						break
					end
				end
			end
		end

		if not dialog then return end

		if info.closeButton then
			local closeButton = _G[dialog:GetName() .. "CloseButton"]

			closeButton:SetNormalTexture(0)
			closeButton:SetPushedTexture(0)

			if info.closeButtonIsHide then
				closeButton.__texture:Hide()
				closeButton.minimize:Show()
			else
				closeButton.__texture:Show()
				closeButton.minimize:Hide()
			end
		end
	end)
end)
