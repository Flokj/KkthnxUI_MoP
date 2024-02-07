local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "HUNTER" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 29166, UnitID = "player" },	-- Innervate
		{ AuraID = 54999, UnitID = "player" },	-- Hyperspeed Accelerators
	},
	["Target Aura"] = {
		{ AuraID = 1130, UnitID = "target" },	-- Hunter's Mark
		{ AuraID = 49001, UnitID = "target", Caster = "player" },	-- Serpent Sting
		{ AuraID = 3043, UnitID = "target", Caster = "player" },	-- Scorpid Sting
		{ AuraID = 63672, UnitID = "target", Caster = "player" },	-- Black Arrow
		{ AuraID = 60053, UnitID = "target", Caster = "player" }, 	-- Explosive Shot
	},
	["Special Aura"] = {
		{ AuraID = 56453, UnitID = "player" },	-- Lock and Load
		{ AuraID = 60314, UnitID = "player" },	-- Fury of the Five Flights
		{ AuraID = 60233, UnitID = "player" },	-- Greatness
		{ AuraID = 65019, UnitID = "player" },	-- Mjolnir Runestone
		{ AuraID = 6150, UnitID = "player" },	-- Quick Shots
		{ AuraID = 34837, UnitID = "player" },	-- Master Tactician
		{ AuraID = 53224, UnitID = "player" },	-- Master Tactician
		{ AuraID = 34503, UnitID = "player" },	-- Expose Weakness
		{ AuraID = 70728, UnitID = "player" },	-- Exploit Weakness 2t10 proc
		{ AuraID = 71007, UnitID = "player" },	-- Stinger 4t10 proc
		{ AuraID = 71486, UnitID = "player" },	-- Power of the Taunka
		{ AuraID = 71491, UnitID = "player" },	-- Aim of the Iron Dwarves
		{ AuraID = 71485, UnitID = "player" },	-- Agility of the Vrykul
		{ AuraID = 71401, UnitID = "player" },	-- Icy Rage
		{ AuraID = 3045, UnitID = "player" },	-- Rapid Fire
		{ AuraID = 26297, UnitID = "player" },	-- Berserking
		{ AuraID = 53908, UnitID = "player" },	-- Potion of Speed
		{ AuraID = 53909, UnitID = "player" },	-- Potion of Wild Magic
		{ AuraID = 20572, UnitID = "player" },	-- Blood Fury
		{ AuraID = 53434, UnitID = "player" },	-- Call of the Wild
		{ AuraID = 54758, UnitID = "player" },	-- Hyperspeed Acceleration
		{ AuraID = 72412, UnitID = "player" },	-- Frostforged Champion
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("HUNTER", list)
