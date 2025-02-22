local K = KkthnxUI[1]
local Module = K:GetModule("ActionBar")

local _G = _G
local tinsert = tinsert
local padding = 2

function Module:CreateExtrabar()
	local buttonList = {}
	local size = 52

	-- ExtraActionButton
	local frame = CreateFrame("Frame", "KKUI_ActionBarExtra", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(size + 2 * padding)
	frame:SetHeight(size + 2 * padding)
	frame.mover = K.Mover(frame, "Extrabar", "Extrabar", { "BOTTOM", UIParent, "BOTTOM", -200, 120 })

	ExtraActionBarFrame:EnableMouse(false)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", frame)
	ExtraActionBarFrame.ignoreFramePositionManager = true

	hooksecurefunc(ExtraActionBarFrame, "SetParent", function(self, parent)
		if parent == ExtraAbilityContainer then
			self:SetParent(frame)
		end
	end)

	local button = ExtraActionButton1
	tinsert(buttonList, button)
	tinsert(Module.buttons, button)
	button:SetSize(size, size)

	frame.frameVisibility = "[extrabar] show; hide"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	-- Extra button range, needs review
	hooksecurefunc("ActionButton_UpdateRangeIndicator", function(self, checksRange, inRange)
		if not self.action then return end
		if checksRange and not inRange then
			self.icon:SetVertexColor(0.8, 0.1, 0.1)
		else
			local isUsable, notEnoughMana = IsUsableAction(self.action)
			if isUsable then
				self.icon:SetVertexColor(1, 1, 1)
			elseif notEnoughMana then
				self.icon:SetVertexColor(0.5, 0.5, 1)
			else
				self.icon:SetVertexColor(0.4, 0.4, 0.4)
			end
		end
	end)
end
