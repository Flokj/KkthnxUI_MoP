local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "MAGE" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 71572, UnitID = "player" },	-- Cultivated Power (Muradin's Spyglass)
		{ AuraID = 44448, UnitID = "player" },	-- Hot Streak
		{ AuraID = 64343, UnitID = "player" },	-- Impact
		{ AuraID = 57761, UnitID = "player" },	-- Fireball!
		{ AuraID = 44544, UnitID = "player" },	-- Fingers of Frost
	},
	["Target Aura"] = {
		{ AuraID = 22959, UnitID = "target" },	-- Improved Scorch
		{ AuraID = 55360, UnitID = "target", Caster = "player" },	-- Ignite
		{ AuraID = 12848, UnitID = "target", Caster = "player" },	-- Living Bomb
	},
	["Special Aura"] = {
		{ AuraID = 71636, UnitID = "player" },	-- Siphoned Power (Phylactery)
		{ AuraID = 75473, UnitID = "player" },	-- Twilight Flames
		{ AuraID = 71643, UnitID = "player" },	-- Surging Power
		{ AuraID = 60234, UnitID = "player" },	-- Greatness
		{ AuraID = 60062, UnitID = "player" },	-- Essence of Life
		{ AuraID = 12536, UnitID = "player" },	-- Clearcasting
		{ AuraID = 54741, UnitID = "player" },	-- Firestarter
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("MAGE", list)
