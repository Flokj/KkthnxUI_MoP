local K, C = unpack(KkthnxUI)
local Module = K:GetModule("Miscellaneous")

-- Add Helm/Cloak button
function Module:CreateHelmCloakToggle()
	if not C["Misc"].HelmCloakToggle then return end

	local HelmButton
	local CloakButton

	function HelmToggle()
		ShowHelm(not ShowingHelm())
	end

	function CloakToggle()
		ShowCloak(not ShowingCloak())
	end

	function CreateButton(icon_on, help, toggle, ...)
		local button = CreateFrame("BUTTON", nil, CharacterModelFrame)
		local hilite = button:CreateTexture(nil, "HIGHLIGHT")
		hilite:SetAllPoints()
		hilite:SetTexture("Interface\\Common\\UI-ModelControlPanel")
		hilite:SetTexCoord(0.57812500, 0.82812500, 0.00781250, 0.13281250)
		button:SetWidth(28)
		button:SetHeight(28)
		button:SetPoint(...)
		button:Hide()
		button:SetNormalTexture(icon_on)
		button:RegisterEvent("PLAYER_FLAGS_CHANGED")
		button:RegisterEvent("PLAYER_ENTERING_WORLD")
		button:SetScript("OnEvent", update)
		button:SetScript("OnClick", function()
			toggle()
		end)
		button:SetScript("OnEnter", function()
			button:SetAlpha(1)
			GameTooltip:SetOwner(button, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(help, nil, nil, nil, nil, 1)
		end)
		button:SetScript("OnLeave", function()
			button:SetAlpha(0.5)
			GameTooltip_Hide()
			HelmButton:Hide()
			CloakButton:Hide()
		end)
		button:SetAlpha(0.5)
		CharacterModelFrame:HookScript("OnEnter", function()
			button:Show()
		end)
		CharacterModelFrame:HookScript("OnLeave", function(self)
			if not self:IsMouseOver() then
				button:Hide()
			end
		end)
		return button
	end

	HelmButton = CreateButton("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\HelmShow", SHOW_HELM, HelmToggle, "BOTTOMLEFT", 5, 35)
	CloakButton = CreateButton("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\CloakShow", SHOW_CLOAK, CloakToggle, "BOTTOMRIGHT", -5, 35)
end
Module:RegisterMisc("HelmCloakToggle", Module.CreateHelmCloakToggle)