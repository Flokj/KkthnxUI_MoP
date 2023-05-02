local K = unpack(KkthnxUI)
local Module = K:GetModule("AurasTable")

if K.Class ~= "DRUID" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 33763, UnitID = "player" },	-- Lifebloom
		{ AuraID = 774, UnitID = "player" }, 	-- Rejuvenation
		{ AuraID = 8936, UnitID = "player" },	-- Regrowth
		{ AuraID = 2893, UnitID = "player" },	-- Abolish Poison
		{ AuraID = 52610, UnitID = "player" },	-- Savage roar
		{ AuraID = 29166, UnitID = "player" },	-- Innervate
		{ AuraID = 22812, UnitID = "player" },	-- Barkskin
		{ AuraID = 61336, UnitID = "player" },	-- Survival Instincts
		{ AuraID = 54999, UnitID = "player" },	-- Hyperspeed Accelerators
	},
	["Target Aura"] = {
		{ AuraID = 48566, UnitID = "target" },	-- Mangle (Cat)
		{ AuraID = 48564, UnitID = "target" },	-- Mangle (Bear)
		{ AuraID = 770, UnitID = "target" },	-- Faerie Fire
		{ AuraID = 26989, UnitID = "target" },	-- Entangling Roots
		{ AuraID = 48463, UnitID = "target", Caster = "player" },	-- Moonfire
		{ AuraID = 48468, UnitID = "target", Caster = "player" }, 	-- Insect Swarm
		{ AuraID = 48511, UnitID = "target", Caster = "player" },	-- Earth and Moon
		{ AuraID = 59886, UnitID = "target", Caster = "player" },	-- Rake
		{ AuraID = 49800, UnitID = "target", Caster = "player" },	-- Rip
		{ AuraID = 48568, UnitID = "target", Caster = "player" },	-- Lacerate
		{ AuraID = 49804, UnitID = "target", Caster = "player" },	-- Pounce Bleed
	},
	["Special Aura"] = {
		{ AuraID = 48518, UnitID = "player" },	-- Eclipse (Lunar)
		{ AuraID = 48517, UnitID = "player" },	-- Eclipse (Solar)
		{ AuraID = 16870, UnitID = "player" },	-- Clearcasting
		{ AuraID = 60062, UnitID = "player" },	-- Essence of Life
		{ AuraID = 71636, UnitID = "player" },	-- Siphoned Power
		{ AuraID = 75473, UnitID = "player" },	-- Twilight Flames
		{ AuraID = 54999, UnitID = "player" },	-- Hyperspeed Accelerators
		{ AuraID = 71572, UnitID = "player" },	-- Cultivated Power
		{ AuraID = 71586, UnitID = "player" },	-- Hardened Skin
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("DRUID", list)
