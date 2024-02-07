local K, C = KkthnxUI[1], KkthnxUI[2]

local function colourPopout(self)
	self.arrow:SetVertexColor(0, 0.6, 1)
end

local function clearPopout(self)
	self.arrow:SetVertexColor(1, 1, 1)
end

tinsert(C.defaultThemes, function()
	if not C["Skins"].BlizzardFrames then return end

	local slots = {
		"Head",
		"Neck",
		"Shoulder",
		"Shirt",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Finger0",
		"Finger1",
		"Trinket0",
		"Trinket1",
		"Back",
		"MainHand",
		"SecondaryHand",
		"Tabard",
		"Ranged",
	}

	for i = 1, #slots do
		local slot = _G["Character" .. slots[i] .. "Slot"]

		slot:SetNormalTexture(0)
		slot.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

		slot.bg = CreateFrame("Frame", nil, slot)
		slot.bg:SetAllPoints(slot.icon)
		slot.bg:SetFrameLevel(slot:GetFrameLevel())
		slot.bg:CreateBorder()

		local popout = slot.popoutButton
		popout:SetNormalTexture(0)

		local arrow = popout:CreateTexture(nil, "OVERLAY")
		arrow:SetSize(14, 14)
		if slot.verticalFlyout then
			K.SetupArrow(arrow, "down")
			arrow:SetPoint("TOP", slot, "BOTTOM", 0, 1)
		else
			K.SetupArrow(arrow, "right")
			arrow:SetPoint("LEFT", slot, "RIGHT", -1, 0)
		end
		popout.arrow = arrow

		colourPopout(popout)
		popout:HookScript("OnEnter", clearPopout)
		popout:HookScript("OnLeave", colourPopout)
	end

	CharacterAmmoSlot:StripTextures()
	CharacterAmmoSlotIconTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	CharacterAmmoSlot:CreateBorder()

	 --hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
	 --	local icon = button.icon
	 --	if icon then icon:SetShown(button.hasItem) end
	 --end)
end)
