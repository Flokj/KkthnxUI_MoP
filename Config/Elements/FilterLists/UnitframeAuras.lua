local K, C = KkthnxUI[1], KkthnxUI[2]

local function Priority(priorityOverride)
	return {
		enable = true,
		priority = priorityOverride or 0,
		stackThreshold = 0,
	}
end

C.DebuffsTracking_PvE = {
	["type"] = "Whitelist",
	["spells"] = {
	-- Death Knight
		[47476] = Priority(2),	-- Strangulate
		[49203] = Priority(2),	-- Hungering Cold
	-- Druid
		[339] = Priority(2),		-- Entangling Roots
		[2637] = Priority(2),	-- Hibernate
		[33786] = Priority(2),	-- Cyclone
		[78675] = Priority(2),	-- Solar Beam
		[80964] = Priority(2),	-- Skull Bash
	-- Hunter
		[1513] = Priority(2),	-- Scare Beast
		[3355] = Priority(2),	-- Freezing Trap Effect
		[19503] = Priority(2),	-- Scatter Shot
		[34490] = Priority(2),	-- Silence Shot
		[19306] = Priority(2),	-- Counterattack
		[19386] = Priority(2),	-- Wyvern Sting
		[24394] = Priority(2),	-- Intimidation
	-- Mage
		[122] = Priority(2),		-- Frost Nova
		[18469] = Priority(2),	-- Silenced - Improved Counterspell
		[31661] = Priority(2),	-- Dragon's Breath
		[55080] = Priority(2),	-- Shattered Barrier
		[61305] = Priority(2),	-- Polymorph
		[82691] = Priority(2),	-- Ring of Frost
	-- Paladin
		[853] = Priority(2),		-- Hammer of Justice
		[2812] = Priority(2),	-- Holy Wrath
		[10326] = Priority(2),	-- Turn Evil
		[20066] = Priority(2),	-- Repentance
	-- Priest
		[605] = Priority(2),		-- Mind Control
		[8122] = Priority(2),	-- Psychic Scream
		[9484] = Priority(2),	-- Shackle Undead
		[15487] = Priority(2),	-- Silence
		[64044] = Priority(2),	-- Psychic Horror
		[64058] = Priority(2),	-- Psychic Horror (Disarm)
	-- Rogue
		[408] = Priority(2),		-- Kidney Shot
		[1776] = Priority(2),	-- Gouge
		[1833] = Priority(2),	-- Cheap Shot
		[2094] = Priority(2),	-- Blind
		[6770] = Priority(2),	-- Sap
		[1330] = Priority(2),	-- Garrote - Silence
		[18425] = Priority(2),	-- Silenced - Improved Kick (Rank 1)
		[86759] = Priority(2),	-- Silenced - Improved Kick (Rank 2)
	-- Shaman
		[3600] = Priority(2),	-- Earthbind
		[8056] = Priority(2),	-- Frost Shock
		[39796] = Priority(2),	-- Stoneclaw Stun
		[51514] = Priority(2),	-- Hex
		[63685] = Priority(2),	-- Freeze
	-- Warlock
		[710] = Priority(2),		-- Banish
		[5484] = Priority(2),	-- Howl of Terror
		[5782] = Priority(2),	-- Fear
		[6358] = Priority(2),	-- Seduction
		[6789] = Priority(2),	-- Death Coil
		[30283] = Priority(2),	-- Shadowfury
		[54786] = Priority(2),	-- Demon Leap
		[89605] = Priority(2),	-- Aura of Foreboding
	-- Warrior
		[12809] = Priority(2),	-- Concussion Blow
		[20511] = Priority(2),	-- Intimidating Shout
		[85388] = Priority(2),	-- Throwdown
		[46968] = Priority(2),	-- Shockwave
	-- Racial
		[20549]	= Priority(2), -- War Stomp
		[28730]	= Priority(2), -- Arcane Torrent (Mana)
		[25046]	= Priority(2), -- Arcane Torrent (Energy)
		[50613]	= Priority(2), -- Arcane Torrent (Runic Power)
	},
}

C.DebuffsTracking_PvP = {
	["type"] = "Whitelist",
	["spells"] = {
	-- Mage
		[45438] = Priority(5),	-- Ice Block
	-- Death Knight
		[48707] = Priority(5),	-- Anti-Magic Shell
		[48792] = Priority(),	-- Icebound Fortitude
		[49039] = Priority(),	-- Lichborne
		[50461] = Priority(),	-- Anti-Magic Zone
		[55233] = Priority(),	-- Vampiric Blood
		[81256] = Priority(4),	-- Dancing Rune Weapon
	-- Priest
		[33206] = Priority(3),	-- Pain Suppression
		[47585] = Priority(5),	-- Dispersion
		[47788] = Priority(),	-- Guardian Spirit
		[62618] = Priority(),	-- Power Word: Barrier
	-- Druid
		[22812] = Priority(2),	-- Barkskin
		[61336] = Priority(),	-- Survival Instinct
	-- Hunter
		[19263] = Priority(5),	-- Deterrence
		[53480] = Priority(),	-- Roar of sacrifice
	-- Rogue
		[1966] = Priority(),		-- Feint
		[5277] = Priority(5),	-- Evasion
		[31224] = Priority(),	-- Cloak of Shadows
		[45182] = Priority(),	-- Cheating Death
		[74001] = Priority(),	-- Combat Readiness
	-- Shaman
		[30823] = Priority(),	-- Shamanistic Rage
		[98007] = Priority(),	-- Spirit Link Totem
	-- Paladin
		[498] = Priority(2),		-- Divine protection
		[642] = Priority(5),		-- Divine shield
		[1022] = Priority(5),	-- Hand Protection
		[1038] = Priority(5),	-- Hand of Salvation
		[1044] = Priority(5),	-- Hand of Freedom
		[6940] = Priority(),		-- Hand of Sacrifice
		[31821] = Priority(3),	-- Aura Mastery
		[70940] = Priority(3),	-- Divine Guardian
	-- Warrior
		[871] = Priority(3),		-- Shield Wall
		[12976] = Priority(),	-- Last Stand
		[55694] = Priority(),	-- Enraged Regeneration
		[97463] = Priority(),	-- Rallying Cry
	},
}