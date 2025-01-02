local K, C = KkthnxUI[1], KkthnxUI[2]

local function handleSpellButton(self)
	if SpellBookFrame.bookType == BOOKTYPE_PROFESSION then return end

	local slot, slotType = SpellBook_GetSpellBookSlot(self)
	local isPassive = IsPassiveSpell(slot, SpellBookFrame.bookType)
	local name = self:GetName()
	local highlightTexture = _G[name.."Highlight"]
	if isPassive then
		highlightTexture:SetColorTexture(1, 1, 1, 0)
	else
		highlightTexture:SetColorTexture(1, 1, 1, .25)
	end

	local subSpellString = _G[name.."SubSpellName"]
	local isOffSpec = self.offSpecID ~= 0 and SpellBookFrame.bookType == BOOKTYPE_SPELL
	subSpellString:SetTextColor(1, 1, 1)

	if slotType == "FUTURESPELL" then
		local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
		if level and level > UnitLevel("player") then
			self.SpellName:SetTextColor(.7, .7, .7)
			subSpellString:SetTextColor(.7, .7, .7)
		end
	else
		if slotType == "SPELL" and isOffSpec then
			subSpellString:SetTextColor(.7, .7, .7)
		end
	end
	self.RequiredLevelString:SetTextColor(.7, .7, .7)

	local ic = _G[name.."IconTexture"]
	if ic.bg then
		ic.bg:SetShown(ic:IsShown())
	end

	if self.ClickBindingIconCover and self.ClickBindingIconCover:IsShown() then
		self.SpellName:SetTextColor(.7, .7, .7)
	end
end

tinsert(C.defaultThemes, function()
	if not C["Skins"].BlizzardFrames then
		return
	end

	for i = 1, SPELLS_PER_PAGE do
		local bu = _G["SpellButton" .. i]
		local ic = _G["SpellButton" .. i .. "IconTexture"]

		bu:StripTextures("")
		bu:DisableDrawLayer("BACKGROUND")
		bu:StyleButton()

		ic:SetTexCoord(0.08, 0.92, 0.08, 0.92)

		if not bu.__bg then
			bu.__bg = CreateFrame("Frame", nil, bu, "BackdropTemplate")
			bu.__bg:SetAllPoints(bu)
			bu.__bg:SetFrameLevel(bu:GetFrameLevel())
			bu.__bg:CreateBorder(nil, nil, nil, nil, nil, nil, K.MediaFolder .. "Skins\\UI-Spellbook-SpellBackground", nil, nil, nil, { 1, 1, 1 })
		end
		hooksecurefunc(bu, "UpdateButton", handleSpellButton)
	end	
end)
