local K, C = unpack(KkthnxUI)
local Module = K:GetModule("ActionBar")

local table_insert = table.insert
local margin, padding = C.Bars.BarMargin, C.Bars.BarPadding

-- Number of stance slots (default to 10 if not defined)
local num = NUM_STANCE_SLOTS or 10

function Module:UpdateStanceBar()
	-- Check if the player is in combat
	if InCombatLockdown() then return end

	-- Get the stance bar frame
	local frame = _G["KKUI_ActionBarStance"]
	if not frame then return end

	-- Get the size, font size, and number of buttons per row for the stance bar
	local size = C["ActionBar"].BarStanceSize
	local fontSize = C["ActionBar"].BarStanceFont
	local perRow = C["ActionBar"].BarStancePerRow

	-- Calculate the number of columns and rows required for the buttons
	local column = math.min(num, perRow)
	local rows = math.ceil(num / perRow)
	local buttons = frame.buttons

	local button, buttonX, buttonY

	-- Iterate through all buttons
	for i = 1, num do
		button = buttons[i]
		-- check if the button is defined
		if not button then break end
		-- Set the size of the button
		button:SetSize(size, size)
		-- Calculate the position of the button
		buttonX = ((i - 1) % perRow) * (size + margin) + padding
		buttonY = math.floor((i - 1) / perRow) * (size + margin) + padding
		-- Clear any previous position and set the new position
		button:ClearAllPoints()
		button:SetPoint("TOPLEFT", frame, "TOPLEFT", buttonX, -buttonY)
		-- Update the font size of the button
		Module:UpdateFontSize(button, fontSize)
	end

	-- Set the width and height of the frame based on the number of columns and rows
	frame:SetWidth(column * size + (column - 1) * margin + 2 * padding)
	frame:SetHeight(size * rows + (rows - 1) * margin + 2 * padding)
	-- Set the size of the mover
	frame.mover:SetSize(size, size)
end

function Module:CreateStancebar()
	if not C["ActionBar"].StanceBar then return end

	local buttonList = {}
	local frame = CreateFrame("Frame", "KKUI_ActionBarStance", UIParent, "SecureHandlerStateTemplate")
	frame.mover = K.Mover(frame, "StanceBar", "StanceBar", { "BOTTOMLEFT", _G.KKUI_ActionBar3, "TOPLEFT", 0, margin })
	Module.movers[8] = frame.mover

	-- StanceBar
	StanceBarFrame:SetParent(frame)
	StanceBarFrame:EnableMouse(false)
	StanceBarLeft:SetTexture(nil)
	StanceBarMiddle:SetTexture(nil)
	StanceBarRight:SetTexture(nil)

	for i = 1, num do
		local button = _G["StanceButton" .. i]
		table_insert(buttonList, button)
		table_insert(Module.buttons, button)
	end

	frame.buttons = buttonList

	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)
end
