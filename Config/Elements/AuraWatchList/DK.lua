local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "DEATHKNIGHT" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 3714,  UnitID = "player" },
		{ AuraID = 53365, UnitID = "player" },
		{ AuraID = 59052, UnitID = "player" },
	},
	["Target Aura"] = {
		{ AuraID = 55078, UnitID = "target", Caster = "player" },
		{ AuraID = 55095, UnitID = "target", Caster = "player" },
		{ AuraID = 56222, UnitID = "target", Caster = "player" },
		{ AuraID = 45524, UnitID = "target", Caster = "player" },
	},
	["Special Aura"] = {
		{ AuraID = 63560, UnitID = "pet"		},
		{ AuraID = 47568, UnitID = "player" },
		{ AuraID = 49039, UnitID = "player" },
		{ AuraID = 55233, UnitID = "player" },
		{ AuraID = 48707, UnitID = "player" },
		{ AuraID = 48792, UnitID = "player" },
		{ AuraID = 51271, UnitID = "player" },
		{ AuraID = 51124, UnitID = "player" },
		{ AuraID = 51460, UnitID = "player" },
		{ AuraID = 49796, UnitID = "player", Flash = true },
		{ AuraID = 48743, UnitID = "player", Value = true },
	},
	["Focus Aura"] = {
		{ AuraID = 55078, UnitID = "focus", Caster = "player" },
		{ AuraID = 55095, UnitID = "focus", Caster = "player" },
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 }, 
		{ SlotID = 14 },
		{ SpellID = 48792 },
		{ SpellID = 49206 },
	},
}

Module:AddNewAuraWatch("DEATHKNIGHT", list)
