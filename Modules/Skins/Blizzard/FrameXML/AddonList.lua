local K, C = KkthnxUI[1], KkthnxUI[2]

tinsert(C.defaultThemes, function()
	if not C["Skins"].BlizzardFrames then return end

	local buttons = {
		"AddonListEnableAllButton",
		"AddonListDisableAllButton",
		"AddonListCancelButton",
		"AddonListOkayButton"
	}

	for _, button in pairs(buttons) do
		_G[button]:SkinButton()
	end

	AddonList:StripTextures()
	AddonList:CreateBorder()

	AddonListScrollFrame:StripTextures()
	AddonListScrollFrameScrollBar:SkinScrollBar()

	AddonListCloseButton:SkinCloseButton()
end)