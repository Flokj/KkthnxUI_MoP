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
		[55741] = Priority(1), -- Desecration
		[47481] = Priority(2), -- Gnaw (Ghoul)
		[49203] = Priority(3), -- Hungering Cold
		[47476] = Priority(2), -- Strangulate
		[53534] = Priority(2), -- Chains of Ice
		-- Druid
		[339] = Priority(1), -- Entangling Roots
		[19975] = Priority(1), -- Entangling Roots (Nature's Grasp)
		[2637] = Priority(1), -- Hibernate
		[45334] = Priority(2), -- Feral Charge Effect
		[5211] = Priority(4), -- Bash
		[9005] = Priority(2), -- Pounce
		[770] = Priority(5), -- Faerie Fire
		[16857] = Priority(5), -- Faerie Fire (Feral)
		[22570] = Priority(4), -- Maim
		[33786] = Priority(5), -- Cyclone
		[50259] = Priority(2), -- Dazed (Feral Charge - Cat)
		[61391] = Priority(2), -- Typhoon
		-- Hunter
		[3355] = Priority(3), -- Freezing Trap Effect
		[13810] = Priority(1), -- Frost Trap Aura
		[19503] = Priority(4), -- Scatter Shot
		[5116] = Priority(2), -- Concussive Shot
		[2974] = Priority(2), -- Wing Clip
		[1513] = Priority(2), -- Scare Beast
		[24394] = Priority(2), -- Intimidation
		[19386] = Priority(2), -- Wyvern Sting
		[19306] = Priority(2), -- Counterattack
		[34490] = Priority(2), -- Silencing Shot
		[25999] = Priority(2), -- Charge (Boar)
		[19185] = Priority(1), -- Entrapment
		[35101] = Priority(2), -- Concussive Barrage
		[61394] = Priority(2), -- Glyph of Freezing Trap
		-- Mage
		[118] = Priority(3), -- Polymorph
		[28271] = Priority(3), -- Polymorph (Turtle)
		[28272] = Priority(3), -- Polymorph (Pig)
		[59634] = Priority(3), -- Polymorph (Penguin)
		[61305] = Priority(3), -- Polymorph (Black Cat)
		[61721] = Priority(3), -- Polymorph (Rabbit)
		[61780] = Priority(3), -- Polymorph (Turkey)
		[31661] = Priority(3), -- Dragon's Breath
		[122] = Priority(1), -- Frost Nova
		[116] = Priority(2), -- Frostbolt
		[12355] = Priority(2), -- Impact
		[18469] = Priority(2), -- Silenced - Improved Counterspell
		[33395] = Priority(1), -- Freeze (Water Elemental)
		[64346] = Priority(2), -- Fiery Payback
		[11113] = Priority(2), -- Blast Wave
		[12484] = Priority(2), -- Chilled (Blizzard)
		[6136] = Priority(2), -- Chilled (Frost Armor)
		[7321] = Priority(2), -- Chilled (Ice Armor)
		[120] = Priority(2), -- Cone of Cold
		[44572] = Priority(3), -- Deep Freeze
		[64346] = Priority(2), -- Fiery Payback
		[44614] = Priority(2), -- Frostfire Bolt
		[31589] = Priority(2), -- Slow
		-- Paladin
		[853] = Priority(3), -- Hammer of Justice
		[20066] = Priority(3), -- Repentance
		[20170] = Priority(2), -- Stun (Seal of Justice Proc)
		[10326] = Priority(3), -- Turn Evil
		[63529] = Priority(2), -- Silenced - Shield of the Templar
		[31935] = Priority(2), -- Avenger's Shield
		-- Priest
		[8122] = Priority(3), -- Psychic Scream
		[605] = Priority(5), -- Mind Control
		[15407] = Priority(2), -- Mind Flay
		[9484] = Priority(3), -- Shackle Undead
		[64044] = Priority(1), -- Psychic Horror
		[64058] = Priority(1), -- Psychic Horror (Disarm)
		[15487] = Priority(2), -- Silence
		-- Rogue
		[6770] = Priority(4), -- Sap
		[2094] = Priority(5), -- Blind
		[408] = Priority(4), -- Kidney Shot
		[1833] = Priority(2), -- Cheap Shot
		[1776] = Priority(2), -- Gouge
		[1330] = Priority(2), -- Garrote - Silence
		[18425] = Priority(2), -- Silenced - Improved Kick
		[51722] = Priority(2), -- Dismantle
		[31125] = Priority(2), -- Blade Twisting
		[3409] = Priority(2), -- Crippling Poison
		[26679] = Priority(2), -- Deadly Throw
		[32747] = Priority(2), -- Interrupt (Deadly Throw)
		[51693] = Priority(2), -- Waylay
		-- Shaman
		[2484] = Priority(1), -- Earthbind Totem
		[8056] = Priority(2), -- Frost Shock
		[39796] = Priority(2), -- Stoneclaw Totem
		[58861] = Priority(2), -- Bash (Spirit Wolf)
		[51514] = Priority(3), -- Hex
		[8034] = Priority(2), -- Frostbrand Attack
		-- Warlock
		[5782] = Priority(3), -- Fear
		[6358] = Priority(3), -- Seduction (Succubus)
		[18223] = Priority(2), -- Curse of Exhaustion
		[710] = Priority(2), -- Banish
		[30283] = Priority(2), -- Shadowfury
		[6789] = Priority(3), -- Death Coil
		[5484] = Priority(3), -- Howl of Terror
		[24259] = Priority(2), -- Spell Lock (Felhunter)
		[18118] = Priority(2), -- Aftermath
		[20812] = Priority(2), -- Cripple (Doomguard)
		[60995] = Priority(2), -- Demon Charge (Metamorphosis)
		[1098] = Priority(5), -- Enslave Demon
		[63311] = Priority(2), -- Glyph of Shadowflame
		[30153] = Priority(2), -- Intercept (Felguard)
		[31117] = Priority(2), -- Unstable Affliction (Silence)
		-- Warrior
		[20511] = Priority(4), -- Intimidating Shout (Cower)
		[5246] = Priority(4), -- Intimidating Shout (Fear)
		[1715] = Priority(2), -- Hamstring
		[12809] = Priority(2), -- Concussion Blow
		[20253] = Priority(2), -- Intercept Stun
		[7386] = Priority(6), -- Sunder Armor
		[7922] = Priority(2), -- Charge Stun
		[18498] = Priority(2), -- Silenced - Gag Order
		[46968] = Priority(3), -- Shockwave
		[23694] = Priority(2), -- Improved Hamstring
		[58373] = Priority(2), -- Glyph of Hamstring
		[676] = Priority(2), -- Disarm
		[12323] = Priority(2), -- Piercing Howl
		-- Racial
		[20549] = Priority(2), -- War Stomp
		[28730] = Priority(2), -- Arcane Torrent (Mana)
		[25046] = Priority(2), -- Arcane Torrent (Energy)
		[50613] = Priority(2), -- Arcane Torrent (Runic Power)
	},
}

C.DebuffsTracking_PvP = {
	["type"] = "Whitelist",
	["spells"] = {
		-- Death Knight
		[48707] = Priority(), -- Anti-Magic Shell
		[51052] = Priority(), -- Anti-Magic Zone
		[49222] = Priority(), -- Bone Shield
		[49028] = Priority(), -- Dancing Rune Weapon
		[63560] = Priority(), -- Ghoul Frenzy (Ghoul)
		[48792] = Priority(), -- Icebound Fortitude
		[49039] = Priority(), -- Lichborne
		[61777] = Priority(), -- Summon Gargoyle
		[51271] = Priority(), -- Unbreakable Armor
		[55233] = Priority(), -- Vampiric Blood
		-- Druid
		[29166] = Priority(), -- Innervate
		[22812] = Priority(), -- Barkskin
		[17116] = Priority(), -- Nature's Swiftness
		[16689] = Priority(), -- Nature's Grasp
		[16864] = Priority(), -- Omen of Clarity
		[5217] = Priority(), -- Tiger's Fury
		[5229] = Priority(), -- Enrage
		[1850] = Priority(), -- Dash
		[50334] = Priority(), -- Berserk
		[48505] = Priority(), -- Starfall
		[61336] = Priority(), -- Survival Instincts
		[740] = Priority(), -- Tranquility
		-- Hunter
		[5118] = Priority(), -- Aspect of the Cheetah
		[13159] = Priority(), -- Aspect of the Pack
		[20043] = Priority(), -- Aspect of the Wild
		[3045] = Priority(), -- Rapid Fire
		[19263] = Priority(), -- Deterrence
		[13165] = Priority(), -- Aspect of the Hawk
		[19574] = Priority(), -- Bestial Wrath
		[35098] = Priority(), -- Rapid Killing
		[34471] = Priority(), -- The Beast Within
		-- Mage
		[45438] = Priority(), -- Ice Block
		[12043] = Priority(), -- Presence of Mind
		[12042] = Priority(), -- Arcane Power
		[11426] = Priority(), -- Ice Barrier
		[12472] = Priority(), -- Icy Veins
		[66] = Priority(), -- Invisibility
		[55342] = Priority(), -- Mirror Image
		-- Paladin
		[1044] = Priority(), -- Hand of Freedom
		[1038] = Priority(), -- Hand of Salvation
		[465] = Priority(), -- Devotion Aura
		[19746] = Priority(), -- Concentration Aura
		[7294] = Priority(), -- Retribution Aura
		[19891] = Priority(), -- Fire Resistance Aura
		[498] = Priority(), -- Divine Protection
		[642] = Priority(), -- Divine Shield
		[1022] = Priority(), -- Hand of Protection
		[31821] = Priority(), -- Aura Mastery
		[70940] = Priority(), -- Divine Guardian
		[64205] = Priority(), -- Divine Sacrifice
		[6940] = Priority(), -- Hand of Sacrifice
		[31884] = Priority(), -- Avenging Wrath
		[31842] = Priority(), -- Divine Illumination
		-- Priest
		[15473] = Priority(), -- Shadowform
		[10060] = Priority(), -- Power Infusion
		[14751] = Priority(), -- Inner Focus
		[1706] = Priority(), -- Levitate
		[586] = Priority(), -- Fade
		[64843] = Priority(), -- Divine Hymn
		[47788] = Priority(), -- Guardian Spirit
		[64901] = Priority(), -- Hymn of Hope
		[47585] = Priority(), -- Dispersion
		-- Rogue
		[14177] = Priority(), -- Cold Blood
		[13877] = Priority(), -- Blade Flurry
		[13750] = Priority(), -- Adrenaline Rush
		[2983] = Priority(), -- Sprint
		[5171] = Priority(), -- Slice and Dice
		[45182] = Priority(), -- Cheating Death
		[51690] = Priority(), -- Killing Spree
		[51713] = Priority(), -- Shadow Dance
		[57933] = Priority(), -- Tricks of the Trade
		[31224] = Priority(), -- Cloak of Shadows
		[5277] = Priority(), -- Evasion
		[1856] = Priority(), -- Vanish
		-- Shaman
		[2645] = Priority(), -- Ghost Wolf
		[324] = Priority(), -- Lightning Shield
		[16188] = Priority(), -- Nature's Swiftness
		[16166] = Priority(), -- Elemental Mastery
		[52127] = Priority(), -- Water Shield
		[974] = Priority(), -- Earth Shield
		[30823] = Priority(), -- Shamanistic Rage
		[8178] = Priority(), -- Grounding Totem Effect
		[16191] = Priority(), -- Mana Tide
		[55198] = Priority(), -- Tidal Force
		-- Warlock
		[18789] = Priority(), -- Demonic Sacrifice (Burning Wish)
		[18790] = Priority(), -- Demonic Sacrifice (Fel Stamina)
		[18791] = Priority(), -- Demonic Sacrifice (Touch of Shadow)
		[18792] = Priority(), -- Demonic Sacrifice (Fel Energy)
		[35701] = Priority(), -- Demonic Sacrifice (Touch of Shadow)
		[5697] = Priority(), -- Unending Breath
		[6512] = Priority(), -- Detect Lesser Invisibility
		[25228] = Priority(), -- Soul Link
		[18708] = Priority(), -- Fel Domination
		[47241] = Priority(), -- Metamorphosis
		-- Warrior
		[12975] = Priority(), -- Last Stand
		[871] = Priority(), -- Shield Wall
		[20230] = Priority(), -- Retaliation
		[1719] = Priority(), -- Recklessness
		[18499] = Priority(), -- Berserker Rage
		[12292] = Priority(), -- Death Wish
		[12328] = Priority(), -- Sweeping Strikes
		[2565] = Priority(), -- Shield Block
		[12880] = Priority(), -- Enrage
		[46924] = Priority(), -- Bladestorm
		[23920] = Priority(), -- Spell Reflection
		-- Consumables
		[3169] = Priority(), -- Limited Invulnerability Potion
		[6615] = Priority(), -- Free Action Potion
		-- Racial
		[26297] = Priority(), -- Berserking
		[7744] = Priority(), -- Will of the Forsaken
		[20572] = Priority(), -- Blood Fury (Physical)
		[33697] = Priority(), -- Blood Fury (Both)
		[33702] = Priority(), -- Blood Fury (Spell)
		[6346] = Priority(), -- Fear Ward
		[20594] = Priority(), -- Stoneform
		[28880] = Priority(), -- Gift of the Naaru
	},
}