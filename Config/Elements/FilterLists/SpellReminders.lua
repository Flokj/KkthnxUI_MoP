local C = KkthnxUI[2]

C.SpellReminderBuffs = {
	ITEMS = {
		--[=[
		{
			itemID = 190384, -- 9.0 Permanent Attribute Rune
			spells = {
				[393438] = true, -- Dragon Empowerment Rune itemID 201325
				[367405] = true, -- Permanent Rune buff
			},
			instance = true,
			disable = true, -- Disabled until a new rune comes out
		},
		{
			itemID = 194307, -- Nest Guardian's Promise
			spells = {
				[394457] = true,
			},
			equip = true,
			instance = true,
			inGroup = true,
		},
		
		{   itemID = 178742, -- Bottled Toxin Trinket
			spells = {
				[345545] = true,
			},
			equip = true,
			instance = true,
			combat = true,
		},
		{   itemID = 190958, -- Ultimate Arcanum
			spells = {
				[368512] = true,
			},
			equip = true,
			instance = true,
			inGroup = true,
		},
		]=]
	},
	MAGE = {
		{	spells = {
				[1459] = true,
				[61316] = true,
				[126309] = true,
			},
			texture = C_Spell.GetSpellTexture(1459),
			depend = 1459,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {
				[7302] = true,
				[6117] = true,
				[30482] = true,
			},
			depend = 7302,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	PRIEST = {
		{	spells = {
				[21562] = true,
				[469] = true,
				--[6307] = true
				[90364] = true,
				[109773] = true,
				[111923] = true,
			},
			texture = C_Spell.GetSpellTexture(21562),
			depend = 1243,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {
				[588] = true,
				[73413] = true,
			},
			depend = 588,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	DRUID = {
		{	spells = {
				[1126] = true,
				[20217] = true,
				[90363] = true,
				[117667] = true,
				[72586] = true,
			},
			depend = 1126,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	WARRIOR = {
		{	spells = {
				[6673] = true,
				[57330] = true,
				[19506] = true,
			},
			texture = C_Spell.GetSpellTexture(6673),
			depend = 6673,
			gemini = {
				[GetSpellInfo(469)] = true,
			},
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {
				[469] = true,
				[21562] = true,
				--[6307] = true,
				[90364] = true,
				[109773] = true,
				[111923] = true,
			},
			texture = C_Spell.GetSpellTexture(469),
			depend = 469,
			gemini = {
				[GetSpellInfo(6673)] = true,
			},
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	HUNTER = {
		{	spells = {
				[13165] = true,
				[5118] = true,
				[109260] = true,
			},
			depend = 13165,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	WARLOCK = {
		{	spells = {
				[109773] = true,
			},
			depend = 109773,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	DEATHKNIGHT = {
		{	spells = {
				[57330] = true,
				[6673] = true,
				[19506] = true,
			},
			texture = C_Spell.GetSpellTexture(57330),
			depend = 57330,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	PALADIN = {
		{	spells = {
				[25780] = true,
			},
			depend = 84839,
			instance = true,
		},
		{	spells = {
				[19740] = true,
				[116956] = true,
				[93435] = true,
				[128997] = true,
			},
			texture = C_Spell.GetSpellTexture(19740),
			depend = 19740,
			gemini = {
				[GetSpellInfo(20217)] = true,
			},
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {
				[117667] = true,
				[1126] = true,
				[20217] = true,
				[90363] = true,
				[72586] = true,
			},
			texture = C_Spell.GetSpellTexture(20217),
			depend = 20217,
			gemini = {
				[GetSpellInfo(19740)] = true,
			},
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	SHAMAN = {
		{	spells = {
				[52127] = true,
				[324] = true,
			},
			depend = 52127,
			instance = true,
		},
	},
	MONK = {
		{	spells = {
				[116781] = true,
				[24932] = true,
				[1459] = true,
				[61316] = true,
				[126309] = true,
				[24604] = true,
				[90309] = true,
				[126373] = true,
			},
			texture = C_Spell.GetSpellTexture(116781),
			depend = 116781,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {
				[117667] = true,
				[1126] = true,
				[20217] = true,
				[90363] = true,
				[72586] = true,
			},
			texture = C_Spell.GetSpellTexture(117667),
			depend = 117667,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
}