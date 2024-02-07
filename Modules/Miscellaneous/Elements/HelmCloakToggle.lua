local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Miscellaneous")

-- Add Helm/Cloak button
function Module:CreateHelmCloakToggle()
	if not C["Misc"].HelmCloakToggle then return end

	local function CreateCheckbox(parent, text, showFunc, toggleFunc, pointY)
	    local checkbox = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
	    checkbox:SetPoint("BOTTOMLEFT", 70, 160 - pointY)
	    checkbox:SetSize(16, 16)
	    checkbox:SetFrameStrata("HIGH")
	    checkbox:SkinCheckBox()
	    checkbox:SetAlpha(0.25)
	
	    local checkboxText = checkbox:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	    checkboxText:SetText(text)
	    checkboxText:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
	    checkbox:SetHitRectInsets(3, -checkboxText:GetStringWidth(), 0, 0)
	
	    checkbox:HookScript("OnEnter", function(self)
	        UIFrameFadeIn(self, 0.25, self:GetAlpha(), 1)
	    end)
	
	    checkbox:HookScript("OnLeave", function(self)
	        UIFrameFadeOut(self, 1, self:GetAlpha(), 0.25)
	    end)
	
	    checkbox:HookScript("OnClick", function(self)
	        self:Disable()
	        self:SetAlpha(1.0)
	        C_Timer.After(0.5, function()
	            toggleFunc()
	            self:Enable()
	            if not self:IsMouseOver() then
	                self:SetAlpha(0.25)
	            end
	        end)
	    end)
	
	    checkbox:HookScript("OnShow", function()
	        checkbox:SetChecked(showFunc())
	    end)
	
	    return checkbox
	end
	
	local function UpdateHelm()
	    ShowHelm(not ShowingHelm())
	end
	
	local function UpdateCloak()
	    ShowCloak(not ShowingCloak())
	end
	
	local PaperDollFrame = _G["PaperDollFrame"]
	
	local checkboxes = {}
	checkboxes[1] = CreateCheckbox(PaperDollFrame, "Helm", ShowingHelm, UpdateHelm, 0)
	checkboxes[2] = CreateCheckbox(PaperDollFrame, "Cloak", ShowingCloak, UpdateCloak, 20)
end

Module:RegisterMisc("HelmCloakToggle", Module.CreateHelmCloakToggle)