local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "SHAMAN" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 546, 	UnitID = "player" },
		{ AuraID = 25472, UnitID = "player" },
		{ AuraID = 33736, UnitID = "player" },
	},
	["Target Aura"] = {
		{ AuraID = 974,   UnitID = "target", Caster = "player" },
		{ AuraID = 25464, UnitID = "target", Caster = "player" },
		{ AuraID = 25457, UnitID = "target", Caster = "player" },
	},
	["Special Aura"] = {
		{ AuraID = 974,   UnitID = "player" },
		{ AuraID = 16166, UnitID = "player" },
		{ AuraID = 30823, UnitID = "player" },
		{ AuraID = 16188, UnitID = "player", Flash = true },
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
		{ SpellID = 20608 },
	},
}

Module:AddNewAuraWatch("SHAMAN", list)
