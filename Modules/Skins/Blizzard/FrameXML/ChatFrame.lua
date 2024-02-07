local K, C = KkthnxUI[1], KkthnxUI[2]
local table_insert = table.insert
local hooksecurefunc = hooksecurefunc

local function SkinChatButton(button, size)
	button:SkinButton()
	button:SetSize(size, size)
	if button.Flash then
		button.Flash:Hide()
	end
end

local function SkinCloseButton(button, size)
	button:SkinCloseButton()
	button:SetSize(size, size)
end

table_insert(C.defaultThemes, function()
	-- Battlenet toast frame
	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetBackdrop(nil)
	BNToastFrame:CreateBorder()

	BNToastFrame.TooltipFrame:HideBackdrop()
	BNToastFrame.TooltipFrame:CreateBorder()

	SkinCloseButton(BNToastFrame.CloseButton, 18)

	local HOME_TEXTURE = "Interface\\Buttons\\UI-HomeButton"

	SkinChatButton(ChatFrameChannelButton, 16)
	SkinChatButton(ChatFrameMenuButton, 16)

	ChatFrameMenuButton:SetNormalTexture(HOME_TEXTURE)
	ChatFrameMenuButton:SetPushedTexture(HOME_TEXTURE)

	VoiceChatChannelActivatedNotification:SetBackdrop(nil)
	VoiceChatChannelActivatedNotification:CreateBorder()
	SkinCloseButton(VoiceChatChannelActivatedNotification.CloseButton, 32)
	VoiceChatChannelActivatedNotification.CloseButton:SetPoint("TOPRIGHT", 4, 4)
end)
