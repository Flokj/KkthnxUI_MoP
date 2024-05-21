local K = KkthnxUI[1]
local Module = K:GetModule("AurasTable")

if K.Class ~= "WARRIOR" then
	return
end

local list = {
	["Player Aura"] = {
		--{ AuraID = 32216, UnitID = "player" },
	},
	["Target Aura"] = {
		{ AuraID = 355,  UnitID = "target", Caster = "player" },
		{ AuraID = 772,  UnitID = "target", Caster = "player" },
		{ AuraID = 1715, UnitID = "target", Caster = "player" },
		{ AuraID = 1160, UnitID = "target", Caster = "player" },
		{ AuraID = 6343, UnitID = "target", Caster = "player" },
		{ AuraID = 5246, UnitID = "target", Caster = "player" },
		{ AuraID = 7922, UnitID = "target", Caster = "player" },
		{ AuraID = 12323,UnitID = "target", Caster = "player" },
	},
	["Special Aura"] = {
		{ AuraID = 871, 	UnitID = "player" },
		{ AuraID = 1719,  UnitID = "player" },
		{ AuraID = 7384,  UnitID = "player" },
		{ AuraID = 12975, UnitID = "player" },
		{ AuraID = 12292, UnitID = "player" },
		{ AuraID = 23920, UnitID = "player" },
		{ AuraID = 18499, UnitID = "player" },
	},
	["Focus Aura"] = {
	},
	["Spell Cooldown"] = {
		{ SlotID = 13 },
		{ SlotID = 14 },
	},
}

Module:AddNewAuraWatch("WARRIOR", list)
