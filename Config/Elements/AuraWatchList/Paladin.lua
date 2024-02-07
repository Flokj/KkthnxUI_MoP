local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "PALADIN" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 59578, UnitID = "player" },	-- Art Of War
		{ AuraID = 53601, UnitID = "player" },	-- Holy Shield
		{ AuraID = 58597, UnitID = "player" },	-- Holy Shield(proc)
	},
	["Target Aura"] = {
		{ AuraID = 853, UnitID = "target", Caster = "player" },
	},
	["Special Aura"] = {
		{ AuraID = 54155, UnitID = "player" },	-- Judgements of the Pure
		{ AuraID = 54149, UnitID = "player" },	-- Infusion of Light
		{ AuraID = 54428, UnitID = "player" },	-- Divine Plea
		{ AuraID = 60062, UnitID = "player" },	-- Essence of Life
		{ AuraID = 53563, UnitID = "player" },	-- Beacon of Light
		{ AuraID = 31842, UnitID = "player" },	-- Divine Illumination
		{ AuraID = 71541, UnitID = "player" },	-- 1250 ap
		{ AuraID = 67773, UnitID = "player" }, 	-- 510 strength
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = { 
		{ SlotID = 13 }, 
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("PALADIN", list)
