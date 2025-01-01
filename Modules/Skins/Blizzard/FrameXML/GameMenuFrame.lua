local K, C = KkthnxUI[1], KkthnxUI[2]

local table_insert = table.insert

table_insert(C.defaultThemes, function()
	if not C["Skins"].BlizzardFrames then return end

	GameMenuFrameHeader:StripTextures()
	GameMenuFrameHeader:ClearAllPoints()
	GameMenuFrameHeader:SetPoint("TOP", GameMenuFrame, 0, 7)
	GameMenuFrame:StripTextures()
	GameMenuFrame:CreateBorder(nil, nil, C["General"].BorderStyle.Value ~= "KkthnxUI_Pixel" and 32 or nil, nil, C["General"].BorderStyle.Value ~= "KkthnxUI_Pixel" and -10 or nil)
	--GameMenuFrameBorder:Hide()

	local buttons = {
		GameMenuButtonHelp,
		GameMenuButtonWhatsNew,
		GameMenuButtonStore,
		GameMenuButtonOptions,
		GameMenuButtonUIOptions,
		GameMenuButtonKeybindings,
		GameMenuButtonMacros,
		GameMenuButtonAddons,
		GameMenuButtonLogout,
		GameMenuButtonQuit,
		GameMenuButtonContinue,
		KKUI_GameMenuFrame,
	}

	for _, button in next, buttons do
		button:SkinButton(true)
	end

	GameMenuButtonLogoutText:SetTextColor(1, 1, 0)
	GameMenuButtonQuitText:SetTextColor(1, 0, 0)
	GameMenuButtonContinueText:SetTextColor(0, 1, 0)

	-- ScriptErrorsFrame
	ScriptErrorsFrame:SetScale(UIParent:GetScale())

	-- TicketStatusFrame
	TicketStatusFrameButton:StripTextures()
	TicketStatusFrameButton:SkinButton()
end)
