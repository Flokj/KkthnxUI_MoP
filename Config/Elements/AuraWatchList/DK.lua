local K = unpack(KkthnxUI)
local Module = K:GetModule("AurasTable")

if K.Class ~= "DEATHKNIGHT" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 54999, UnitID = "player" },	-- Hyperspeed Accelerators
		{ AuraID = 48707, UnitID = "player" },	-- AMSH
		{ AuraID = 48792, UnitID = "player" },	-- Icebound
		{ AuraID = 55233, UnitID = "player" },	-- Vampiric Blood
	},
	["Target Aura"] = {
		{ AuraID = 59879, UnitID = "target", Caster = "player" }, -- Blood Plague
		{ AuraID = 59921, UnitID = "target", Caster = "player" }, -- Frost Fever
		{ AuraID = 49194, UnitID = "target", Caster = "player" }, -- Unholy Blight
		{ AuraID = 49206, UnitID = "target", Caster = "player" }, -- Summon Gargoyle
	},
	["Special Aura"] = {
		{ AuraID = 60229, UnitID = "player" },	-- Greatness
		{ AuraID = 67383, UnitID = "player" },	-- Unholy Force
		{ AuraID = 66817, UnitID = "player" },	-- Desolation
		{ AuraID = 53365, UnitID = "player" },	-- Unholy Strength
		{ AuraID = 65014, UnitID = "player" },	-- Pyrite Infusion
		{ AuraID = 67117, UnitID = "player" },	-- Unholy Might
		{ AuraID = 49028, UnitID = "player" },	-- Dancing Rune Weapon
		{ AuraID = 51124, UnitID = "player" },	-- Killing machine
		{ AuraID = 59052, UnitID = "player" },	-- Freezing fog
		{ AuraID = 75456, UnitID = "player" },	-- Halion chechka
		{ AuraID = 67773, UnitID = "player" },	-- Paragon(+510 Strength)
		{ AuraID = 71541, UnitID = "player" },	-- Ice Rage(+1250 AP)

		{ AuraID = 48743, UnitID = "player", Value = true }, -- 天灾契约
	},
	["Focus Aura"] = {
		{ AuraID = 55078, UnitID = "focus", Caster = "player" },
		{ AuraID = 55095, UnitID = "focus", Caster = "player" },
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 }, 
		{ SlotID = 14 },
		{ SpellID = 48792 },
		{ SpellID = 49206 },
	},
}

Module:AddNewAuraWatch("DEATHKNIGHT", list)
