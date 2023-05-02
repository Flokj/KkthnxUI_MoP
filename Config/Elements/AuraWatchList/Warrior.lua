local K = unpack(KkthnxUI)
local Module = K:GetModule("AurasTable")

if K.Class ~= "WARRIOR" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 64568, UnitID = "player" },	-- Blood Reserve
		{ AuraID = 46916, UnitID = "player" },	-- Slam!
		{ AuraID = 12975, UnitID = "player" },	-- Last Stand
		{ AuraID = 871, UnitID = "player" },	-- Shield Wall
	},
	["Target Aura"] = {
		{ AuraID = 1715, UnitID = "target" },	-- Hamstring
		{ AuraID = 48560, UnitID = "target" },	-- Demoralizing Roar
		{ AuraID = 50511, UnitID = "target" },	-- Curse of Weakness
		{ AuraID = 7386, UnitID = "target" },	-- Sunder Armor
		{ AuraID = 48485, UnitID = "target" },	-- Infected Wounds
		{ AuraID = 55095, UnitID = "target" },	-- Frost Fever
		{ AuraID = 47465, UnitID = "target", Caster = "player" },	-- Rend
		{ AuraID = 48669, UnitID = "target", Caster = "player" },	-- Expose Armor
		{ AuraID = 6343, UnitID = "target", Caster = "player" },	-- Thunder Clap
		{ AuraID = 1160, UnitID = "target", Caster = "player" },	-- Demoralizing Shout
	},
	["Special Aura"] = {
		{ AuraID = 52437, UnitID = "player" },	-- Sudden Death
		{ AuraID = 50227, UnitID = "player" },	-- Sword and Board
		{ AuraID = 60229, UnitID = "player" },	-- Greatness
		{ AuraID = 71561, UnitID = "player" },	-- Strength of the Taunka
		{ AuraID = 71560, UnitID = "player" },	-- Speed of the Vrykul
		{ AuraID = 71559, UnitID = "player" },	-- Aim of the Iron Dwarves
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("WARRIOR", list)
