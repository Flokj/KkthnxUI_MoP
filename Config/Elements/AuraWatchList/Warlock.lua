local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "WARLOCK" then
	return
end

local list = {
	["Player Aura"] = { 
		{ AuraID = 63321, UnitID = "player" }, 	-- Life Tap
	},
	["Target Aura"] = {
		{ AuraID = 47865, UnitID = "target" },	-- Curse of the Elements
		{ AuraID = 11719, UnitID = "target" },	-- Curse of Tongues
		{ AuraID = 18223, UnitID = "target" },	-- Curse of Exhaustion
		{ AuraID = 50511, UnitID = "target" },	-- Curse of Weakness

		{ AuraID = 172, UnitID = "target", Caster = "player" },		-- Corruption
		{ AuraID = 348, UnitID = "target", Caster = "player" },		-- Immolate
		{ AuraID = 980, UnitID = "target", Caster = "player" },		-- Curse of Agony
		{ AuraID = 47867, UnitID = "target", Caster = "player" },	-- Curse of Doom
		{ AuraID = 47843, UnitID = "target", Caster = "player" },	-- Unstable Affliction
		{ AuraID = 59164, UnitID = "target", Caster = "player" },	-- Haunt
		{ AuraID = 27243, UnitID = "target", Caster = "player" },	-- Seed of Corruption
		{ AuraID = 702, UnitID = "target", Caster = "player" },		-- Curse of Weakness
		{ AuraID = 18223, UnitID = "target", Caster = "player" },	-- Curse of Exhaustion
		{ AuraID = 6215, UnitID = "target", Caster = "player" },	-- Fear
		{ AuraID = 5484, UnitID = "target", Caster = "player" },	-- Howl of Terror
		{ AuraID = 6789, UnitID = "target", Caster = "player" },	-- Death Coil
		{ AuraID = 710, UnitID = "target", Caster = "player" },		-- Banish
		{ AuraID = 1098, UnitID = "target", Caster = "player" },	-- Enslave Demon
		{ AuraID = 54785, UnitID = "target", Caster = "player" },	-- Demon Charge

		{ AuraID = 32385, UnitID = "target", Caster = "player" },	-- Shadow Embrace
	},
	["Special Aura"] = {
		{ AuraID = 60062, UnitID = "player" },	-- Essence of Life
		{ AuraID = 47383, UnitID = "player" },	-- Molten Core
		{ AuraID = 63158, UnitID = "player" },	-- Decimation
		{ AuraID = 54277, UnitID = "player" },	-- Backdraft
		{ AuraID = 34939, UnitID = "player" },	-- Backlash
		{ AuraID = 30302, UnitID = "player" },	-- Nether Protection
		{ AuraID = 60235, UnitID = "player" },	-- Greatness
		{ AuraID = 60234, UnitID = "player" },	-- Greatness
		{ AuraID = 18095, UnitID = "player" },	-- Nightfall
		{ AuraID = 17941, UnitID = "player" },	-- Nighfall
		{ AuraID = 71636, UnitID = "player" },	-- Siphoned Power
		{ AuraID = 75473, UnitID = "player" },	-- Twilight Flames
		{ AuraID = 71644, UnitID = "player" },	-- Surge of Power
		{ AuraID = 70840, UnitID = "player" },	-- Devious Minds
		{ AuraID = 54999, UnitID = "player" },	-- Hyperspeed Accelerators
		{ AuraID = 64713, UnitID = "player" },	-- Комета
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("WARLOCK", list)
