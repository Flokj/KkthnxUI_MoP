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
	-------------------------------------------------
	-------------------- Dungeons -------------------
	-------------------------------------------------
	-- Scholomance
	-- Scarlet Halls
	-- Mogu'shan Palace
	-- Stormstout Brewery
	-- Siege of Niuzao Temple
	-- Scarlet Monastery
	-- Temple of the Jade Serpent
	-- Gate of the Setting Sun
	-- Shado-Pan Monastery
	-------------------------------------------------
	--------------------- Raids ---------------------
	-------------------------------------------------
	-- Mogu'shan Vaults
		-- The Stone Guard
		[125206] = Priority(),	-- Rend Flesh
		[130395] = Priority(),	-- Jasper Chains
		[116281] = Priority(),	-- Cobalt Mine Blast
		-- Feng the Accursed
		[131788] = Priority(),	-- Lightning Lash
		[116942] = Priority(),	-- Flaming Spear
		[131790] = Priority(),	-- Arcane Shock
		[131792] = Priority(),	-- Shadowburn
		[116374] = Priority(),	-- Lightning Charge
		[116784] = Priority(),	-- Wildfire Spark
		[116417] = Priority(),	-- Arcane Resonance
		-- Gara'jal the Spiritbinder
		[122151] = Priority(),	-- Voodoo Doll
		[117723] = Priority(),	-- Frail Soul
		-- The Spirit Kings
		[117708] = Priority(),	-- Maddening Shout
		[118303] = Priority(),	-- Fixate
		[118048] = Priority(),	-- Pillaged
		[118135] = Priority(),	-- Pinned Down
		[118163] = Priority(),	-- Robbed Blind
		-- Elegon
		[117878] = Priority(),	-- Overcharged
		[117949] = Priority(),	-- Closed Circuit
		[132222] = Priority(),	-- Destabilizing Energies
		-- Will of the Emperor
		[116835] = Priority(),	-- Devastating Arc
		[116778] = Priority(),	-- Focused Defense
		[116525] = Priority(),	-- Focused Assault
	-- Heart of Fear
		-- Imperial Vizier Zor'lok
		[122761] = Priority(),	-- Exhale
		[122760] = Priority(),	-- Exhale
		[122740] = Priority(),	-- Convert
		[123812] = Priority(),	-- Pheromones of Zeal
		-- Blade Lord Ta'yak
		[123180] = Priority(),	-- Wind Step
		[123474] = Priority(),	-- Overwhelming Assault
		-- Garalon
		[122835] = Priority(),	-- Pheromones
		[123081] = Priority(),	-- Pungency
		-- Wind Lord Mel'jarak
		[129078] = Priority(),	-- Amber Prison
		[122055] = Priority(),	-- Residue
		[122064] = Priority(),	-- Corrosive Resin
		[123963] = Priority(),	-- Kor'thik Strike
		-- Amber-Shaper Un'sok
		[121949] = Priority(),	-- Parasitic Growth
		[122370] = Priority(),	-- Reshape Life
	-- Terrace of Endless Spring
		-- Protectors of the Endless
		[117436] = Priority(),	-- Lightning Prison
		[118091] = Priority(),	-- Defiled Ground
		[117519] = Priority(),	-- Touch of Sha
		-- Tsulong
		[122752] = Priority(),	-- Shadow Breath
		[123011] = Priority(),	-- Terrorize
		[116161] = Priority(),	-- Crossed Over
		[122777] = Priority(),	-- Nightmares
		[123036] = Priority(),	-- Fright
		-- Lei Shi
		[123121] = Priority(),	-- Spray
		[123705] = Priority(),	-- Scary Fog
		-- Sha of Fear
		[119985] = Priority(),	-- Dread Spray
		[119086] = Priority(),	-- Penetrating Bolt
		[119775] = Priority(),	-- Reaching Attack
		[120669] = Priority(),	-- Naked and Afraid
		[120629] = Priority(),	-- Huddle in Terror
	-- Throne of Thunder
		-- Trash
		[138349] = Priority(),	-- Static Wound
		[137371] = Priority(),	-- Thundering Throw
		-- Jin'rokh the Breaker
		[137162] = Priority(),	-- Static Burst
		[138732] = Priority(),	-- Ionization
		[137422] = Priority(),	-- Focused Lightning
		-- Horridon
		[136767] = Priority(),	-- Triple Puncture
		[136708] = Priority(),	-- Stone Gaze
		[136654] = Priority(),	-- Rending Charge
		[136719] = Priority(),	-- Blazing Sunlight
		[136587] = Priority(),	-- Venom Bolt Volley
		[136710] = Priority(),	-- Deadly Plague
		[136512] = Priority(),	-- Hex of Confusion
		-- Council of Elders
		[137641] = Priority(),	-- Soul Fragment
		[137359] = Priority(),	-- Shadowed Loa Spirit Fixate
		[137972] = Priority(),	-- Twisted Fate
		[136903] = Priority(),	-- Frigid Assault
		[136922] = Priority(),	-- Frostbite
		[136992] = Priority(),	-- Biting Cold
		[136857] = Priority(),	-- Entrapped
		-- Tortos
		[136753] = Priority(),	-- Slashing Talons
		[137633] = Priority(),	-- Crystal Shell
		[140701] = Priority(),	-- Crystal Shell: Full Capacity! (Heroic)
		-- Megaera
		[137731] = Priority(),	-- Ignite Flesh
		[139843] = Priority(),	-- Arctic Freeze
		[139840] = Priority(),	-- Rot Armor
		[134391] = Priority(),	-- Cinder
		[139857] = Priority(),	-- Torrent of Ice
		[140179] = Priority(),	-- Suppression (Heroic)
		-- Ji-Kun
		[134366] = Priority(),	-- Talon Rake
		[140092] = Priority(),	-- Infected Talons
		[134256] = Priority(),	-- Slimed
		-- Durumu the Forgotten
		[133767] = Priority(),	-- Serious Wound
		[133768] = Priority(),	-- Arterial Cut
		[133798] = Priority(),	-- Life Drain
		[133597] = Priority(),	-- Dark Parasite (Heroic)
		-- Primordius
		[136050] = Priority(),	-- Malformed Blood
		[136228] = Priority(),	-- Volatile Pathogen
		-- Dark Animus
		[138569] = Priority(),	-- Explosive Slam
		[138609] = Priority(),	-- Matter Swap
		[138659] = Priority(),	-- Touch of the Animus
		-- Iron Qon
		[134691] = Priority(),	-- Impale
		[136192] = Priority(),	-- Lightning Storm
		[136193] = Priority(),	-- Arcing Lightning
		-- Twin Consorts
		[137440] = Priority(),	-- Icy Shadows
		[137408] = Priority(),	-- Fan of Flames
		[137360] = Priority(),	-- Corrupted Healing
		[136722] = Priority(),	-- Slumber Spores
		[137341] = Priority(),	-- Beast of Nightmares
		-- Lei Shen
		[135000] = Priority(),	-- Decapitate
		[136478] = Priority(),	-- Fusion Slash
		[136914] = Priority(),	-- Electrical Shock
		[135695] = Priority(),	-- Static Shock
		[136295] = Priority(),	-- Overcharged
		[139011] = Priority(),	-- Helm of Command (Heroic)
		-- Ra-den
		[138297] = Priority(),	-- Unstable Vita
		[138329] = Priority(),	-- Unleashed Anima
		[138372] = Priority(),	-- Vita Sensitivity
	-- Siege of Orgrimmar
		-- Immerseus
		[143436] = Priority(),	-- Corrosive Blast
		[143579] = Priority(),	-- Sha Corruption(Heroic)
		-- Fallen Protectors
		[143434] = Priority(),	-- Shadow Word: Bane
		[143198] = Priority(),	-- Garrote
		[143840] = Priority(),	-- Mark of Anguish
		[147383] = Priority(),	-- Debilitation
		-- Norushen
		[146124] = Priority(),	-- Self Doubt
		[144851] = Priority(),	-- Test of Confidence
		[144514] = Priority(),	-- Lingering Corruption
		-- Sha of Pride
		[144358] = Priority(),	-- Wounded Pride
		[144774] = Priority(),	-- Reaching Attacks
		[147207] = Priority(),	-- Weakened Resolve(Heroic)
		[144351] = Priority(),	-- Mark of Arrogance
		[146594] = Priority(),	-- Gift of the Titans
		-- Galakras
		[147029] = Priority(),	-- Flames of Galakrond
		[146902] = Priority(),	-- Poison-Tipped Blades
		-- Iron Juggernaut
		[144467] = Priority(),	-- Ignite Armor
		[144459] = Priority(),	-- Laser Burn
		-- Kor'kron Dark Shaman
		[144215] = Priority(),	-- Froststorm Strike
		[143990] = Priority(),	-- Foul Geyser
		[144330] = Priority(),	-- Iron Prison(Heroic)
		[144089] = Priority(),	-- Toxic Mist
		-- General Nazgrim
		[143494] = Priority(),	-- Sundering Blow
		[143638] = Priority(),	-- Bonecracker
		[143431] = Priority(),	-- Magistrike
		[143480] = Priority(),	-- Assassin's Mark
		-- Malkorok
		[142990] = Priority(),	-- Fatal Strike
		[143919] = Priority(),	-- Languish(Heroic)
		[142864] = Priority(),	-- Ancient Barrier
		[142865] = Priority(),	-- Strong Ancient Barrier
		[142913] = Priority(),	-- Displaced Energy
		-- Spoils of Pandaria
		[145218] = Priority(),	-- Harden Flesh
		[146235] = Priority(),	-- Breath of Fire
		-- Thok the Bloodthirsty
		[143766] = Priority(),	-- Panic
		[143773] = Priority(),	-- Freezing Breath
		[146589] = Priority(),	-- Skeleton Key
		[143777] = Priority(),	-- Frozen Solid
		[143780] = Priority(),	-- Acid Breath
		[143800] = Priority(),	-- Icy Blood
		[143767] = Priority(),	-- Scorching Breath
		[143791] = Priority(),	-- Corrosive Blood
		-- Siegecrafter Blackfuse
		[143385] = Priority(),	-- Electrostatic Charge
		[144236] = Priority(),	-- Pattern Recognition
		-- Paragons of the Klaxxi
		[143974] = Priority(),	-- Shield Bash
		[142315] = Priority(),	-- Caustic Blood
		[143701] = Priority(),	-- Whirling
		[142948] = Priority(),	-- Aim
		-- Garrosh Hellscream
		[145183] = Priority(),	-- Gripping Despair
		[145195] = Priority(),	-- Empowered Gripping Despair
		[145065] = Priority(),	-- Touch of Y'Shaarj
		[145171] = Priority(),	-- Empowered Touch of Y'Shaarj
	},
}

C.DebuffsTracking_PvP = {
	["type"] = "Whitelist",
	["spells"] = {
	-- These are debuffs that are some form of CC
	-- Death Knight
		[47476] = Priority(2),	-- Strangulate
		[49203] = Priority(2),	-- Hungering Cold
	-- Druid
		[339] = Priority(2),	-- Entangling Roots
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
		[122] = Priority(2),	-- Frost Nova
		[18469] = Priority(2),	-- Silenced - Improved Counterspell
		[31661] = Priority(2),	-- Dragon's Breath
		[55080] = Priority(2),	-- Shattered Barrier
		[61305] = Priority(2),	-- Polymorph
		[82691] = Priority(2),	-- Ring of Frost
	-- Paladin
		[853] = Priority(2),	-- Hammer of Justice
		[2812] = Priority(2),	-- Holy Wrath
		[10326] = Priority(2),	-- Turn Evil
		[20066] = Priority(2),	-- Repentance
	-- Priest
		[605] = Priority(2),	-- Mind Control
		[8122] = Priority(2),	-- Psychic Scream
		[9484] = Priority(2),	-- Shackle Undead
		[15487] = Priority(2),	-- Silence
		[64044] = Priority(2),	-- Psychic Horror
		[64058] = Priority(2),	-- Psychic Horror (Disarm)
	-- Rogue
		[408] = Priority(2),	-- Kidney Shot
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
		[710] = Priority(2),	-- Banish
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
	-- Monk
		[116706] = Priority(),	-- Disable
		[117368] = Priority(),	-- Grapple Weapon
		[115078] = Priority(),	-- Paralysis
		[122242] = Priority(),	-- Clash
		[119392] = Priority(),	-- Charging Ox Wave
		[119381] = Priority(),	-- Leg Sweep
		[120086] = Priority(),	-- Fists of Fury
		[116709] = Priority(),	-- Spear Hand Strike
		[123407] = Priority(),	-- Spinning Fire Blossom
		[140023] = Priority(),	-- Ring of Peace
	-- Racial
		[20549]	= Priority(2), -- War Stomp
		[28730]	= Priority(2), -- Arcane Torrent (Mana)
		[25046]	= Priority(2), -- Arcane Torrent (Energy)
		[50613]	= Priority(2), -- Arcane Torrent (Runic Power)

	-- These are buffs that can be considered 'protection' buffs
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
		[1966] = Priority(),	-- Feint
		[5277] = Priority(5),	-- Evasion
		[31224] = Priority(),	-- Cloak of Shadows
		[45182] = Priority(),	-- Cheating Death
		[74001] = Priority(),	-- Combat Readiness
	-- Shaman
		[30823] = Priority(),	-- Shamanistic Rage
		[98007] = Priority(),	-- Spirit Link Totem
	-- Paladin
		[498] = Priority(2),	-- Divine protection
		[642] = Priority(5),	-- Divine shield
		[1022] = Priority(5),	-- Hand Protection
		[1038] = Priority(5),	-- Hand of Salvation
		[1044] = Priority(5),	-- Hand of Freedom
		[6940] = Priority(),	-- Hand of Sacrifice
		[31821] = Priority(3),	-- Aura Mastery
		[70940] = Priority(3),	-- Divine Guardian
	-- Warrior
		[871] = Priority(3),	-- Shield Wall
		[12976] = Priority(),	-- Last Stand
		[55694] = Priority(),	-- Enraged Regeneration
		[97463] = Priority(),	-- Rallying Cry
	-- Monk
		[120954] = Priority(),	-- Fortifying Brew
		[131523] = Priority(),	-- Zen Meditation
		[122783] = Priority(),	-- Diffuse Magic
		[122278] = Priority(),	-- Dampen Harm
		[115213] = Priority(),	-- Avert Harm
		[116849] = Priority(),	-- Life Cocoon
	},
}