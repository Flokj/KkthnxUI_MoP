local K, C = unpack(KkthnxUI)
local Module = K:GetModule("ActionBar")

local _G = _G
local table_insert = _G.table.insert
local margin, padding = C.Bars.BarMargin, C.Bars.BarPadding

-- Number of stance slots (default to 10 if not defined)
local num = NUM_STANCE_SLOTS or 10

function Module:UpdateStanceBar()
	local frame = _G["KKUI_ActionBarStance"]
	if not frame then return end

	local size = C["ActionBar"].BarStanceSize
	local fontSize = C["ActionBar"].BarStanceFont
	local perRow = C["ActionBar"].BarStancePerRow

	for i = 1, num do
		local button = frame.buttons[i]
		button:SetSize(size, size)
		if i < 11 then
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("TOPLEFT", frame, padding, -padding)
			elseif mod(i - 1, perRow) == 0 then
				button:SetPoint("TOP", frame.buttons[i - perRow], "BOTTOM", 0, -margin)
			else
				button:SetPoint("LEFT", frame.buttons[i - 1], "RIGHT", margin, 0)
			end
		end
		Module:UpdateFontSize(button, fontSize)
	end

	local column = math.min(num, perRow)
	local rows = math.ceil(num / perRow)
	frame:SetWidth(column * size + (column - 1) * margin + 2 * padding)
	frame:SetHeight(size * rows + (rows - 1) * margin + 2 * padding)
	frame.mover:SetSize(size, size)
end

function Module:CreateStancebar()
	if not C["ActionBar"].StanceBar then return end

	local buttonList = {}
	local frame = CreateFrame("Frame", "KKUI_ActionBarStance", UIParent, "SecureHandlerStateTemplate")
	frame.mover = K.Mover(frame, "StanceBar", "StanceBar", { "BOTTOMLEFT", _G.KKUI_ActionBar3, "TOPLEFT", 0, margin })
	Module.movers[8] = frame.mover

	-- StanceBar
	_G.StanceBarFrame:SetParent(frame)
	_G.StanceBarFrame:EnableMouse(false)
	_G.StanceBarLeft:SetTexture(nil)
	_G.StanceBarMiddle:SetTexture(nil)
	_G.StanceBarRight:SetTexture(nil)

	for i = 1, num do
		local button = _G["StanceButton" .. i]
		table_insert(buttonList, button)
		table_insert(Module.buttons, button)
	end

	frame.buttons = buttonList

	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)
end
