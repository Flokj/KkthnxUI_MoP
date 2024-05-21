local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "PRIEST" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 586, UnitID = "player" },
	},
	["Target Aura"] = { 
		{ AuraID = 25218, UnitID = "target", Caster = "player" },
		{ AuraID = 25222, UnitID = "target", Caster = "player" },
		{ AuraID = 41635, UnitID = "target", Caster = "player" },
		{ AuraID = 25384, UnitID = "target", Caster = "player" },
		{ AuraID = 15487, UnitID = "target", Caster = "player" },
		{ AuraID = 25368, UnitID = "target", Caster = "player" },
		{ AuraID = 25467, UnitID = "target", Caster = "player" },
		{ AuraID = 10890, UnitID = "target", Caster = "player" },
		{ AuraID = 34914, UnitID = "target", Caster = "player" },
	},
	["Special Aura"] = {
		{ AuraID = 6346,  UnitID = "player" },
		{ AuraID = 10060, UnitID = "player" },
		{ AuraID = 27827, UnitID = "player" },
		{ AuraID = 25218, UnitID = "player" },
		{ AuraID = 25222, UnitID = "player" },
		{ AuraID = 25429, UnitID = "player" },
		{ AuraID = 41635, UnitID = "player" },
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("PRIEST", list)
