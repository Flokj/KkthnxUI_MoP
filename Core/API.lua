local K, C = KkthnxUI[1], KkthnxUI[2]

--[[
    KkthnxUI API (Application Programming Interface)
    is a set of functions and tools designed to help developers interact with and extend the KkthnxUI user interface.
    The API provides developers with access to various features and functions of KkthnxUI,
    allowing them to customize and extend the user interface in new and unique ways.
    Whether you're building an addon, developing a plugin, or just looking to customize your KkthnxUI experience,
    the API provides a powerful set of tools to help you achieve your goals.
]]

local getmetatable, select, unpack = getmetatable, select, unpack
local math_min, math_max, math_pi = math.min, math.max, math.pi
local CreateFrame, EnumerateFrames = CreateFrame, EnumerateFrames
local C_AddOns_GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local RegisterStateDriver, UIParent = RegisterStateDriver, UIParent

local CustomCloseButton = "Interface\\AddOns\\KkthnxUI\\Media\\Textures\\CloseButton_32"

-- Utility Functions
local function rad(degrees)
	return degrees * math_pi / 180
end

-- Frame Hiders
do
	BINDING_HEADER_KKTHNXUI = C_AddOns_GetAddOnMetadata(..., "Title")

	K.UIFrameHider = CreateFrame("Frame", nil, UIParent)
	K.UIFrameHider:SetPoint("BOTTOM")
	K.UIFrameHider:SetSize(1, 1)
	K.UIFrameHider:Hide()

	K.PetBattleFrameHider = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
	K.PetBattleFrameHider:SetFrameStrata("LOW")
	RegisterStateDriver(K.PetBattleFrameHider, "visibility", "[petbattle] hide; show")
end

-- Set Border Color
do
	function K.SetBorderColor(self)
		-- Prevent issues related to invalid inputs or configurations
		if not self or type(self) ~= "table" or not self.SetVertexColor then
			return
		end

		local colorTextures = C["General"].ColorTextures
		local texturesColor = C["General"].TexturesColor

		if colorTextures and texturesColor and #texturesColor == 3 then
			-- Ensure each color component is within the valid range
			local r = math_min(math_max(texturesColor[1], 0), 1)
			local g = math_min(math_max(texturesColor[2], 0), 1)
			local b = math_min(math_max(texturesColor[3], 0), 1)

			self:SetVertexColor(r, g, b)
		else
			self:SetVertexColor(1, 1, 1) -- Default color
		end
	end
end

-- Create Border
local function CreateBorder(bFrame, ...)
	if not bFrame or type(bFrame) ~= "table" then
		return nil, "Invalid frame provided"
	end

	-- Return early if border already exists
	if bFrame.KKUI_Border then
		return bFrame
	end

	-- Additional check for other border-related properties that might indicate it's already been processed
	if bFrame.KKUI_Background or bFrame.KKUI_Backdrop then
		return bFrame
	end

	-- Check if we're being called with no arguments (which might indicate a loop)
	local argCount = select("#", ...)
	if argCount == 0 then
		-- Add a small delay to prevent infinite loops
		if bFrame._lastCreateBorderCall and (GetTime() - bFrame._lastCreateBorderCall) < 0.1 then
			return bFrame
		end
		bFrame._lastCreateBorderCall = GetTime()
	end

	local bSubLevel, bLayer, bSize, bTexture, bOffset, bColor, bgTexture, bgSubLevel, bgLayer, bgPoint, bgColor = ...
	local General, Media = C.General, C.Media
	local BorderValue = General.BorderStyle.Value or "KkthnxUI"
	local BorderSize = bSize or K.BorderSize or (BorderValue == "KkthnxUI" and 12 or 10)

	-- Create border with correct parameter order (drawLayer, drawSubLevel)
	-- Use K.CreateBorder directly to avoid recursion
	local kkui_border = K.CreateBorder(bFrame, bSubLevel or "OVERLAY", bLayer or 1)
	if not kkui_border then
		return nil, "Failed to create border"
	end

	local BorderTexture = bTexture or ("Interface\\AddOns\\KkthnxUI\\Media\\Border\\" .. BorderValue .. "\\Border.tga")
	local BorderOffset = bOffset or -4
	local BorderColor = bColor or Media.Borders.ColorBorder

	kkui_border:SetSize(BorderSize)
	kkui_border:SetTexture(BorderTexture)
	kkui_border:SetOffset(BorderOffset)

	-- Safe color unpacking with fallback
	local colorToUse = (General.ColorTextures and General.TexturesColor) or BorderColor
	if colorToUse and type(colorToUse) == "table" then
		local r, g, b = unpack(colorToUse)
		kkui_border:SetVertexColor(r or 1, g or 1, b or 1)
	else
		kkui_border:SetVertexColor(1, 1, 1) -- Default white
	end

	bFrame.KKUI_Border = kkui_border

	if not bFrame.KKUI_Background then
		local BackgroundTexture = bgTexture or Media.Textures.White8x8Texture
		local BackgroundSubLevel = bgSubLevel or "BACKGROUND"
		local BackgroundLayer = bgLayer or -2
		local BackgroundPoint = bgPoint or 0
		local BackgroundColor = bgColor or Media.Backdrops.ColorBackdrop

		local kkui_background = bFrame:CreateTexture(nil, BackgroundSubLevel, nil, BackgroundLayer)
		kkui_background:SetTexture(BackgroundTexture, true, true)
		kkui_background:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])
		kkui_background:SetPoint("TOPLEFT", bFrame, "TOPLEFT", BackgroundPoint, -BackgroundPoint)
		kkui_background:SetPoint("BOTTOMRIGHT", bFrame, "BOTTOMRIGHT", -BackgroundPoint, BackgroundPoint)
		kkui_background:SetVertexColor(unpack(BackgroundColor))

		bFrame.KKUI_Background = kkui_background
	end

	return bFrame
end

-- Create Backdrop
local function CreateBackdrop(bFrame, ...)
	-- Validate the frame parameter
	if not bFrame or type(bFrame) ~= "table" then
		return nil, "Invalid frame provided"
	end

	-- Unpack parameters with default values
	local bPointa, bPointb, bPointc, bPointd, bSubLevel, bLayer, bSize, bTexture, bOffset, bColor, bAlpha, bgTexture, bgSubLevel, bgLayer, bgPoint, bgColor = ...

	-- Create background if it doesn't exist
	if not bFrame.KKUI_Background then
		-- Assign default values if not provided
		local BorderPoints = {
			bPointa or 0,
			bPointb or 0,
			bPointc or 0,
			bPointd or 0,
		}

		local kkui_backdrop = CreateFrame("Frame", "$parentBackdrop", bFrame, "BackdropTemplate")
		kkui_backdrop:SetPoint("TOPLEFT", bFrame, "TOPLEFT", BorderPoints[1], BorderPoints[2])
		kkui_backdrop:SetPoint("BOTTOMRIGHT", bFrame, "BOTTOMRIGHT", BorderPoints[3], BorderPoints[4])

		-- Ensure CreateBorder function exists and is callable
		if type(kkui_backdrop.CreateBorder) == "function" then
			kkui_backdrop:CreateBorder(bSubLevel, bLayer, bSize, bTexture, bOffset, bColor, bAlpha, bgTexture, bgSubLevel, bgLayer, bgPoint, bgColor)
		end

		kkui_backdrop:SetFrameLevel(max(0, bFrame:GetFrameLevel() - 1))

		bFrame.KKUI_Backdrop = kkui_backdrop
	end

	return bFrame
end

-- Create Shadow
local function CreateShadow(frame, useBackdrop)
	-- Validate the frame
	if not frame or type(frame) ~= "table" then
		return nil, "Invalid frame provided"
	end

	-- Check if the shadow already exists; if so, return
	if frame.Shadow then
		return frame.Shadow
	end

	-- Get the parent frame if the passed object is a texture
	local parentFrame = frame:IsObjectType("Texture") and frame:GetParent() or frame

	-- Create the shadow frame using the BackdropTemplate
	local shadow = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")

	-- Set the position and size of the shadow frame
	shadow:SetPoint("TOPLEFT", frame, -3, 3)
	shadow:SetPoint("BOTTOMRIGHT", frame, 3, -3)

	-- Define the backdrop of the shadow frame
	local backdrop = {
		edgeFile = C["Media"].Textures.GlowTexture,
		edgeSize = 3,
	}

	-- Include additional backdrop settings if requested
	if useBackdrop then
		backdrop.bgFile = C["Media"].Textures.White8x8Texture
		backdrop.insets = { left = 3, right = 3, top = 3, bottom = 3 }
	end

	-- Set the backdrop of the shadow frame
	shadow:SetBackdrop(backdrop)

	-- Set the frame level of the shadow frame to be one lower than the parent frame
	shadow:SetFrameLevel(max(parentFrame:GetFrameLevel() - 1, 0))

	-- Set the background and border color of the shadow frame based on the 'useBackdrop' argument
	if useBackdrop then
		shadow:SetBackdropColor(unpack(C["Media"].Backdrops.ColorBackdrop))
	end
	shadow:SetBackdropBorderColor(0, 0, 0, 0.8)

	-- Save the shadow frame as a property of the parent frame
	frame.Shadow = shadow

	-- Return the created shadow frame
	return shadow
end

-- Kill Function
local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
		object:SetParent(K.UIFrameHider)
	else
		object.Show = object.Hide
	end
	object:Hide()
end

-- Strip Textures
local blizzTextures = {
	"Inset",
	"inset",
	"InsetFrame",
	"LeftInset",
	"RightInset",
	"NineSlice",
	"BG",
	"border",
	"Border",
	"Background",
	"BorderFrame",
	"bottomInset",
	"BottomInset",
	"bgLeft",
	"bgRight",
	"Portrait",
	"portrait",
	"ScrollFrameBorder",
	"ScrollUpBorder",
	"ScrollDownBorder",
}

local function StripTextures(object, kill)
	local frameName = object.GetName and object:GetName()

	-- Strip textures from Blizzard frames
	for _, texture in pairs(blizzTextures) do
		local blizzFrame = object[texture] or (frameName and _G[frameName .. texture])
		if blizzFrame then
			StripTextures(blizzFrame, kill) -- Recursively strip textures from Blizzard frames
		end
	end

	-- Strip textures from the given object's regions
	if object.GetNumRegions then -- Check if the given object has regions
		for i = 1, object:GetNumRegions() do -- Iterate through all regions
			local region = select(i, object:GetRegions()) -- Get region at index i

			-- Check if region is a Texture type
			if region and region.IsObjectType and region:IsObjectType("Texture") and not region.isIgnored then
				if kill and type(kill) == "boolean" then -- Kill the texture if boolean true is passed as kill argument
					region:Kill()
				elseif tonumber(kill) then -- Set alpha to 0 for specified texture index
					if kill == 0 then
						region:SetAlpha(0)
					elseif i ~= kill then -- Set texture to empty string for all other indices
						region:SetTexture("")
					end
				else -- Set texture to empty string by default
					region:SetTexture("")
				end
			end
		end
	end
end

-- Style Button
local function StyleButton(button, noHover, noPushed, noChecked, noCooldown)
	-- Create highlight texture for the button if it does not exist
	if button.SetHighlightTexture and not noHover then
		button:SetHighlightTexture(button:IsObjectType("CheckButton") and "Interface\\Buttons\\CheckButtonHilight" or "Interface\\Buttons\\ButtonHilight-Square")
		button:GetHighlightTexture():SetBlendMode("ADD")
		button:GetHighlightTexture():SetAllPoints()
	end

	-- Create pushed texture for the button if it does not exist
	if button.SetPushedTexture and not noPushed then
		button:SetPushedTexture("Interface\\Buttons\\CheckButtonHilight")
		button:GetPushedTexture():SetBlendMode("ADD")
		button:GetPushedTexture():SetAllPoints()
	end

	-- Create checked texture for the button if it does not exist
	if button.SetCheckedTexture and not noChecked then
		button:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
		button:GetCheckedTexture():SetBlendMode("ADD")
		button:GetCheckedTexture():SetAllPoints()
	end

	-- Adjust cooldown texture if it exists
	local name = button.GetName and button:GetName()
	local cooldown = name and _G[name .. "Cooldown"]

	if cooldown and not noCooldown then
		cooldown:ClearAllPoints()
		cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
		cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
		cooldown:SetDrawEdge(false)
		cooldown:SetSwipeColor(0, 0, 0, 1)
	end
end

-- Button OnEnter and OnLeave
local function Button_OnEnter(self)
	if not self:IsEnabled() then
		return
	end

	self.KKUI_Border:SetVertexColor(102 / 255, 157 / 255, 255 / 255)
end

local function Button_OnLeave(self)
	K.SetBorderColor(self.KKUI_Border)
end

-- Skin Button
local blizzRegions = {
	"Left",
	"Middle",
	"Right",
	"TopLeft",
	"TopRight",
	"BottomLeft",
	"BottomRight",
	"Background",
	"Border",
	"Center",
}

local function SkinButton(self, override, ...)
	local bSubLevel, bLayer, bSize, bTexture, bOffset, bColor, bgTexture, bgSubLevel, bgLayer, bgPoint, bgColor = ...
	-- Remove the normal, highlight, pushed and disabled textures
	if self.SetNormalTexture and not override then
		self:SetNormalTexture(0)
	end

	if self.SetHighlightTexture then
		self:SetHighlightTexture(0)
	end

	if self.SetPushedTexture then
		self:SetPushedTexture(0)
	end

	if self.SetDisabledTexture then
		self:SetDisabledTexture(0)
	end

	-- Hide all regions defined in the blizzRegions table
	for _, region in pairs(blizzRegions) do
		if self[region] then
			self[region]:SetAlpha(0)
			self[region]:Hide()
		end
	end

	-- Do not apply custom border if the override argument is true
	self:CreateBorder(bSubLevel, bLayer, bSize, bTexture, bOffset, bColor, bgTexture, bgSubLevel, bgLayer, bgPoint, bgColor)

	-- Hook the OnEnter and OnLeave events
	self:HookScript("OnEnter", Button_OnEnter)
	self:HookScript("OnLeave", Button_OnLeave)
end

-- Applies custom skinning to a close button with optional positioning and sizing
local function SkinCloseButton(self, parent, xOffset, yOffset, size)
	parent = parent or self:GetParent()
	xOffset = xOffset or -6
	yOffset = yOffset or -6
	size = size or 16

	if not parent then
		print("Warning: No valid parent frame for SkinCloseButton")
		return
	end

	self:SetSize(size, size)
	self:ClearAllPoints()
	self:SetPoint("TOPRIGHT", parent, "TOPRIGHT", xOffset, yOffset)

	self:StripTextures()
	if self.Border then
		self.Border:SetAlpha(0)
	end

	self:CreateBorder(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, { 0.85, 0.25, 0.25 })
	self:StyleButton()

	self:SetDisabledTexture("")
	local dis = self:GetDisabledTexture()
	if dis then
		dis:SetVertexColor(0, 0, 0, 0.4)
		dis:SetDrawLayer("OVERLAY")
		dis:SetAllPoints()
	end

	local tex = self.__texture or self:CreateTexture()
	tex:SetTexture(CustomCloseButton)
	tex:SetAllPoints()
	self.__texture = tex
end

-- Skin CheckBox
local function SkinCheckBox(self, forceSaturation)
	self:SetNormalTexture(0)
	self:SetPushedTexture(0)

	local bg = CreateFrame("Frame", nil, self, "BackdropTemplate")
	bg:SetAllPoints(self)
	bg:SetFrameLevel(self:GetFrameLevel())
	bg:CreateBorder(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, { 0.20, 0.20, 0.20 })
	self.bg = bg

	self.forceSaturation = forceSaturation
end

local function SkinEditBox(frame, width, height)
	frame:DisableDrawLayer("BACKGROUND")

	frame:CreateBackdrop()

	local frameName = frame.GetName and frame:GetName()
	if frameName and (frameName:find("Gold") or frameName:find("Silver") or frameName:find("Copper")) then
		if frameName:find("Gold") then
			frame.KKUI_Backdrop:SetPoint("TOPLEFT", -3, 1)
			frame.KKUI_Backdrop:SetPoint("BOTTOMRIGHT", -3, 0)
		else
			frame.KKUI_Backdrop:SetPoint("TOPLEFT", -3, 1)
			frame.KKUI_Backdrop:SetPoint("BOTTOMRIGHT", -13, 0)
		end
	end

	if width then
		frame:SetWidth(width)
	end

	if height then
		frame:SetHeight(height)
	end
end

-- Hide Backdrop
local function HideBackdrop(self)
	if self.NineSlice then
		self.NineSlice:SetAlpha(0)
	end

	if self.SetBackdrop then
		self:SetBackdrop(nil)
	end
end

-- Setup Arrow
local arrowDegree = {
	["up"] = 0,
	["down"] = 180,
	["left"] = 90,
	["right"] = -90,
}

function K.SetupArrow(self, direction)
	self:SetTexture(C["Media"].Textures.ArrowTexture)
	self:SetRotation(rad(arrowDegree[direction]))
end

-- Reskin Arrow
function K.ReskinArrow(self, direction, border)
	if border == nil or border == "" then
		border = true
	end

	self:StripTextures()
	self:SetSize(16, 16)
	if border then
		self:CreateBorder(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, { 0.20, 0.20, 0.20 })
		self:StyleButton()
	end

	self:SetDisabledTexture("Interface\\ChatFrame\\ChatFrameBackground")
	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, 0.3)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local tex = self:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints()
	K.SetupArrow(tex, direction)
	self.__texture = tex
end

-- Grab ScrollBar Element
local function GrabScrollBarElement(frame, element)
	local frameName = frame:GetDebugName()
	return frame[element] or frameName and (_G[frameName .. element] or string.find(frameName, element)) or nil
end

-- Skin ScrollBar (continued)
local function SkinScrollBar(self)
	-- Strip the textures from the parent and scrollbar frame
	self:GetParent():StripTextures()
	self:StripTextures()

	-- Get the thumb texture and set its alpha to 0, width to 16, and create a frame for it
	local thumb = GrabScrollBarElement(self, "ThumbTexture") or GrabScrollBarElement(self, "thumbTexture") or self.GetThumbTexture and self:GetThumbTexture()
	if thumb then
		thumb:SetAlpha(0)
		thumb:SetWidth(16)
		self.thumb = thumb

		local bg = CreateFrame("Frame", nil, self)
		-- Create a border for the frame with a dark grey color
		bg:CreateBorder(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, { 0.20, 0.20, 0.20 })

		-- Set the position of the frame relative to the thumb texture
		bg:SetPoint("TOPLEFT", thumb, 0, -6)
		bg:SetPoint("BOTTOMRIGHT", thumb, 0, 6)

		-- Assign the frame to the thumb texture's background property
		thumb.bg = bg
	end

	-- Get the up and down arrows from the scrollbar frame and skin them with K.ReskinArrow() function
	local up, down = self:GetChildren()
	K.ReskinArrow(up, "up")
	K.ReskinArrow(down, "down")
end

-- Add API Function
local function addapi(object)
	local mt = getmetatable(object).__index

	if not mt.CreateBorder then
		mt.CreateBorder = CreateBorder
	end
	if not mt.CreateBackdrop then
		mt.CreateBackdrop = CreateBackdrop
	end
	if not mt.CreateShadow then
		mt.CreateShadow = CreateShadow
	end
	if not mt.Kill then
		mt.Kill = Kill
	end
	if not mt.SkinButton then
		mt.SkinButton = SkinButton
	end
	if not mt.StripTextures then
		mt.StripTextures = StripTextures
	end
	if not mt.StyleButton then
		mt.StyleButton = StyleButton
	end
	if not mt.SkinCloseButton then
		mt.SkinCloseButton = SkinCloseButton
	end
	if not mt.SkinCheckBox then
		mt.SkinCheckBox = SkinCheckBox
	end
	if not mt.SkinEditBox then
		mt.SkinEditBox = SkinEditBox
	end
	if not mt.SkinScrollBar then
		mt.SkinScrollBar = SkinScrollBar
	end
	if not mt.HideBackdrop then
		mt.HideBackdrop = HideBackdrop
	end
end

-- Apply API to Existing Frames
local handled = { Frame = true }
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())
addapi(object:CreateMaskTexture())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

addapi(_G.GameFontNormal) -- Add API to `CreateFont` objects without actually creating one
addapi(CreateFrame("ScrollFrame")) -- Hacky fix for issue on 7.1 PTR where scroll frames no longer seem to inherit the methods from the 'Frame' widget
