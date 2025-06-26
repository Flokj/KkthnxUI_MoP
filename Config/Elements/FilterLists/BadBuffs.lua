local K, C = KkthnxUI[1], KkthnxUI[2]

local GetSpellInfo = GetSpellInfo

local function SpellName(id)
	local spellInfo = GetSpellInfo(id)
	local name

	-- Handle both old API (string) and new API (table)
	if type(spellInfo) == "table" then
		name = spellInfo.name
	else
		name = spellInfo
	end

	if name then
		return name
	else
		K.Print("|cffff0000WARNING: [BadBuffsFilter] - spell ID [" .. tostring(id) .. "] no longer exists! Report this to Kkthnx.|r")
		return "Empty"
	end
end

C.CheckBadBuffs = {
	[SpellName(44212)] = true, -- Jack-o'-Lanterned!
	[SpellName(24732)] = true, -- Bat Costume
	[SpellName(24735)] = true, -- Ghost Costume
	[SpellName(24712)] = true, -- Leper Gnome Costume
	[SpellName(24710)] = true, -- Ninja Costume
	[SpellName(24709)] = true, -- Pirate Costume
	[SpellName(24723)] = true, -- Skeleton Costume
	[SpellName(24740)] = true, -- Wisp Costume

	-- [SpellName(308078)] = true, -- Debug
}
