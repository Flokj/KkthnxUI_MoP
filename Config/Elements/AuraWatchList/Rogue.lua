local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "ROGUE" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 1784, UnitID = "player" },
	},
	["Target Aura"] = {
		{ AuraID = 408,  UnitID = "target", Caster = "player" },
		{ AuraID = 703,  UnitID = "target", Caster = "player" },
		{ AuraID = 1833, UnitID = "target", Caster = "player" },
		{ AuraID = 6770, UnitID = "target", Caster = "player" },
		{ AuraID = 2094, UnitID = "target", Caster = "player" },
		{ AuraID = 1330, UnitID = "target", Caster = "player" },
		{ AuraID = 1776, UnitID = "target", Caster = "player" },
		{ AuraID = 1943, UnitID = "target", Caster = "player" },
	},
	["Special Aura"] = {
		{ AuraID = 2983,  UnitID = "player" },
		{ AuraID = 5171,  UnitID = "player" },
		{ AuraID = 26669, UnitID = "player" },
		{ AuraID = 26888, UnitID = "player" },
		{ AuraID = 13750, UnitID = "player" },
		{ AuraID = 13877, UnitID = "player" },
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = { 
		{ SlotID = 13 },
		{ SlotID = 14 },
		{ SpellID = 13750 },
	},
}

Module:AddNewAuraWatch("ROGUE", list)
