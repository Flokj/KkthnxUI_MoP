local K, C = KkthnxUI[1], KkthnxUI[2]

C.themes["Blizzard_InspectUI"] = function()
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
		local slot = _G["Inspect" .. slots[i] .. "Slot"]
		slot:StripTextures()
		slot:SetNormalTexture(0)
		slot.icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])

		slot.bg = CreateFrame("Frame", nil, slot)
		slot.bg:SetAllPoints(slot.icon)
		slot.bg:SetFrameLevel(slot:GetFrameLevel())
		slot.bg:CreateBorder()
	end
end
