local K = KkthnxUI[1]
local Module = K:GetModule("ActionBar")

local next = next

local scripts = {
	"OnShow",
	"OnHide",
	"OnEvent",
	"OnEnter",
	"OnLeave",
	"OnUpdate",
	"OnValueChanged",
	"OnClick",
	"OnMouseDown",
	"OnMouseUp",
}

local framesToHide = {
	MainMenuBar,
	MultiBarBottomLeft,
	MultiBarBottomRight,
	MultiBarLeft,
	MultiBarRight,
	MultiBar5,
	MultiBar6,
	MultiBar7,
	OverrideActionBar,
	PossessActionBar,
	PetActionBar,
	StanceBar,
	StatusTrackingBarManager,
	BagsBar
}

local framesToDisable = {
	MainMenuBar,
	MainActionBar,
	MultiBarBottomLeft,
	MultiBarBottomRight,
	MultiBarLeft,
	MultiBarRight,
	MultiBar5,
	MultiBar6,
	MultiBar7,
	PossessActionBar,
	PetActionBar,
	StanceBar,
	MicroButtonAndBagsBar,
	StatusTrackingBarManager,
	MainMenuBarVehicleLeaveButton,
	OverrideActionBar,
	OverrideActionBarExpBar,
	OverrideActionBarHealthBar,
	OverrideActionBarPowerBar,
	OverrideActionBarPitchFrame,
}

local function DisableAllScripts(frame)
	for _, script in next, scripts do
		if frame:HasScript(script) then
			frame:SetScript(script, nil)
		end
	end
end

local function updateTokenVisibility()
	TokenFrame_LoadUI()
	TokenFrame_Update()
	BackpackTokenFrame_Update()
end

function Module:HideBlizz()
	MainMenuBar:SetMovable(true)
	MainMenuBar:SetUserPlaced(true)
	MainMenuBar.ignoreFramePositionManager = true
	MainMenuBar:SetAttribute("ignoreFramePositionManager", true)

	for _, frame in next, framesToHide do
		frame:SetParent(K.UIFrameHider)
	end

	for _, frame in next, framesToDisable do
		frame:UnregisterAllEvents()
		DisableAllScripts(frame)
	end

	-- Hide blizz options
	SetCVar("multiBarRightVerticalLayout", 0)
	-- Update token panel
	K:RegisterEvent("CURRENCY_DISPLAY_UPDATE", updateTokenVisibility)
end
