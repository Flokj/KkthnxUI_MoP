local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "SHAMAN" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 49281, UnitID = "player" },	-- Lightning Shield
		{ AuraID = 57960, UnitID = "player" },	-- Water Shield
		{ AuraID = 49284, UnitID = "player" },	-- Earth Shield
		--{ AuraID = 53817, UnitID = "player" },	-- Maelstorm Weapon
	},
	["Target Aura"] = {
		{ AuraID = 17364, UnitID = "target", Caster = "player" },	-- Storm Strike
		{ AuraID = 49231, UnitID = "target", Caster = "player" },	-- Earth Shock
		{ AuraID = 49236, UnitID = "target", Caster = "player" },	-- Frost Shock
		{ AuraID = 49233, UnitID = "target", Caster = "player" },	-- Flame Shock
	},
	["Special Aura"] = {
		{ AuraID = 16246, UnitID = "player" },	-- Clearcasting
		{ AuraID = 53390, UnitID = "player" },	-- Tidal Waves
		{ AuraID = 60062, UnitID = "player" },	-- Essence of Life
		{ AuraID = 75456, UnitID = "player" },	-- Piersing Twilight (1472 AP)
		{ AuraID = 75473, UnitID = "player" },	-- Twilight Flames (861 SPD)
		{ AuraID = 71636, UnitID = "player" },	-- Siphoned Power (TBL)
		{ AuraID = 71560, UnitID = "player" },	-- Speed of the Vrykul
		{ AuraID = 71558, UnitID = "player" },	-- Power of the Taunka
		{ AuraID = 71556, UnitID = "player" },	-- Agility of the Vrykul
		{ AuraID = 70831, UnitID = "player" },	-- Maelstorm Power

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
