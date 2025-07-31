local C = KkthnxUI[2]

C.NameplateWhiteList = {
    
    -- Source Big Debuffs
    -- Racials

    [20549] = true, --{ type = CROWD_CONTROL }, -- War Stomp
    [28730] = true, --{ type = CROWD_CONTROL, }, -- Arcane Torrent (Mana)
    [25046] = true, --{ type = CROWD_CONTROL, }, -- Arcane Torrent (Energy)
    [50613] = true, --{ type = CROWD_CONTROL, }, -- Arcane Torrent (Runic Power)
    [107079] = true, --{ type = CROWD_CONTROL }, -- Quaking Palm (Pandarian)
    [20594] = true, --{ type = BUFF_OFFENSIVE }, -- Stoneform
    [20572] = true, --{ type = BUFF_OFFENSIVE }, -- Blood Fury
    [7744] = true, --{ type = BUFF_OFFENSIVE }, -- Will of the Forsaken
    [58984] = true, --{ type = BUFF_DEFENSIVE }, -- Shadowmeld

    -- Other

    [30457] = true, --{ type = CROWD_CONTROL }, -- Complete Vulnerability
    [1090] = true, --{ type = CROWD_CONTROL }, -- Magic Dust
    [13327] = true, --{ type = CROWD_CONTROL }, -- Reckless Charge
    [835] = true, --{ type = CROWD_CONTROL }, -- Tidal Charm
    [5134] = true, --{ type = CROWD_CONTROL }, -- Flash Bomb
    [19769] = true, --{ type = CROWD_CONTROL }, -- Thorium Grenade
    [4068] = true, --{ type = CROWD_CONTROL }, -- Iron Grenade
    [15753] = true, --{ type = CROWD_CONTROL }, -- Linken's Boomerang Stun
    [13237] = true, --{ type = CROWD_CONTROL }, -- Goblin Mortar trinket
    [18798] = true, --{ type = CROWD_CONTROL }, -- Freezing Band
    [129597] = true, --{ type = CROWD_CONTROL }, -- Arcane Torrent (Chi)

    [23505] = true, --{ type = BUFF_OFFENSIVE }, -- Battleground Damage buff
    [23723] = true, --{ type = BUFF_OFFENSIVE }, -- Mind Quickening Gem
    [23451] = true, --{ type = BUFF_OFFENSIVE }, -- Battleground Speed buff
    [6615] = true, --{ type = BUFF_OFFENSIVE }, -- Free Action Potion
    [24364] = true, --{ type = BUFF_OFFENSIVE }, -- Living Action Potion
    [11359] = true, --{ type = BUFF_OFFENSIVE }, -- Restorative Potion
    [5024] = true, --{ type = BUFF_OFFENSIVE }, -- Skull of Impending Doom
    [2379] = true, --{ type = BUFF_OFFENSIVE }, -- Swiftness Potion
    [23097] = true, --{ type = BUFF_OFFENSIVE }, -- Fire Reflector
    [23131] = true, --{ type = BUFF_OFFENSIVE }, -- Frost Reflector
    [23132] = true, --{ type = BUFF_OFFENSIVE }, -- Shadow Reflector
    [12733] = true, --{ type = BUFF_OFFENSIVE }, -- Blacksmith trinket, Fear immunity
    [14530] = true, --{ type = BUFF_OFFENSIVE }, -- Nifty Stopwatch
    [14253] = true, --{ type = BUFF_OFFENSIVE }, -- Black Husk Shield
    [9175] = true, --{ type = BUFF_OFFENSIVE }, -- Swift Boots
    [13141] = true, --{ type = BUFF_OFFENSIVE }, -- Gnomish Rocket Boots
    [8892] = true, --{ type = BUFF_OFFENSIVE }, -- Goblin Rocket Boots
    [9774] = true, --{ type = BUFF_OFFENSIVE }, -- Spider Belt & Ornate Mithril Boots
    [13494] = true, --{ type = BUFF_OFFENSIVE }, -- Manual Crowd Pummeler Haste buff
    [30456] = true, --{ type = BUFF_DEFENSIVE }, -- Nigh-Invulnerability
    [23493] = true, --{ type = BUFF_DEFENSIVE }, -- Battleground Heal buff
    [23506] = true, --{ type = BUFF_DEFENSIVE }, -- Arena Grand Master trinket
    [29506] = true, --{ type = BUFF_DEFENSIVE }, -- Burrower's Shell trinket
    [22734] = true, --{ type = BUFF_OTHER }, -- Drink
        [46755] = true, --{ parent = 22734 }, -- Drink
        [27089] = true, --{ parent = 22734 }, -- Drink
        [43183] = true, --{ parent = 22734 }, -- Drink
        [57073] = true, --{ parent = 22734 }, -- Drink
    [23605] = true, --{ type = BUFF_OTHER }, -- Nightfall, Spell Vulnerability
    [3169] = true, --{ type = IMMUNITY }, -- Limited Invulnerability Potion
    [16621] = true, --{ type = IMMUNITY }, -- Invulnerable Mail

    [33961] = true, --{ type = IMMUNITY_SPELL }, -- Spell Reflection (Sethekk Initiate)
    -- MoP
    [126679] = true, --{ type = BUFF_OFFENSIVE }, -- Call of Victory
    [126690] = true, --{ type = BUFF_OFFENSIVE }, -- Call of Conquest
    [126683] = true, --{ type = BUFF_OFFENSIVE }, -- Call of Dominance

    -- Interrupts

    [15752] = true, --{ type = INTERRUPT, duration = 10 }, -- Linken's Boomerang Disarm
    [19647] = true, --{ type = INTERRUPT, duration = 6 }, -- Spell Lock - Rank 2 (Warlock)
    [13491] = true, --{ type = INTERRUPT, duration = 5 }, -- Iron Knuckles
    [16979] = true, --{ type = INTERRUPT, duration = 4 }, -- Feral Charge (Druid)
    [2139] = true, --{ type = INTERRUPT, duration = 8 }, -- Counterspell (Mage)
    [1766] = true, --{ type = INTERRUPT, duration = 5 }, -- Kick (Rogue)
    [26679] = true, --{ type = INTERRUPT, duration = 3 }, -- Deadly Throw
    [6552] = true, --{ type = INTERRUPT, duration = 4 }, -- Pummel
    [29443] = true, --{ type = INTERRUPT, duration = 10 }, -- Clutch of Foresight
    [80965] = true, --{ type = INTERRUPT, duration = 4 }, -- Skull Bash (Cat)
    [80964] = true, --{ type = INTERRUPT, duration = 4 }, -- Skull Bash (Bear)

    -- Death Knight

    --[45524] = true, --{ type = ROOT }, -- Chains of Ice
    [47476] = true, --{ type = CROWD_CONTROL, },  -- Strangulate
    [91800] = true, --{ type = CROWD_CONTROL, },  -- Gnaw
    [47484] = true, --{ type = BUFF_DEFENSIVE, }, -- Huddle (Ghoul)
    [47528] = true, --{ type = INTERRUPT, duration = 4, },  -- Mind Freeze
    [48707] = true, --{ type = IMMUNITY_SPELL, },  -- Anti-Magic Shell
    [48792] = true, --{ type = BUFF_DEFENSIVE, },  -- Icebound Fortitude
    [49028] = true, --{ type = BUFF_OFFENSIVE, },  -- Dancing Rune Weapon // might not work - spell id vs aura
    [49039] = true, --{ type = IMMUNITY_SPELL, },  -- Lichborne
    [50461] = true, --{ type = BUFF_DEFENSIVE, },  -- Anti-Magic Zone
    [49016] = true, --{ type = BUFF_OFFENSIVE, },  -- Unholy Frenzy
    [91802] = true, --{ type = INTERRUPT, duration = 2 },  -- Shambling Rush (pet dk kick)
    [91797] = true, --{ type = CROWD_CONTROL },  -- Monstrous Blow (dk abom stun)
    -- Cataclysm
    [49206] = true, --{ type = DEBUFF_OFFENSIVE, },  -- Summon Gargoyle
    -- MoP
    [108194] = true, --{ type = CROWD_CONTROL, },  -- Asphyxiate
    [115001] = true, --{ type = CROWD_CONTROL, },  -- Remorseless Winter
    --[96294] = true, --{ type = ROOT }, -- Chains of Ice (Chilblains)
    --[50435] = true, --{ type = ROOT }, -- Chilblains
    --[115000] = true, --{ type = ROOT }, -- Remorseless Winter
    [115018] = true, --{ type = IMMUNITY }, -- Desecrated Ground
    [51271] = true, --{ type = BUFF_OFFENSIVE, },  -- Pillar of Frost
    --[91807] = true, --{ type = ROOT }, -- Shambling Rush (Dark Transformation)

    -- Priest

    -- WoTLK
    [20711] = true, --{ type = BUFF_DEFENSIVE, },  -- Spirit of Redemption
    [47585] = true, --{ type = IMMUNITY, },  -- Dispersion
    [47788] = true, --{ type = BUFF_DEFENSIVE, },  -- Guardian Spirit
    [64044] = true, --{ type = CROWD_CONTROL, }, -- Psychic Horror (Horrify)
    [64058] = true, --{ type = CROWD_CONTROL, }, -- Psychic Horror (Disarm)
    [64843] = true, --{ type = BUFF_DEFENSIVE, },  -- Divine Hymn
    [64901] = true, --{ type = BUFF_DEFENSIVE, }, -- Hymn of Hope

    [17] = true, --{ type = BUFF_DEFENSIVE }, -- Power Word: Shield
    [605] = true, --{ type = CROWD_CONTROL }, -- Mind Control
    [8122] = true, --{ type = CROWD_CONTROL }, -- Psychic Scream
    [10060] = true, --{ type = BUFF_OFFENSIVE }, -- Power Infusion
    [15487] = true, --{ type = CROWD_CONTROL }, -- Silence
    [6346] = true, --{ type = BUFF_DEFENSIVE }, -- Fear Ward
    [9484] = true, --{ type = CROWD_CONTROL }, -- Shackle Undead
    [27827] = true, --{ type = IMMUNITY }, -- Spirit of Redemption
    [33206] = true, --{ type = BUFF_DEFENSIVE }, -- Pain Suppression
    [87204] = true, --{ type = CROWD_CONTROL }, -- Sin and Punishment (VT dispel)
    [96267] = true, --{ type = BUFF_DEFENSIVE }, -- Strength of Soul
    -- MoP
    [113506] = true, --{ type = CROWD_CONTROL }, -- Cyclone (Symbiosis)
    [113792] = true, --{ type = CROWD_CONTROL }, -- Psychic Terror (Psyfiend)
    -- [113275] = true, --{ type = ROOT }, -- Entangling Roots (Symbiosis)
    --[114404] = true, --{ type = ROOT }, -- Void Tendril's Grasp
    [114239] = true, --{ type = IMMUNITY_SPELL }, -- Phantasm
    [88625] = true, --{ type = CROWD_CONTROL }, -- Holy Word: Chastise

    -- Warlock
    -- WoTLK
    [24259] = true, --{ type = CROWD_CONTROL }, -- Spell Lock Silence
    [6358] = true, --{ type = CROWD_CONTROL }, -- Seduction
    [5782] = true, --{ type = CROWD_CONTROL }, -- Fear
    [5484] = true, --{ type = CROWD_CONTROL }, -- Howl of Terror
    [710] = true, --{ type = CROWD_CONTROL }, -- Banish
    [6789] = true, --{ type = CROWD_CONTROL }, -- Death Coil
    [6229] = true, --{ type = BUFF_DEFENSIVE }, -- Shadow Ward
    [7812] = true, --{ type = BUFF_DEFENSIVE }, -- Sacrifice
    --[18223] = true, --{ type = ROOT }, -- Curse of Exhaustion
    --[1714] = true, --{ type = ROOT }, -- Curse of Tongues
    [22703] = true, --{ type = CROWD_CONTROL }, -- Inferno Effect
    [30283] = true, --{ type = CROWD_CONTROL }, -- Shadowfury
    [43523] = true, --{ type = CROWD_CONTROL }, -- Unstable Affliction
        [31117] = true, --{ parent = 43523 },
    [32752] = true, --{ type = CROWD_CONTROL }, -- Summoning Disorientation
    [89766] = true, --{ type = CROWD_CONTROL }, -- Axe Toss (felguard stun)
    -- MoP
    [137143] = true, --{ type = BUFF_DEFENSIVE }, -- Blood Horror
    [130616] = true, --{ type = CROWD_CONTROL }, -- Fear (Glyph of Fear)
    [132412] = true, --{ type = CROWD_CONTROL }, -- Seduction (Grimoire of Sacrifice)
    [104045] = true, --{ type = CROWD_CONTROL }, -- Sleep (Metamorphosis)
    [132409] = true, --{ type = CROWD_CONTROL }, -- Spell Lock (Grimoire of Sacrifice)
    [110913] = true, --{ type = BUFF_DEFENSIVE }, -- Dark Bargain
    [104773] = true, --{ type = BUFF_DEFENSIVE }, -- Unending Resolve
    [115268] = true, --{ type = CROWD_CONTROL }, -- Mesmerize (Shivarra)
    [115782] = true, --{ type = CROWD_CONTROL }, -- Optical Blast (Observer)
    [118093] = true, --{ type = CROWD_CONTROL }, -- Disarm (Voidwalker/Voidlord)
    [118699] = true, --{ type = CROWD_CONTROL }, -- Fear (new?)

    -- Shaman

    -- WoTLK
    [2825] = true, --{ type = BUFF_OFFENSIVE },  -- Bloodlust
    [16191] = true, --{ type = BUFF_OFFENSIVE }, -- Mana Tide Totem
    [32182] = true, --{ type = BUFF_OFFENSIVE },  -- Heroism
    [51514] = true, --{ type = CROWD_CONTROL, },  -- Hex
    [57994] = true, --{ type = INTERRUPT, duration = 2, },  -- Wind Shear
    [58875] = true, --{ type = BUFF_OTHER, }, -- Spirit Walk (Spirit Wolf)
    --[63685] = true, --{ type = ROOT, }, -- Freeze (Enhancement)
    --[64695] = true, --{ type = ROOT, }, -- Earthgrab (Elemental)

    [8178] = true, --{ type = IMMUNITY_SPELL }, -- Grounding Totem Effect
    [16188] = true, --{ type = BUFF_DEFENSIVE }, -- Nature's Swiftness
    --[12548] = true, --{ type = ROOT }, -- Frost Shock
    [16166] = true, --{ type = BUFF_OFFENSIVE }, -- Elemental Mastery
    [30823] = true, --{ type = BUFF_DEFENSIVE }, -- Shamanistic Rage
    -- MoP
    [118905] = true, --{ type = CROWD_CONTROL },  -- Static Charge (Capacitor Totem)
    [113287] = true, --{ type = CROWD_CONTROL },  -- Solar Beam (Symbiosis)
    --[116947] = true, --{ type = ROOT },  -- Earthbind (Earthgrab Totem)
    [118345] = true, --{ type = CROWD_CONTROL },  -- Pulverize (Primal Earth Elemental)
    [110806] = true, --{ type = BUFF_OTHER },  -- Spiritwalker's Grace

    -- Paladin
    -- WoTLK
    [25771] = true, --{ type = BUFF_OTHER, }, -- Forbearance
    [31821] = true, --{ type = BUFF_DEFENSIVE, },  -- Aura Mastery
    [54428] = true, --{ type = BUFF_OTHER, }, -- Divine Plea
    [59578] = true, --{ type = BUFF_OTHER, }, -- The Art of War
    [31935] = true, --{ type = CROWD_CONTROL, }, -- Silenced - Avenger's Shield

    [1022] = true, --{ type = IMMUNITY },-- Blessing of Protection
    [498] = true, --{ type = BUFF_DEFENSIVE }, -- Divine Protection
    [642] = true, --{ type = IMMUNITY }, -- Divine Shield
    [853] = true, --{ type = CROWD_CONTROL }, -- Hammer of Justice
    [1044] = true, --{ type = BUFF_DEFENSIVE }, -- Blessing of Freedom
    [20066] = true, --{ type = CROWD_CONTROL }, -- Repentance
    --[20170] = true, --{ type = ROOT }, -- Seal of Justice slow
    [6940] = true, --{ type = BUFF_DEFENSIVE }, -- Blessing of Sacrifice
    [10326] = true, --{ type = CROWD_CONTROL }, -- Turn Evil
    [31884] = true, --{ type = BUFF_OFFENSIVE }, -- Avenging Wrath
    [31842] = true, --{ type = BUFF_DEFENSIVE }, -- Divine Illumination

    -- Cataclysm
    [96231] = true, --{ type = INTERRUPT, duration = 4 }, -- Rebuke

    -- MoP
    [105421] = true, --{ type = CROWD_CONTROL }, -- Blinding Light
    [115752] = true, --{ type = CROWD_CONTROL }, -- Blinding Light (Glyph of Blinding Light)
    [105593] = true, --{ type = CROWD_CONTROL }, -- Fist of Justice
    [119072] = true, --{ type = CROWD_CONTROL }, -- Holy Wrath
    [145067] = true, --{ type = CROWD_CONTROL }, -- Turn Evil (Evil is a Point of View)
    --[110300] = true, --{ type = ROOT }, -- Burden of Guilt

    -- Hunter

    -- WoTLK
    [1742] = true, --{ type = BUFF_DEFENSIVE, }, -- Cower (Pet)
    [26064] = true, --{ type = BUFF_DEFENSIVE, }, -- Shell Shield (Pet)
    [26090] = true, --{ type = INTERRUPT, duration = 2, }, -- Pummel (Pet)
    [53271] = true, --{ type = BUFF_DEFENSIVE, },  -- Master's Call
    [53476] = true, --{ type = BUFF_DEFENSIVE, }, -- Intervene (Pet)
    [53480] = true, --{ type = BUFF_DEFENSIVE, },  -- Roar of Sacrifice (Hunter Pet Skill)

    [13159] = true, --{ type = BUFF_OFFENSIVE }, -- Aspect of the Pack
        [5118] = true, --{ parent = 13159 }, -- Aspect of the Cheetah
    [1513] = true, --{ type = CROWD_CONTROL }, -- Scare Beast
    [3045] = true, --{ type = BUFF_OFFENSIVE }, -- Rapid Fire
    [19263] = true, --{ type = IMMUNITY }, -- Deterrence
    [19574] = true, --{ type = BUFF_OFFENSIVE }, -- Bestial Wrath
    [3355] = true, --{ type = CROWD_CONTROL }, -- Freezing Trap
    --[19306] = true, --{ type = ROOT }, -- Counterattack Root
    [19386] = true, --{ type = CROWD_CONTROL }, --Wyvern Sting
    --[19185] = true, --{ type = ROOT }, -- Entrapment
        [64803] = true, --{ parent = 19185 },
    [19503] = true, --{ type = CROWD_CONTROL }, -- Scatter Shot
    --[25999] = true, --{ type = ROOT }, -- Boar Charge
    [34490] = true, --{ type = CROWD_CONTROL }, -- Silencing Shot
    [34471] = true, --{ type = IMMUNITY_SPELL }, -- The Beast Within
    [5384] = true, --{ type = BUFF_DEFENSIVE }, -- Feign Death
    [24394] = true, --{ type = CROWD_CONTROL }, -- Intimidation
    [19577] = true, --{ type = BUFF_OFFENSIVE, parent = 24394 }, -- Intimidation (Buff)
    [50479] = true, --{ type = INTERRUPT, duration = 2},  -- Nether Shock (nether ray pet kick)
    --[90327] = true, --{ type = ROOT }, -- Lock Jaw (dog pet root)
    --[50245] = true, --{ type = ROOT }, -- Pin (crab pet root)
    --[52825] = true, --{ type = ROOT }, -- Swoop (carrion bird pet root)
    --[54706] = true, --{ type = ROOT }, -- Venom Web Spray (silithid pet root)
    --[4167] = true, --{ type = ROOT }, -- Web (spider pet root)
    --[96201] = true, --{ type = ROOT }, -- Web Wrap (shale spider pet root)
    [90337] = true, --{ type = CROWD_CONTROL }, -- Bad Manner (monkey stun)
    [50519] = true, --{ type = CROWD_CONTROL }, -- Sonic Blast (bat pet stun)
    [50541] = true, --{ type = CROWD_CONTROL }, -- Clench (scorpid pet disarm)
    [91644] = true, --{ type = CROWD_CONTROL }, -- Snatch (bird of prey pet disarm)
    [50318] = true, --{ type = CROWD_CONTROL }, -- Serenity Dust (moth pet silence)
    [56626] = true, --{ type = CROWD_CONTROL }, -- Sting (wasp pet stun)
    -- MoP
    [117526] = true, --{ type = CROWD_CONTROL }, -- Binding Shot
    --[128405] = true, --{ type = ROOT }, -- Narrow Escape
    [126246] = true, --{ type = CROWD_CONTROL }, -- Lullaby (Crane)
    [126355] = true, --{ type = CROWD_CONTROL }, -- Paralyzing Quill (Porcupine)
    [126423] = true, --{ type = CROWD_CONTROL }, -- Petrifying Gaze (Basilisk)

    -- Druid

    -- WoTLK
    --[768] = true, --{ type = BUFF_OTHER, }, -- Cat Form
    --[783] = true, --{ type = BUFF_OTHER, }, -- Travel Form
    --[24858] = true, --{ type = BUFF_OTHER, }, -- Moonkin Form
    --[33891] = true, --{ type = BUFF_OTHER, }, -- Tree of Life
    [22570] = true, --{ type = CROWD_CONTROL, duration = 3 }, -- Maim
    [22842] = true, --{ type = BUFF_DEFENSIVE, },  -- Frenzied Regeneration
    [50334] = true, --{ type = BUFF_OFFENSIVE, },  -- Berserk
    [61336] = true, --{ type = BUFF_DEFENSIVE, },  -- Survival Instincts
    [69369] = true, --{ type = BUFF_OFFENSIVE, }, -- Predator's Swiftness

    [22812] = true, --{ type = BUFF_DEFENSIVE }, -- Barkskin
    --[339] = true, --{ type = ROOT }, -- Entangling Roots
    --    [19975] = true, --{ parent = 339 }, -- Nature's Grasp Rank 1
    [2637] = true, --{ type = CROWD_CONTROL }, -- Hibernate
    [29166] = true, --{ type = BUFF_OFFENSIVE }, -- Innervate
    [9005] = true, --{ type = CROWD_CONTROL }, -- Pounce Stun
    [5211] = true, --{ type = CROWD_CONTROL}, -- Bash
    -- [16979] = true, --{ type = ROOT }, -- Feral Charge TODO: invalid spellId, root effect must be different than the interrupt
    [1850] = true, --{ type = BUFF_OFFENSIVE }, -- Dash
    [16689] = true, --{ type = BUFF_OFFENSIVE }, -- Nature's Grasp Buff
    --[770] = true, --{ type = BUFF_OTHER }, -- Faerie Fire
    --    [16857] = true, --{ parent = 770 }, -- Faerie Fire (Feral)
    [33786] = true, --{ type = CROWD_CONTROL }, -- Cyclone
    --[45334] = true, --{ type = ROOT }, -- Feral Charge Effect
    [81261] = true, --{ type = CROWD_CONTROL, },  -- Solar Beam
    [78675] = true, --{ type = INTERRUPT, duration = 5 }, -- Solar Beam interrupt
    -- MoP
    [113801] = true, --{ type = CROWD_CONTROL }, -- Bash (Force of Nature - Feral Treants)
    [102795] = true, --{ type = CROWD_CONTROL }, -- Bear Hug
    [99] = true, --{ type = CROWD_CONTROL }, -- Disorienting Roar
    [102546] = true, --{ type = CROWD_CONTROL }, -- Pounce (Incarnation)
    [114238] = true, --{ type = CROWD_CONTROL }, -- Fae Silence (Glyph of Fae Silence)
    --[113770] = true, --{ type = ROOT }, -- Entangling Roots (Force of Nature - Balance Treants)
    --[102359] = true, --{ type = ROOT }, -- Mass Entanglement
    [127797] = true, --{ type = CROWD_CONTROL }, -- Ursol's Vortex
    -- Druid Symbiosis
    [110698] = true, --{ type = CROWD_CONTROL }, -- Hammer of Justice (Paladin)
    [113004] = true, --{ type = CROWD_CONTROL }, -- Intimidating Roar [flee] (Warrior)
    [113056] = true, --{ type = CROWD_CONTROL }, -- Intimidating Roar [cower]] (Warrior)
    -- [126458] = true, --{ type = CROWD_CONTROL }, -- Grapple Weapon (Monk)
    --[126458] = true, --{ type = ROOT }, -- Frost Nova (Mage)
    [110617] = true, --{ type = IMMUNITY }, -- Deterrence (Hunter)
    [110715] = true, --{ type = IMMUNITY }, -- Dispersion (Priest)
    [110700] = true, --{ type = IMMUNITY }, -- Divine Shield (Paladin)
    [110696] = true, --{ type = IMMUNITY }, -- Ice Block (Mage)
    [110570] = true, --{ type = IMMUNITY_SPELL }, -- Anti-Magic Shell (Death Knight)
    [110788] = true, --{ type = IMMUNITY_SPELL }, -- Cloak of Shadows (Rogue)
    [113002] = true, --{ type = IMMUNITY_SPELL }, -- Spell Reflection (Warrior)
    [110791] = true, --{ type = BUFF_DEFENSIVE }, -- Evasion (Rogue)
    [110575] = true, --{ type = BUFF_DEFENSIVE }, -- Icebound Fortitude (Death Knight)
    [122291] = true, --{ type = BUFF_DEFENSIVE }, -- Unending Resolve (Warlock)

    -- Mage

    -- WoTLK
    [41425] = true, --{ type = BUFF_OTHER, }, -- Hypothermia
    [66] = true, --{ type = BUFF_OFFENSIVE, },  -- Invisibility
    [44544] = true, --{ type = BUFF_OFFENSIVE, }, -- Fingers of Frost
    [44572] = true, --{ type = CROWD_CONTROL, }, -- Deep Freeze
    [55021] = true, --{ type = CROWD_CONTROL, }, -- Improved Counterspell
    [82691] = true, --{ type = CROWD_CONTROL, }, -- Ring of Frost
    --[83302] = true, --{ type = ROOT, }, -- Improved Cone of Cold
    --[116] = true, --{ type = ROOT }, -- Frostbolt
    --[44614] = true, --{ type = ROOT }, -- Frostfire Bolt
    --[7321] = true, --{ type = ROOT }, -- Chilled
    --[120] = true, --{ type = ROOT }, -- Cone of Cold
    --[12486] = true, --{ type = ROOT }, -- Chilled
    --[12487] = true, --{ type = ROOT }, -- Ice Shards

    [118] = true, --{ type = CROWD_CONTROL }, -- Polymorph
        [28271] = true, --{ parent = 118 },
        [28272] = true, --{ parent = 118 },
        [71319] = true, --{ parent = 118 },
        [61305] = true, --{ parent = 118 },
        [61721] = true, --{ parent = 118 },

    [11426] = true, --{ type = BUFF_DEFENSIVE }, -- Ice Barrier
    --[122] = true, --{ type = ROOT }, -- Frost Nova
    --    [55080] = true, --{ parent = 122 }, -- Shattered Barrier
    [12042] = true, --{ type = BUFF_OFFENSIVE }, -- Arcane Power
    [45438] = true, --{ type = IMMUNITY }, -- Ice Block
    [12051] = true, --{ type = BUFF_OFFENSIVE }, -- Evocation
    [1463] = true, --{ type = BUFF_DEFENSIVE }, -- Mana Shield
    [31661] = true, --{ type = CROWD_CONTROL }, -- Dragon's Breath
    [12043] = true, --{ type = BUFF_OFFENSIVE }, -- Presence of Mind
    --[33395] = true, --{ type = ROOT }, -- Freeze
    [12472] = true, --{ type = BUFF_OFFENSIVE }, -- Icy Veins
    [87023] = true, --{ type = BUFF_OTHER, }, -- Cauterize

    -- Cataclysm

    [83853] = true, --{ type = DEBUFF_OFFENSIVE, }, -- Combustion

    -- MoP
    [115760] = true, --{ type = IMMUNITY_SPELL }, -- Glyph of Ice Block
    [118271] = true, --{ type = CROWD_CONTROL }, -- Combustion Impact
    [102051] = true, --{ type = CROWD_CONTROL }, -- Frostjaw (Root Silence)
    --[111340] = true, --{ type = ROOT }, -- Ice Ward
    --[121288] = true, --{ type = ROOT }, -- Chilled (Frost Armor)
    --[113092] = true, --{ type = ROOT }, -- Frost Bomb

    -- Rogue

    -- WoTLK
    [51690] = true, --{ type = BUFF_OFFENSIVE, },  -- Killing Spree
    [51713] = true, --{ type = BUFF_OFFENSIVE, }, -- Shadow Dance
    [51722] = true, --{type = CROWD_CONTROL, }, -- Dismantle

    [13750] = true, --{ type = BUFF_OFFENSIVE}, -- Adrenaline Rush
    [13877] = true, --{ type = BUFF_OFFENSIVE}, -- Blade Flurry
    [1833] = true, --{ type = CROWD_CONTROL }, -- Cheap Shot
    [408] = true, --{ type = CROWD_CONTROL }, -- Kidney Shot
    [6770] = true, --{ type = CROWD_CONTROL }, -- Sap
    [2094] = true, --{ type = CROWD_CONTROL }, -- Blind
    [2983] = true, --{ type = BUFF_OFFENSIVE }, -- Sprint
    [5277] = true, --{ type = BUFF_DEFENSIVE }, -- Evasion
    [1776] = true, --{ type = CROWD_CONTROL }, -- Gouge
    --[3409] = true, --{ type = ROOT }, -- Crippling Poison
    [1330] = true, --{ type = CROWD_CONTROL }, -- Garrote Silence
    [31224] = true, --{ type = IMMUNITY_SPELL }, -- Cloak of Shadows
    [45182] = true, --{ type = BUFF_DEFENSIVE }, -- Cheating Death
    [74001] = true, --{ type = BUFF_DEFENSIVE }, -- Combat Readiness
    -- MoP
    [113953] = true, --{ type = CROWD_CONTROL },  -- Paralysis (Paralytic Poison)
    --[115197] = true, --{ type = ROOT },  -- Partial Paralysis
    --[119696] = true, --{ type = ROOT },  -- Debilitation

    -- Warrior

    -- WoTLK
    --[71] = true, --{ type = BUFF_OTHER }, -- Defensive Stance
    --[2457] = true, --{ type = BUFF_OTHER }, -- Battle Stance
    --[2458] = true, --{ type = BUFF_OTHER }, -- Berserker Stance
    [2565] = true, --{ type = BUFF_DEFENSIVE }, -- Shield Block
    [3411] = true, --{ type = BUFF_DEFENSIVE },  -- Intervene
    [12975] = true, --{ type = BUFF_DEFENSIVE },  -- Last Stand
    [46924] = true, --{ type = IMMUNITY, },  -- Bladestorm
    [46968] = true, --{ type = CROWD_CONTROL, },  -- Shockwave
    [55694] = true, --{ type = BUFF_DEFENSIVE },  -- Enraged Regeneration
    [60503] = true, --{ type = BUFF_OFFENSIVE, }, -- Taste for Blood
    [65925] = true, --{ type = BUFF_OFFENSIVE, }, -- Unrelenting Assault (2/2)
    [18498] = true, --{ type = CROWD_CONTROL }, -- Improved Shield Bash
    [1719] = true, --{ type = BUFF_OFFENSIVE }, -- Recklessness
    [871] = true, --{ type = BUFF_DEFENSIVE }, -- Shield Wall
    [12292] = true, --{ type = BUFF_OFFENSIVE }, -- Death Wish
    --[23694] = true, --{ type = ROOT }, -- Improved Hamstring
    [18499] = true, --{ type = BUFF_OFFENSIVE }, -- Berserker Rage
        [20615] = true, --{ parent = 20253 },
    [12809] = true, --{ type = CROWD_CONTROL }, -- Concussion Blow
    [7922] = true, --{ type = CROWD_CONTROL }, -- Charge Stun
    [5246] = true, --{ type = CROWD_CONTROL }, -- Intimidating Shout
        [20511] = true, --{ parent = 5246 },
    [676] = true, --{ type = BUFF_OTHER }, -- Disarm
    [23920] = true, --{ type = IMMUNITY_SPELL }, -- Spell Reflection
    --[12294] = true, --{ type = BUFF_OTHER }, -- Mortal Strike
    -- MoP
    [118895] = true, --{ type = CROWD_CONTROL }, -- Dragon Roar
    -- [132168] = true, --{ type = CROWD_CONTROL }, -- Shockwave
    [107570] = true, --{ type = CROWD_CONTROL }, -- Storm Bolt
    [132169] = true, --{ type = CROWD_CONTROL }, -- Storm Bolt
    --[107566] = true, --{ type = ROOT }, -- Staggering Shout
    -- [147531] = true, --{ type = ROOT }, -- Warbringer
    --[137637] = true, --{ type = ROOT }, -- Warbringer
    --[147531] = true, --{ type = ROOT }, -- Bloodbath
    --[129923] = true, --{ type = ROOT }, -- Sluggish (Glyph of Hindering Strikes)
    [114028] = true, --{ type = IMMUNITY_SPELL }, -- Mass Spell Reflection

    -- Monk
    [131523] = true, --{ type = IMMUNITY_SPELL }, -- Zen Meditation
    [132168] = true, --{ type = CROWD_CONTROL }, -- Breath of Fire (Glyph of Breath of Fire)
    [126451] = true, --{ type = CROWD_CONTROL }, -- Clash
    [122242] = true, --{ type = CROWD_CONTROL }, -- Clash
    [119392] = true, --{ type = CROWD_CONTROL }, -- Charging Ox Wave
    [120086] = true, --{ type = CROWD_CONTROL }, -- Fists of Fury
    [119381] = true, --{ type = CROWD_CONTROL }, -- Leg Sweep
    [115078] = true, --{ type = CROWD_CONTROL }, -- Paralysis
    [117368] = true, --{ type = CROWD_CONTROL }, -- Grapple Weapon
    [140023] = true, --{ type = CROWD_CONTROL }, -- Ring of Peace
    [137461] = true, --{ type = CROWD_CONTROL }, -- Disarmed (Ring of Peace)
    [137460] = true, --{ type = CROWD_CONTROL }, -- Silenced (Ring of Peace)
    [116709] = true, --{ type = CROWD_CONTROL }, -- Spear Hand Strike (Silence)
    --[116706] = true, --{ type = ROOT }, -- Disable (Root)
    --[113275] = true, --{ type = ROOT }, -- Entangling Roots (Symbiosis)
    --[123407] = true, --{ type = ROOT }, -- Spinning Fire Blossom
    --[116095] = true, --{ type = ROOT }, -- Disable
    --[123586] = true, --{ type = ROOT }, -- Flying Serpent Kick
    --[123727] = true, --{ type = ROOT }, -- Dizzying Haze
    [126456] = true, --{ type = BUFF_DEFENSIVE }, -- Fortifying Brew

}

C.NameplateBlackList = {
	[15407] = true, -- 精神鞭笞
}

C.NameplateCustomUnits = {
	--[120651] = true, -- 爆炸物
}

C.NameplateShowPowerList = {
	--[155432] = true, -- 魔力使者
}

-- Important readings highlighted
C.MajorSpells = {
	--[47855] = true,	-- 寒冰箭
}
