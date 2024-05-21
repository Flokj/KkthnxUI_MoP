local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "HUNTER" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 1539,  UnitID = "pet"		},
		{ AuraID = 5118,  UnitID = "player" },
		{ AuraID = 34477, UnitID = "player" },
		{ AuraID = 35079, UnitID = "player" },
		{ AuraID = 53257, UnitID = "player" },
		{ AuraID = 82925, UnitID = "player" },
		{ AuraID = 77769, UnitID = "player" },
	},
	["Target Aura"] = {
		{ AuraID = 1130,  UnitID = "target" },
		{ AuraID = 88691, UnitID = "target" },
		{ AuraID = 1513,  UnitID = "target", Caster = "player" },
		{ AuraID = 1978,  UnitID = "target", Caster = "player" },
		{ AuraID = 88453, UnitID = "target", Caster = "player" },
		{ AuraID = 19503, UnitID = "target", Caster = "player" },
		{ AuraID = 5116,  UnitID = "target", Caster = "player" },
		{ AuraID = 3674,  UnitID = "target", Caster = "player" },
		{ AuraID = 19386, UnitID = "target", Caster = "player" },
		{ AuraID = 14268, UnitID = "target", Caster = "player" },
		{ AuraID = 13810, UnitID = "target", Caster = "player" },
		{ AuraID = 82654, UnitID = "target", Caster = "player" },
		{ AuraID = 5116,  UnitID = "target", Caster = "player" },
		{ AuraID = 20736, UnitID = "target", Caster = "player" },
		{ AuraID = 2974,  UnitID = "target", Caster = "player" },
		{ AuraID = 24394, UnitID = "target", Caster = "pet"	 },
	},
	["Special Aura"] = {
		{ AuraID = 3045,  UnitID = "player" },
		{ AuraID = 34471, UnitID = "player" },
		{ AuraID = 6150,  UnitID = "player" },
		{ AuraID = 19577, UnitID = "player" },
		{ AuraID = 53220, UnitID = "player" },
		{ AuraID = 56453, UnitID = "player" },
		{ AuraID = 94007, UnitID = "player" },
		{ AuraID = 82921, UnitID = "player" },
		{ AuraID = 19263, UnitID = "player" },
		{ AuraID = 64420, UnitID = "player" },
		{ AuraID = 82926, UnitID = "player", Flash = true },
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("HUNTER", list)
