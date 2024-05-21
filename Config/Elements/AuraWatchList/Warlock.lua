local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "WARLOCK" then
	return
end

local list = {
	["Player Aura"] = { 
		{ AuraID = 5697, UnitID = "player" },
	},
	["Target Aura"] = {
		{ AuraID = 27228, UnitID = "target" },
		{ AuraID = 710, 	UnitID = "target", Caster = "player" },
		{ AuraID = 6215, 	UnitID = "target", Caster = "pet"	 },
		{ AuraID = 6358, 	UnitID = "target", Caster = "pet"	 },
		{ AuraID = 27223, UnitID = "target", Caster = "player" },
		{ AuraID = 17928, UnitID = "target", Caster = "player" },
		{ AuraID = 17877, UnitID = "target", Caster = "player" },
		{ AuraID = 27215, UnitID = "target", Caster = "player" },
		{ AuraID = 30910, UnitID = "target", Caster = "player" },
		{ AuraID = 27216, UnitID = "target", Caster = "player" },
		{ AuraID = 27218, UnitID = "target", Caster = "player" },
		{ AuraID = 30108, UnitID = "target", Caster = "player" },
		{ AuraID = 27243, UnitID = "target", Caster = "player" },
	},
	["Special Aura"] = {
		{ AuraID = 28610, UnitID = "pet" },
		{ AuraID = 47241, UnitID = "player" },
		{ AuraID = 50589, UnitID = "player" },
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("WARLOCK", list)
