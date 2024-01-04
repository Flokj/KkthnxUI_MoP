local K, C = unpack(KkthnxUI)
local Module = K:GetModule("Bags")

local ipairs = ipairs
local tinsert = tinsert
local hooksecurefunc = hooksecurefunc

local CreateFrame = CreateFrame
local MainMenuBarBackpackButton = MainMenuBarBackpackButton
local MainMenuBarBackpackButtonCount = MainMenuBarBackpackButtonCount
local NUM_BAG_FRAMES = NUM_BAG_FRAMES or 4
local RegisterStateDriver = RegisterStateDriver
local UIParent = UIParent

local buttonPosition
local bagBar
local buttonList = {}

function Module:BagBar_OnEnter()
	return C["Inventory"].BagBarMouseover and UIFrameFadeIn(bagBar, 0.2, bagBar:GetAlpha(), 1)
end

function Module:BagBar_OnLeave()
	return C["Inventory"].BagBarMouseover and UIFrameFadeOut(bagBar, 0.2, bagBar:GetAlpha(), 0)
end

function Module:SkinBag(bag)
	local icon = bag.icon or _G[bag:GetName() .. "IconTexture"]
	bag.oldTex = icon:GetTexture()

	bag.IconBorder:SetAlpha(0)
	bag:StripTextures()
	bag:CreateBorder()

	icon:SetAllPoints()
	icon:SetTexture(bag.oldTex == 1721259 and "Interface\\AddOns\\KkthnxUI\\Media\\Inventory\\Backpack.tga" or bag.oldTex)
	icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])
end

function Module:SizeAndPositionBagBar()
	local bagBar = _G.KKUI_BagBar
	if not bagBar then
		return
	end

	bagBar:SetAlpha(C["Inventory"].BagBarMouseover and 0 or 1)

	for i, button in ipairs(buttonList) do
		local prevButton = buttonList[i - 1]
		button:SetSize(30, 30)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint("RIGHT", bagBar, "RIGHT", 0, 0)
		elseif prevButton then
			button:SetPoint("RIGHT", prevButton, "LEFT", -6, 0)
		end
	end
end

function Module:CreateInventoryBar()
	if not C["ActionBar"].Enable then return end
	if not C["Inventory"].BagBar then return end

	local bagBar = CreateFrame("Frame", "KKUI_BagBar", UIParent)
	bagBar:SetSize(174, 30)
	if C["ActionBar"].MicroBar then
		buttonPosition = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 38 }
	else
		buttonPosition = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 4 }
	end
	bagBar:SetScript("OnEnter", Module.BagBar_OnEnter)
	bagBar:SetScript("OnLeave", Module.BagBar_OnLeave)

	local backpackButton = MainMenuBarBackpackButton
	backpackButton:SetParent(bagBar)
	backpackButton:ClearAllPoints()
	backpackButton.Count:ClearAllPoints()
	backpackButton.Count:SetPoint("BOTTOMRIGHT", backpackButton, "BOTTOMRIGHT", -1, 4)
	backpackButton.Count:SetFontObject(K.UIFontOutline)
	backpackButton:HookScript("OnEnter", Module.BagBar_OnEnter)
	backpackButton:HookScript("OnLeave", Module.BagBar_OnLeave)

	tinsert(buttonList, backpackButton)
	Module:SkinBag(backpackButton)

	for i = 0, NUM_BAG_FRAMES - 1 do
		local b = _G["CharacterBag" .. i .. "Slot"]
		b:SetParent(bagBar)
		b:HookScript("OnEnter", Module.BagBar_OnEnter)
		b:HookScript("OnLeave", Module.BagBar_OnLeave)

		Module:SkinBag(b)
		tinsert(buttonList, b)
	end

	Module:SizeAndPositionBagBar()
	K.Mover(bagBar, "BagBar", "BagBar", buttonPosition)
	K:RegisterEvent("BAG_SLOT_FLAGS_UPDATED", Module.SizeAndPositionBagBar)
end
