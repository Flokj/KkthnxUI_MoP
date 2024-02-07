local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "PRIEST" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 47585, UnitID = "player" },	-- Dispersion
	},
	["Target Aura"] = { 
		{ AuraID = 34914, UnitID = "target", Caster = "player" },	-- Vampiric Touch
		{ AuraID = 2944, UnitID = "target", Caster = "player" },	-- Devouring Plague
		{ AuraID = 589, UnitID = "target", Caster = "player" }, 	-- Shadow Word: Pain
	},
	["Special Aura"] = {
		{ AuraID = 33151, UnitID = "player" },	-- Surge of Light
		{ AuraID = 63734, UnitID = "player" }, 	-- Serendipity
		{ AuraID = 60234, UnitID = "player" }, 	-- Greatness
		{ AuraID = 60062, UnitID = "player" }, 	-- Essence of Life
		{ AuraID = 67696, UnitID = "player" }, 	-- Energized
		{ AuraID = 65007, UnitID = "player" }, 	-- Eye of the Broodmother
		{ AuraID = 75473, UnitID = "player" }, 	-- Twilight Flames (861 SPD)
		{ AuraID = 71636, UnitID = "player" }, 	-- Siphoned Power (TBL)
		{ AuraID = 71643, UnitID = "player" }, 	-- Surging Power (object)
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("PRIEST", list)
