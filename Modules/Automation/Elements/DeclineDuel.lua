local K, C = unpack(KkthnxUI)
local Module = K:GetModule("Automation")

local CancelDuel = CancelDuel
local StaticPopup_Hide = StaticPopup_Hide
local confirmationColor = "|cff00ff00"

-- Declines a pending duel request
function Module:DUEL_REQUESTED(name)
	CancelDuel() -- Cancel the duel request
	StaticPopup_Hide("DUEL_REQUESTED") -- Hide the pending duel popup
	print("Declined a duel request from: " .. confirmationColor .. name .. "|r") -- Print confirmation message
end

-- Registers or unregisters the event handlers for auto-declining duels
function Module:CreateAutoDeclineDuels()
	if C["Automation"].AutoDeclineDuels then
		K:RegisterEvent("DUEL_REQUESTED", Module.DUEL_REQUESTED) -- Register the DUEL_REQUESTED event
	else
		K:UnregisterEvent("DUEL_REQUESTED", Module.DUEL_REQUESTED) -- Unregister the DUEL_REQUESTED event
	end
end
