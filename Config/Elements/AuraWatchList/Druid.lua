local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "DRUID" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 5215,  UnitID = "player" },
		{ AuraID = 1850,  UnitID = "player" },
		{ AuraID = 26992, UnitID = "player" },
	},
	["Target Aura"] = {
		{ AuraID = 99,    UnitID = "target", Caster = "player" },
		{ AuraID = 339,   UnitID = "target", Caster = "player" },
		{ AuraID = 1079,  UnitID = "target", Caster = "player" },
		{ AuraID = 5211,  UnitID = "target", Caster = "player" },
		{ AuraID = 6795,  UnitID = "target", Caster = "player" },
		{ AuraID = 26980, UnitID = "target", Caster = "player" },
		{ AuraID = 26982, UnitID = "target", Caster = "player" },
		{ AuraID = 33763, UnitID = "target", Caster = "player" },
		{ AuraID = 27006, UnitID = "target", Caster = "player" },
	},
	["Special Aura"] = {
		{ AuraID = 5229,  UnitID = "player" },
		{ AuraID = 9846,  UnitID = "player" },
		{ AuraID = 22842, UnitID = "player" },
		{ AuraID = 22812, UnitID = "player" },
		{ AuraID = 16870, UnitID = "player" },
		{ AuraID = 26980, UnitID = "player" },
		{ AuraID = 26982, UnitID = "player" },
		{ AuraID = 33763, UnitID = "player" },
		{ AuraID = 33357, UnitID = "player" },
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("DRUID", list)
