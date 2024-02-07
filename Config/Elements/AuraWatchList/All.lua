local K, L = KkthnxUI[1], KkthnxUI[3]
local Module = K:GetModule("AurasTable")

-- 全职业的相关监控
local list = {
	["Enchant Aura"] = {
		-- 种族天赋
		{ AuraID = 58984, UnitID = "player" }, -- 影遁 暗夜
		{ AuraID = 20594, UnitID = "player" }, -- 石像形态 矮人
		{ AuraID = 26297, UnitID = "player" }, -- 狂暴 巨魔
		{ AuraID = 20572, UnitID = "player" }, -- 血性狂暴 兽人
		{ AuraID = 33697, UnitID = "player" }, -- 血性狂暴 兽人
		{ AuraID = 33702, UnitID = "player" }, -- 血性狂暴 兽人
		-- 附魔药水
		{ AuraID = 28093, UnitID = "player" }, -- 闪电之速，猫鼬
		{ AuraID = 28515, UnitID = "player" }, -- 铁盾药水
		{ AuraID = 28504, UnitID = "player" }, -- 特效无梦睡眠药水
		{ AuraID = 28506, UnitID = "player" }, -- 英雄药水
		{ AuraID = 28507, UnitID = "player" }, -- 加速药水
		{ AuraID = 28508, UnitID = "player" }, -- 毁灭药水
		--{AuraID = 28511, UnitID = "player"},	-- 防护火焰药水
		--{AuraID = 28512, UnitID = "player"},	-- 防护冰霜药水
		--{AuraID = 28513, UnitID = "player"},	-- 防护自然药水
		--{AuraID = 28537, UnitID = "player"},	-- 防护暗影药水
		--{AuraID = 28538, UnitID = "player"},	-- 防护神圣药水
		-- 饰品
	},
	["Raid Buff"] = {
		-- 战鼓
		{ AuraID = 35474, UnitID = "player" }, -- 恐慌之鼓
		{ AuraID = 35475, UnitID = "player" }, -- 战争之鼓
		{ AuraID = 35476, UnitID = "player" }, -- 战斗之鼓
		{ AuraID = 35477, UnitID = "player" }, -- 速度之鼓
		{ AuraID = 35478, UnitID = "player" }, -- 恢复之鼓
		-- 团队增益或减伤
		{ AuraID = 2825, UnitID = "player" }, -- 嗜血
		{ AuraID = 32182, UnitID = "player" }, -- 英勇
		{ AuraID = 1022, UnitID = "player" }, -- 保护祝福
		{ AuraID = 6940, UnitID = "player" }, -- 牺牲祝福
		{ AuraID = 1044, UnitID = "player" }, -- 自由祝福
		{ AuraID = 29166, UnitID = "player" }, -- 激活
		{ AuraID = 10060, UnitID = "player" }, -- 能量灌注
		{ AuraID = 13159, UnitID = "player" }, -- 豹群守护
	},
	["Raid Debuff"] = {
		--Raid / Boss / Other
		{ AuraID = 72293, UnitID = "player" },	-- Mark of the Fallen Champion (Deathbringer Saurfang)
		{ AuraID = 72410, UnitID = "player" },	-- Rune of Blood (Deathbringer Saurfang)
		{ AuraID = 72103, UnitID = "player" },	-- Inoculated (Festergut)
		{ AuraID = 72219, UnitID = "player" },	-- Gastric Bloat (Festergut)
		{ AuraID = 71224, UnitID = "player" },	-- Mutated Infection (Rotface)
		{ AuraID = 72856, UnitID = "player" },	-- Unbound Plague (Professor Putricide)
		{ AuraID = 70353, UnitID = "player" },	-- Gas Variable (Professor Putricide)
		{ AuraID = 70352, UnitID = "player" },	-- Ooze Variable (Professor Putricide)
		{ AuraID = 71340, UnitID = "player" },	-- Pact of the Darkfallen (Bloodqueen Lana'thel)
		{ AuraID = 71861, UnitID = "player" },	-- Swarming Shadows (Bloodqueen Lana'thel)
		{ AuraID = 71473, UnitID = "player" },	-- Essence of the Blood Queen (Bloodqueen Lana'thel)
		{ AuraID = 69766, UnitID = "player" },	-- Instability (Sindragosa)
		{ AuraID = 69762, UnitID = "player" },	-- Unchained Magic (Sindragosa)
		{ AuraID = 70128, UnitID = "player" },	-- Mystic Buffet (Sindragosa)
		{ AuraID = 70126, UnitID = "player" },	-- Ice Arrow (Sindragosa)
		{ AuraID = 70106, UnitID = "player" },	-- Chilled to the bone (Sindragosa)
		{ AuraID = 69409, UnitID = "player" },	-- Soul Reaper (Arthas - The Lich King)
		{ AuraID = 73912, UnitID = "player" },	-- Necrotic Plague (Arthas - The Lich King)
		{ AuraID = 74795, UnitID = "player" },	-- Mark of Consumption	(Dark - Halion)
		{ AuraID = 74567, UnitID = "player" },	-- Mark of Combustion	(Light - Halion)
		{ AuraID = 74453, UnitID = "player" },	-- Flame Beacon	(Saviana)
		{ AuraID = 28059, UnitID = "player" },	-- Positive charge (Naxramas - Tadius)
		{ AuraID = 28084, UnitID = "player" },	-- Negative charge (Naxramas - Tadius)
		{ AuraID = 29660, UnitID = "player" },	-- negative charge + damage
		{ AuraID = 29659, UnitID = "player" },	-- positive charge + damage
		{ AuraID = 68128, UnitID = "player" },	-- Legion Flame	(Trial of Crusaider - Jaraxus)
		{ AuraID = 70432, UnitID = "player" },	-- Blood SAP 
		{ AuraID = 70645, UnitID = "player" },	-- Chain of Shadow
		{ AuraID = 69483, UnitID = "player" },	-- Dark Reckoning
		{ AuraID = 71257, UnitID = "player" },	-- Barbariс Strike
		{ AuraID = 28169, UnitID = "player" },	-- Mutating injection
		{ AuraID = 72451, UnitID = "player" },	-- Mutated Plague
		{ AuraID = 71127, UnitID = "player" },	-- Mortal Wound
		{ AuraID = 72098, UnitID = "player" },	-- Frostbite
		{ AuraID = 60899, UnitID = "player" },	-- Shield crash
		{ AuraID = 66012, UnitID = "player" },	-- Freazing Slash
		{ AuraID = 66331, UnitID = "player" },	-- Impale
		{ AuraID = 55593, UnitID = "player" },	-- Necrotic Aura
		{ AuraID = 63276, UnitID = "player" },	-- Mark of the Faceless
		{ AuraID = 63024, UnitID = "player" },	-- Gravity Bomb
		{ AuraID = 64002, UnitID = "player" },	-- Crush Bomb
		{ AuraID = 71204, UnitID = "player" },	-- Touch  of Insignificance
		{ AuraID = 72865, UnitID = "player" },	-- Death Plague
		{ AuraID = 70633, UnitID = "player" },	-- Gut Spray
		{ AuraID = 62039, UnitID = "player" },	-- Biting cold
		{ AuraID = 67890, UnitID = "player" },	-- Cobalt frag Bomb
		{ AuraID = 71103, UnitID = "player" },	-- Combobulating Spray
		{ AuraID = 28786, UnitID = "player" },	-- Locust Swarm
		{ AuraID = 27776, UnitID = "player" },	-- Necrotic Poison
		{ AuraID = 28834, UnitID = "player" },	-- Mark of Rivendare
		{ AuraID = 28832, UnitID = "player" },	-- Mark of Korth'azz
		{ AuraID = 28835, UnitID = "player" },	-- Mark of Zeliek
		{ AuraID = 28833, UnitID = "player" },	-- Mark of Blaumeux
		{ AuraID = 28542, UnitID = "player" },	-- Life Drain
		{ AuraID = 73070, UnitID = "player" },	-- Incite Terror
		{ AuraID = 72833, UnitID = "player" },	-- Gaseous bloat
		{ AuraID = 29484, UnitID = "player" },	-- Web Spray
		{ AuraID = 54125, UnitID = "player" },	-- Web Spray
		{ AuraID = 55314, UnitID = "player" },	-- Strangulate
		{ AuraID = 55334, UnitID = "player" },	-- Strangulate
		{ AuraID = 29232, UnitID = "player" },	-- Fungal Creep
		{ AuraID = 29204, UnitID = "player" },	-- 
		
		{ AuraID = 15571, UnitID = "player" },	-- Dazed

		-- CС
		-- DK
		{ AuraID = 47481, UnitID = "player" },	-- Gnaw (Ghoul)
		{ AuraID = 47476, UnitID = "player" },	-- Strangulate
		{ AuraID = 45524, UnitID = "player" },	-- Chains of Ice
		{ AuraID = 55741, UnitID = "player" },	-- Desecration (no duration, lasts as long as you stand in it)
		{ AuraID = 58617, UnitID = "player" },	-- Glyph of Heart Strike
		{ AuraID = 50436, UnitID = "player" },	-- Icy Clutch (Chilblains)
		{ AuraID = 51209, UnitID = "player" },	-- Hungering Cold
		-- Druid
		{ AuraID = 33786, UnitID = "player" },	-- Cyclone
		{ AuraID = 2637, UnitID = "player" },	-- Hibernate
		{ AuraID = 5211, UnitID = "player" },	-- Bash
		{ AuraID = 49802, UnitID = "player" },	-- Maim
		{ AuraID = 49803, UnitID = "player" },	-- Pounce
		{ AuraID = 9005, UnitID = "player" },	-- Pounce
		{ AuraID = 339, UnitID = "player" },	-- Entangling Roots
		{ AuraID = 53308, UnitID = "player" },	-- Entangling Roots
		{ AuraID = 53313, UnitID = "player" },	-- Entangling Roots
		{ AuraID = 45334, UnitID = "player" },	-- Feral Charge Effect
		{ AuraID = 58179, UnitID = "player" },	-- Infected Wounds
		{ AuraID = 53227, UnitID = "player" },	-- Typhoon
		{ AuraID = 16922, UnitID = "player" },	-- Moonfire proc
		{ AuraID = 19675, UnitID = "player" },	-- Interrupt efect
		-- Hunter
		{ AuraID = 3355, UnitID = "player" },	-- Freezing Trap Effect
		{ AuraID = 60210, UnitID = "player" },	-- Freezing Arrow Effect
		{ AuraID = 1513, UnitID = "player" },	-- Scare Beast
		{ AuraID = 19503, UnitID = "player" },	-- Scatter Shot
		{ AuraID = 53359, UnitID = "player" },	-- Chimera Shot - Scorpid
		{ AuraID = 50541, UnitID = "player" },	-- Snatch (Bird of Prey)
		{ AuraID = 34490, UnitID = "player" },	-- Silencing Shot
		{ AuraID = 24394, UnitID = "player" },	-- Intimidation
		{ AuraID = 50519, UnitID = "player" },	-- Sonic Blast (Bat)
		{ AuraID = 53562, UnitID = "player" },	-- Ravage (Ravager)
		{ AuraID = 35101, UnitID = "player" },	-- Concussive Barrage
		{ AuraID = 5116, UnitID = "player" },	-- Concussive Shot
		{ AuraID = 13810, UnitID = "player" },	-- Frost Trap Aura
		{ AuraID = 61394, UnitID = "player" },	-- Glyph of Freezing Trap
		{ AuraID = 2974, UnitID = "player" },	-- Wing Clip
		{ AuraID = 19306, UnitID = "player" },	-- Counterattack
		{ AuraID = 19185, UnitID = "player" },	-- Entrapment
		{ AuraID = 49012, UnitID = "player" },	-- Wyvern String
		{ AuraID = 19386, UnitID = "player" },	-- Wyvern String
		{ AuraID = 50245, UnitID = "player" },	-- Pin (Crab)
		{ AuraID = 53548, UnitID = "player" },	-- Pin (Crab)
		{ AuraID = 54706, UnitID = "player" },	-- Venom Web Spray (Silithid)
		{ AuraID = 4167, UnitID = "player" },	-- Web (Spider)
		{ AuraID = 25999, UnitID = "player" },	-- Charge (Pet)
		-- Mage
		{ AuraID = 42950, UnitID = "player" },	-- Dragon's Breath
		{ AuraID = 31661, UnitID = "player" },	-- Dragon's Breath
		{ AuraID = 118, UnitID = "player" },	-- Polymorph
		{ AuraID = 12824, UnitID = "player" },	-- Polymorph
		{ AuraID = 12825, UnitID = "player" },	-- Polymorph
		{ AuraID = 12826, UnitID = "player" },	-- Polymorph
		{ AuraID = 28271, UnitID = "player" },	-- Polymorph
		{ AuraID = 28272, UnitID = "player" },	-- Polymorph
		{ AuraID = 61305, UnitID = "player" },	-- Polymorph
		{ AuraID = 61721, UnitID = "player" },	-- Polymorph
		{ AuraID = 61780, UnitID = "player" },	-- Polymorph
		{ AuraID = 18469, UnitID = "player" },	-- Silenced - Improved Counterspell
		{ AuraID = 55021, UnitID = "player" },	-- Silenced - Improved Counterspell (Interrupt)
		{ AuraID = 44572, UnitID = "player" },	-- Deep Freeze
		{ AuraID = 33395, UnitID = "player" },	-- Freeze (Water Elemental)
		{ AuraID = 42917, UnitID = "player" },	-- Frost Nova
		{ AuraID = 122, UnitID = "player" },	-- Frost Nova
		{ AuraID = 55080, UnitID = "player" },	-- Shattered Barrier
		{ AuraID = 6136, UnitID = "player" },	-- Chilled
		{ AuraID = 120, UnitID = "player" },	-- Cone of Cold
		{ AuraID = 42945, UnitID = "player" },	-- Blash Wave
		{ AuraID = 12355, UnitID = "player" },	-- Impact
		{ AuraID = 31589, UnitID = "player" },	-- Slow
		-- Paladin
		{ AuraID = 20066, UnitID = "player" },	-- Repentance
		{ AuraID = 10326, UnitID = "player" },	-- Turn Evil
		{ AuraID = 63529, UnitID = "player" },	-- Shield of the Templar
		{ AuraID = 10308, UnitID = "player" },	-- Hammer of Justice
		{ AuraID = 2812, UnitID = "player" },	-- Holy Wrath
		{ AuraID = 20170, UnitID = "player" },	-- Stun (Seal of Justice proc)
		{ AuraID = 31935, UnitID = "player" },	-- Avenger's Shield
		-- Priest
		{ AuraID = 64058, UnitID = "player" },	-- Psychic Horror
		{ AuraID = 605, UnitID = "player" },	-- Mind Control
		{ AuraID = 64044, UnitID = "player" },	-- Psychic Horror(Disarm)
		{ AuraID = 8122, UnitID = "player" },	-- Psychic Scream
		{ AuraID = 10890, UnitID = "player" },	-- Psychic Scream
		{ AuraID = 15487, UnitID = "player" },	-- Silence
		{ AuraID = 15407, UnitID = "player" },	-- Mind Flay
		-- Rogue
		{ AuraID = 51722, UnitID = "player" },	-- Dismantle
		{ AuraID = 2094, UnitID = "player" },	-- Blind
		{ AuraID = 1776, UnitID = "player" },	-- Gouge
		{ AuraID = 51724, UnitID = "player" },	-- Sap
		{ AuraID = 2070, UnitID = "player" },	-- Sap
		{ AuraID = 1330, UnitID = "player" },	-- Garrote - Silence
		{ AuraID = 18425, UnitID = "player" },	-- Silenced - Improved Kick
		{ AuraID = 1833, UnitID = "player" },	-- Cheap Shot
		{ AuraID = 408, UnitID = "player" },	-- Kidney Shot
		{ AuraID = 8643, UnitID = "player" },	-- Kidney Shot
		{ AuraID = 31125, UnitID = "player" },	-- Blade Twisting
		{ AuraID = 3409, UnitID = "player" },	-- Crippling Poison
		{ AuraID = 26679, UnitID = "player" },	-- Deadly Throw
		{ AuraID = 57975, UnitID = "player" },	-- Wound Poison
		-- Shaman
		{ AuraID = 51514, UnitID = "player" },	-- Hex
		{ AuraID = 64695, UnitID = "player" },	-- Earthgrab
		{ AuraID = 63685, UnitID = "player" },	-- Freeze
		{ AuraID = 39796, UnitID = "player" },	-- Stoneclaw Stun
		{ AuraID = 3600, UnitID = "player" },	-- Earthbind
		{ AuraID = 8056, UnitID = "player" },	-- Frost Shock
		{ AuraID = 58861, UnitID = "player" },	-- Bash
		-- Warlock
		{ AuraID = 710, UnitID = "player" },	-- Banish
		{ AuraID = 47860, UnitID = "player" },	-- Death Coil
		{ AuraID = 6789, UnitID = "player" },	-- Death Coil
		{ AuraID = 5782, UnitID = "player" },	-- Fear
		{ AuraID = 5484, UnitID = "player" },	-- Howl of Terror
		{ AuraID = 6358, UnitID = "player" },	-- Seduction (Succubus)
		{ AuraID = 24259, UnitID = "player" },	-- Spell Lock (Felhunter)
		{ AuraID = 30283, UnitID = "player" },	-- Shadowfury r1
		{ AuraID = 30413, UnitID = "player" },	-- Shadowfury r2
		{ AuraID = 30414, UnitID = "player" },	-- Shadowfury r3
		{ AuraID = 47846, UnitID = "player" },	-- Shadowfury r4
		{ AuraID = 47847, UnitID = "player" },	-- Shadowfury r5
		{ AuraID = 30153, UnitID = "player" },	-- Intercept (Felguard)
		{ AuraID = 18118, UnitID = "player" },	-- Aftermath
		{ AuraID = 18223, UnitID = "player" },	-- Curse of Exhaustion
		{ AuraID = 60955, UnitID = "player" },	-- Demon Charge
		{ AuraID = 22703, UnitID = "player" },	-- Infernal sumon
		-- Warrior
		{ AuraID = 20511, UnitID = "player" },	-- Intimidating Shout
		{ AuraID = 676, UnitID = "player" },	-- Disarm
		{ AuraID = 18498, UnitID = "player" },	-- Silenced (Gag Order)
		{ AuraID = 7922, UnitID = "player" },	-- Charge Stun
		{ AuraID = 12809, UnitID = "player" },	-- Concussion Blow
		{ AuraID = 20253, UnitID = "player" },	-- Intercept
		{ AuraID = 12798, UnitID = "player" },	-- Revenge Stun
		{ AuraID = 46968, UnitID = "player" },	-- Shockwave
		{ AuraID = 58373, UnitID = "player" },	-- Glyph of Hamstring
		{ AuraID = 23694, UnitID = "player" },	-- Improved Hamstring
		{ AuraID = 1715, UnitID = "player" },	-- Hamstring
		{ AuraID = 12323, UnitID = "player" },	-- Piercing Howl
		-- Racial & Other
		{ AuraID = 20549, UnitID = "player" },	-- War Stomp
		{ AuraID = 19482, UnitID = "player" },	-- War Stomp (lLvl)
		{ AuraID = 50613, UnitID = "player" },	-- Arcane Torrent
		{ AuraID = 25046, UnitID = "player" },	-- Arcane Torrent
		{ AuraID = 28730, UnitID = "player" },	-- Arcane Torrent
		{ AuraID = 13237, UnitID = "player" },	-- Goblin Mortar
		{ AuraID = 32752, UnitID = "player" },	-- Sumon dez
		{ AuraID = 4068, UnitID = "player" },	-- Iron bomb
		{ AuraID = 836, UnitID = "player" },	-- Tidal Charm Trinket
		{ AuraID = 47995, UnitID = "player" },	-- Intercept
		{ AuraID = 30457, UnitID = "player" },	-- babol
		{ AuraID = 13120, UnitID = "player" },	-- Net-o-Matic
		{ AuraID = 16566, UnitID = "player" },	-- Net-o-Matic
		{ AuraID = 13199, UnitID = "player" },	-- Net-o-Matic
		{ AuraID = 13138, UnitID = "player" },	-- Net-o-Matic
		{ AuraID = 13139, UnitID = "player" },	-- Net-o-Matic
		{ AuraID = 13099, UnitID = "player" },	-- Net-o-Matic
		{ AuraID = 18093, UnitID = "player" },	-- Pyroclasm
		{ AuraID = 5134, UnitID = "player" },	-- Flash Bomb
	},
	["Warning"] = {
		--{AuraID = 226510, UnitID = "target"},	-- 血池回血
		-- PVP
		{ AuraID = 498, UnitID = "target" }, -- 圣佑术
		{ AuraID = 642, UnitID = "target" }, -- 圣盾术
		{ AuraID = 871, UnitID = "target" }, -- 盾墙
		{ AuraID = 5277, UnitID = "target" }, -- 闪避
		{ AuraID = 1044, UnitID = "target" }, -- 自由祝福
		{ AuraID = 6940, UnitID = "target" }, -- 牺牲祝福
		{ AuraID = 1022, UnitID = "target" }, -- 保护祝福
		{ AuraID = 19574, UnitID = "target" }, -- 狂野怒火
		{ AuraID = 23920, UnitID = "target" }, -- 法术反射
		{ AuraID = 33206, UnitID = "target" }, -- 痛苦压制
	},
	["InternalCD"] = {
		-- ICC rep rings
		{ IntID = 72416, Duration = 60 },
		{ IntID = 72412, Duration = 60 },
		{ IntID = 72418, Duration = 60 },
		{ IntID = 72414, Duration = 60 },

		{ IntID = 60488, Duration = 15 },
		{ IntID = 51348, Duration = 10 },
		{ IntID = 51353, Duration = 10 },
		{ IntID = 54808, Duration = 60 },
		{ IntID = 55018, Duration = 60 },
		{ IntID = 52419, Duration = 30 },
		{ IntID = 59620, Duration = 90 },

		{ IntID = 55382, Duration = 15 },
		{ IntID = 32848, Duration = 15 },
		{ IntID = 55341, Duration = 90 },	-- Invigorating Earthsiege, based on WowHead comments (lol?)

		{ IntID = 48517, Duration = 30 },
		{ IntID = 48518, Duration = 30 },

		{ IntID = 47755, Duration = 12 },

		-- Deathbringer's Will, XI from #elitistjerks says it's 105 sec so if it's wrong yell at him.
		{ IntID = 71485, Duration = 105 },
		{ IntID = 71492, Duration = 105 },
		{ IntID = 71486, Duration = 105 },
		{ IntID = 71484, Duration = 105 },
		{ IntID = 71491, Duration = 105 },
		{ IntID = 71487, Duration = 105 },

		-- Deathbringer's Will (Heroic)
		{ IntID = 71556, Duration = 105 },
		{ IntID = 71560, Duration = 105 },
		{ IntID = 71558, Duration = 105 },
		{ IntID = 71561, Duration = 105 },
		{ IntID = 71559, Duration = 105 },
		{ IntID = 71557, Duration = 105 },

		-- Black Magic
		{ IntID = 59626, Duration = 35 },
		{ IntID = 59625, Duration = 35 },

		{ IntID = 71605, Duration = 90 },	-- Phylactery of the Nameless Lich (Non-heroic)
		{ IntID = 71636, Duration = 90 },	-- Phylactery of the Nameless Lich (Heroic)

	},
}

Module:AddNewAuraWatch("ALL", list)
