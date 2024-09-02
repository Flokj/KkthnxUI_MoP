local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Chat")

-- Sourced: NDui (siweia)

local tinsert, pairs = tinsert, pairs
local C_GuildInfo_IsGuildOfficer = C_GuildInfo.IsGuildOfficer

function Module:CreateChatbar()
	if not C["Chat"].Chatbar then return end

	local chatFrame = SELECTED_DOCK_FRAME
	local editBox = chatFrame.editBox
	local width, height, padding, buttonList = 15, 15, 8, {}

	local Chatbar = CreateFrame("Frame", "KkthnxUI_ChatBar", UIParent)
	Chatbar:SetSize(width, height)

	local function AddButton(r, g, b, text, func)
    local bu = CreateFrame("Button", nil, Chatbar, "SecureActionButtonTemplate, BackdropTemplate")
    bu:SetSize(width, height)

    bu:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    bu:SetBackdropColor(r, g, b, 0.9)
    bu:CreateBorder()
    bu:StyleButton()
    bu:SetHitRectInsets(0, 0, -8, -8)
    bu:RegisterForClicks("AnyUp")
    if text then
        bu:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(text)
            GameTooltip:Show()
        end)
        bu:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    end
    if func then bu:SetScript("OnClick", func) end

    tinsert(buttonList, bu)
    return bu
end

	-- Create Chatbars
	local buttonInfo = {
		{1, 1, 1, SAY.."/"..YELL, function(_, btn)
			if btn == "RightButton" then
				ChatFrame_OpenChat("/y ", chatFrame)
			else
				ChatFrame_OpenChat("/s ", chatFrame)
			end
		end},
		{1, .5, 1, WHISPER, function(_, btn)
			if btn == "RightButton" then
				ChatFrame_ReplyTell(chatFrame)
				if not editBox:IsVisible() or editBox:GetAttribute("chatType") ~= "WHISPER" then
					ChatFrame_OpenChat("/w ", chatFrame)
				end
			else
				if UnitExists("target") and UnitName("target") and UnitIsPlayer("target") and GetDefaultLanguage("player") == GetDefaultLanguage("target") then
					local name = GetUnitName("target", true)
					ChatFrame_OpenChat("/w "..name.." ", chatFrame)
				else
					ChatFrame_OpenChat("/w ", chatFrame)
				end
			end
		end},
		{.65, .65, 1, PARTY, function() ChatFrame_OpenChat("/p ", chatFrame) end},
		{1, .5, 0, INSTANCE.."/"..RAID, function()
			if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
				ChatFrame_OpenChat("/i ", chatFrame)
			else
				ChatFrame_OpenChat("/raid ", chatFrame)
			end
		end},
		{.25, 1, .25, GUILD.."/"..OFFICER, function(_, btn)
			if btn == "RightButton" and C_GuildInfo_IsGuildOfficer() then
				ChatFrame_OpenChat("/o ", chatFrame)
			else
				ChatFrame_OpenChat("/g ", chatFrame)
			end
		end},
	}
	for _, info in pairs(buttonInfo) do AddButton(unpack(info)) end

	-- ROLL
	local roll = AddButton(.8, 1, .6, LOOT_ROLL)
	roll:SetAttribute("type", "macro")
	roll:SetAttribute("macrotext", "/roll")

	-- COMBATLOG
	local combat = AddButton(1, 1, 0, BINDING_NAME_TOGGLECOMBATLOG)
	combat:SetAttribute("type", "macro")
	combat:SetAttribute("macrotext", "/combatlog")

	--[[ RELOAD
	local reload = AddButton(1, .3, .1, "RELOAD")
	reload:SetAttribute("type", "macro")
	reload:SetAttribute("macrotext", "/reload")]]

	-- Order Postions
	for i = 1, #buttonList do
    	if i == 1 then
        	buttonList[i]:SetPoint("TOP")
    	else
        	buttonList[i]:SetPoint("TOP", buttonList[i-1], "BOTTOM", 0, -padding)
    	end
	end

	-- Mover
	local height = (#buttonList - 1) * (padding + height) + height
	local mover = K.Mover(Chatbar, "Chatbar", "Chatbar", {"TOPLEFT", UIParent, "BOTTOMLEFT", 440, 215}, width + 8, height + 8)
	Chatbar:ClearAllPoints()
	Chatbar:SetPoint("TOPLEFT", mover, 5, -5)
end