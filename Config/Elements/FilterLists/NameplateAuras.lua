local C = KkthnxUI[2]

C.NameplateWhiteList = {
	-- T12
    [99497]  = true, -- [Beth'tilac] Frenzy @Boss
    [100634] = true, -- [Beth'tilac] Consume @Add
    [99296]  = true, -- [Ragnaros] Meteor Knockable
    [99362]  = true, -- [Alysrazor] Voracious Hatchling Tantrum
    [99361]  = true, -- [Alysrazor] Voracious Hatchling Hungry
    [99359]  = true, -- [Alysrazor] Voracious Hatchling Satiated
    [101304] = true, -- [Rhyolith] Buff - Superheated
    [99352]  = true, -- [Baleroc] Decimation Blade
    [99350]  = true, -- [Baleroc] Inferno Blade
    [97238]  = true, -- [Majordomo] Adrenaline
    [100656] = true, -- [Shannox] Feeding Frenzy
    [100167] = true, -- [Shannox] Wary
    [99837]  = true, -- [Shannox] Crystal Trap

    -- T13
    [103846]  = true,
    [104894]  = true,
    [105027]  = true,
    [104896]  = true,
    [104897]  = true,
    [104898]  = true,
    [104901]  = true,
    [104900]  = true,
    [103968]  = true,
    [105904]  = true,
    [105248]  = true,
    [104031]  = true,
    [107851]  = true,
    [108934]  = true,
    [105409]  = true,
    [105256]  = true,
    [104543]  = true,

    -- Taunt
    [355]  = true,
    [62124]  = true,
    [31789]  = true,
    [6795]  = true,
    [5209]  = true,
    [56222]  = true,
    [49576]  = true,

    --[104897]  = true,

    --[29703] = true, -- Dazed(-50% move.speed/%.s)

    -- Warrior
    [46924] = true, -- Bladestorm
    [12294] = true, -- Mortal Strike
    [23920] = true, -- Spell Reflection
    [19306] = true, -- Counterattack(retal)
    [58373] = true, -- Glyph of Hamstring
    [23694] = true, -- Improved Hamstring
    [12809] = true, -- Concussion Blow
    [20253] = true, -- Intercept (also Warlock Felguard ability)
    [5246]  = true, -- Intimidating Shout(Fear/8s)
    [46968] = true, -- Shockwave
    [18498] = true, -- Silenced - Gag Order
    [676]   = true, -- Disarm

    --[1715]  = true, -- Hamstring(-50% move.speed/15s)
    --[12323] = true, -- Piercing Howl (-50% move.speed/6s)

    -- Hunter
    [34471] = true, -- Beast Within
    [53271] = true, -- Masters Call(freedom)
    [19263] = true, -- Deterence
    [13810] = true, -- Freezing Arrow Effect
    [3355]  = true, -- Freezing Trap Effect
    [27753] = true, -- Freezing Trap Effect
    [19185] = true, -- Entrapment(talent trap)
    [1513]  = true, -- Scare Beast (Fear/works against Druids in most forms and Shamans using Ghost Wolf)
    [19503] = true, -- Scatter Shot
    [19386] = true, -- Wyvern Sting
    [34490] = true, -- Silencing Shot

    -- pet
    [50245] = true, -- Pin (Crab)
    [54706] = true, -- Venom Web Spray (Silithid)
    [4167]  = true, -- Web (Spider)
    [54644] = true, -- Froststorm Breath (Chimera)
    [50271] = true, -- Tendon Rip (Hyena)
    [24394] = true, -- Intimidation(pet)
    [50519] = true, -- Sonic Blast (Bat)
    [50541] = true, -- Snatch (Bird of Prey)

    --[35101] = true, -- Concussive Barrage(Himera shot(-50 move.speed/4s))
    --[5116]  = true, -- Concussive Shot(-50 move.speed/4s-6s)
    --[13810] = true, -- Frost Trap Aura (no duration, lasts as long as you stand in it)
    --[61394] = true, -- Glyph of Freezing Trap(broke trap == -30% move.speed/4s)
    --[2974]  = true, -- Wing Clip(melle -50% move.speed/10s)

    -- Druid
    [33786] = true, -- Cyclone
    [339]   = true, -- Entangling Roots
    [2637]  = true, -- Hibernate (works against Druids in most forms and Shamans using Ghost Wolf)
    [5211]  = true, -- Bash
    [22570] = true, -- Maim
    [9005]  = true, -- Pounce
    [69369] = true, -- Predator's Swiftness(Feral/Proc)

    --[58179] = true, -- Infected Wounds(feral(-50 move.speed))
    --[61391] = true, -- Typhoon(Sova(-50 move.speed))

    -- Shaman
    [8178]  = true, -- Grounding Totem Effect
    [64695] = true, -- Earthgrab (Storm, Earth and Fire)
    [63685] = true, -- Freeze (Frozen Power)
    [39796] = true, -- Stoneclaw Stun
    [51514] = true, -- Hex (although effectively a silence+disarm effect, it is conventionally thought of as a "CC", plus you can trinket out of it)
    [16166] = true, -- Elemental mastery

    --[3600]  = true, -- Earthbind (5 second duration per pulse, but will keep re-applying the debuff as long as you stand within the pulse radius)
    --[8056]  = true, -- Frost Shock(-50% move.speed/8s)
    --[8034]  = true, -- Frostbrand Attack(ench(-50% move.speed/8s)

    -- Warlock
    [710]   = true, -- Banish
    [6789]  = true, -- Death Coil
    [5782]  = true, -- Fear
    [5484]  = true, -- Howl of Terror
    [30283] = true, -- Shadowfury
    [6358]  = true, -- Seduction (Succubus)
    [24259] = true, -- Spell Lock (Felhunter)
    [7922]  = true, -- Charge Stun (Demon)
    [18118] = true, -- Aftermath(-70% move.speed/5s)

    --[18223] = true, -- Curse of Exhaustion(-30% move.speed/12s)

    -- Mage
    [45438] = true, -- Ice Block
    [61025] = true, -- Polymorph(snake)
    [118]   = true, -- Polymorph(BbeeeEE!!)
    [33395] = true, -- Freeze (Water Elemental)
    [122]   = true, -- Frost Nova    
    [55080] = true, -- Shattered Barrier
    [44572] = true, -- Deep Freeze
    [31661] = true, -- Dragon's Breath
    [12355] = true, -- Impact
    [18469] = true, -- Silenced - Improved Counterspell
    [64346] = true, -- Fiery Payback(Disarm)
    [48108] = true, -- Hot streak(Firemage/Proc)
    

    --[11113] = true, -- Blast Wave(fire (-50 move.speed/6s)
    --[6136]  = true, -- Chilled (generic effect, used by lots of spells [looks weird on Improved Blizzard, might want to comment out])
    --[120]   = true, -- Cone of Cold(-50 move.speed/8s)
    --[116]   = true, -- Frostbolt(-40 move.speed/5s)
    --[47610] = true, -- Frostfire Bolt(-40 move.speed/9s)
    --[31589] = true, -- Slow(arcane (-60% move.speed/15s))

    -- Rogue
    [31224] = true, -- Cloack of Shadows
    [1776]  = true, -- Gouge
    [2094]  = true, -- Blind
    [1833]  = true, -- Cheap Shot
    [408]   = true, -- Kidney Shot
    [6770]  = true, -- Sap
    [1330]  = true, -- Garrote - Silence
    [18425] = true, -- Silenced - Improved Kick
    [51722] = true, -- Dismantle(Disarm)
    [31125] = true, -- Blade Twisting(-70% move.speed/4s)

    --[26679] = true, -- Deadly Throw(-50% move.speed/6s)
    --[3409]  = true, -- Crippling Poison(-70% move.speed/t.s)

    -- Paladin
    [1044]  = true, -- Hand of Freedom
    [642]   = true, -- Divine Shield(babol)
    [1022]  = true, -- Hand of Protection (BOP)
    [20066] = true, -- Repentance
    [853]   = true, -- Hammer of Justice
    [2812]  = true, -- Holy Wrath (works against Warlocks using Metamorphasis and Death Knights using Lichborne)
    [20170] = true, -- Stun (Seal of Justice proc)
    [10326] = true, -- Turn Evil (Fear/works against Warlocks using Metamorphasis and Death Knights using Lichborne)
    [63529] = true, -- Shield of the Templar
    [31884] = true, -- Avenging Wrath
    [6940]  = true,  -- Hand of Sacrifice(30%)
    [64205] = true, -- Divane Sacrifice(Mas sacra)


    --[20184] = true, -- Judgement of Justice (100% movement snare; druids and shamans might want this though)

    -- Priest
    [47585] = true, -- Dispersion
    [605]   = true, -- Mind Control
    [64044] = true, -- Psychic Horror
    [64058] = true, -- Psychic Horror (Disarm/duplicate debuff names not allowed atm, need to figure out how to support this later)
    [8122]  = true, -- Psychic Scream(Fear/8s)
    [9484]  = true, -- Shackle Undead (works against Death Knights using Lichborne)
    [15487] = true, -- Silence
    [33206] = true, -- Pain Supression(-40% damage taken)


    --[15407] = true, -- Mind Flay(-50 move.speed/t.s)

    -- Death night
    [48792] = true, -- Icebound Fortitude
    [48707] = true, -- Anti-Magic Shield
    [47481] = true, -- Gnaw (Ghoul(Stun/3s))
    [49203] = true, -- Hungering Cold
    [47476] = true, -- Strangulate(Silence/5s)
    [50461] = true, -- Anti-Magic Zone

    --[45524] = true, -- Chains of Ice
    --[55666] = true, -- Desecration (no duration, lasts as long as you stand in it)
    --[58617] = true, -- Glyph of Heart Strike(-50 move.speed)
    --[50436] = true, -- Icy Clutch (Chilblains)
    
	-- Debuffs
	--[57940]	= true,	-- test
    --[57940]   = true, -- test

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
