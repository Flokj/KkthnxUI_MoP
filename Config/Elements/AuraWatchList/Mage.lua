local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "MAGE" then
	return
end

local list = {
	["Player Aura"] = {
		{AuraID = 130, UnitID = "player"},
	},
	["Target Aura"] = {
		{ AuraID = 116,   UnitID = "target", Caster = "player" },
		{ AuraID = 118,   UnitID = "target", Caster = "player" },
		{ AuraID = 122,   UnitID = "target", Caster = "player" },
		{ AuraID = 12654, UnitID = "target", Caster = "player" },
		{ AuraID = 11366, UnitID = "target", Caster = "player" },
	},
	["Special Aura"] = {
		{ AuraID = 66, 	UnitID = "player" },
		{ AuraID = 27131, UnitID = "player" },
		{ AuraID = 27128, UnitID = "player" },
		{ AuraID = 32796, UnitID = "player" },
		{ AuraID = 45438, UnitID = "player" },
		{ AuraID = 11129, UnitID = "player" },
		{ AuraID = 12042, UnitID = "player" },
		{ AuraID = 12472, UnitID = "player" },
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("MAGE", list)
