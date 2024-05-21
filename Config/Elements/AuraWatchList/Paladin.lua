local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "PALADIN" then
	return
end

local list = {
	["Player Aura"] = {
		{ AuraID = 25780, UnitID = "player" },
	},
	["Target Aura"] = {
		{ AuraID = 853, UnitID = "target", Caster = "player" },
	},
	["Special Aura"] = {
		{ AuraID = 498, 	UnitID = "player" },
		{ AuraID = 642, 	UnitID = "player" },
		{ AuraID = 27155, UnitID = "player" },
		{ AuraID = 27160, UnitID = "player" },
		{ AuraID = 27166, UnitID = "player" },
		{ AuraID = 31884, UnitID = "player" },
		{ AuraID = 31895, UnitID = "player" },
		{ AuraID = 348704,UnitID = "player" },
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = { 
		{ SlotID = 13 }, 
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("PALADIN", list)
