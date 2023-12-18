local _, C = unpack(KkthnxUI)

local _G = _G

local DISABLE = _G.DISABLE
local EMOTE = _G.EMOTE
local GUILD = _G.GUILD
local NONE = _G.NONE
local PARTY = _G.PARTY
local PLAYER = _G.PLAYER
local RAID = _G.RAID
local SAY = _G.SAY
local YELL = _G.YELL

local BlipMedia = "Interface\\AddOns\\KkthnxUI\\Media\\MiniMap\\"
local ChatMedia = "Interface\\AddOns\\KkthnxUI\\Media\\Chat\\"

-- Actionbar
C["ActionBar"] = {
	["Bar1Font"] = 12,
	["Bar1Num"] = 12,
	["Bar1PerRow"] = 12,
	["Bar1Size"] = 32,
	["Bar2Font"] = 12,
	["Bar2Num"] = 12,
	["Bar2PerRow"] = 12,
	["Bar2Size"] = 32,
	["Bar3Font"] = 12,
	["Bar3Num"] = 12,
	["Bar3PerRow"] = 12,
	["Bar3Size"] = 32,
	["Bar4Fader"] = false,
	["Bar4Font"] = 12,
	["Bar4Num"] = 12,
	["Bar4PerRow"] = 4,
	["Bar4Size"] = 32,
	["Bar5Fader"] = false,
	["Bar5Font"] = 12,
	["Bar5Num"] = 12,
	["Bar5PerRow"] = 4,
	["Bar5Size"] = 32,
	["BarPetFont"] = 12,
	["BarPetNum"] = 10,
	["BarPetPerRow"] = 10,
	["BarPetSize"] = 26,
	["BarStanceFont"] = 12,
	["BarStancePerRow"] = 10,
	["BarStanceSize"] = 30,
	["BarXFader"] = false,
	["Cooldowns"] = true,
	["Count"] = true,
	["CustomBar"] = false,
	["CustomBarButtonSize"] = 34,
	["CustomBarNumButtons"] = 12,
	["CustomBarNumPerRow"] = 12,
	["Enable"] = true,
	["FadeCustomBar"] = false,
	["FadeMicroBar"] = false,
	["Hotkey"] = true,
	["Macro"] = true,
	["MicroBar"] = true,
	["MMSSTH"] = 60,
	["OverrideWA"] = false,
	["PetBar"] = true,
	["Scale"] = 1,
	["StanceBar"] = true,
	["TenthTH"] = 3,
	["VehButtonSize"] = 34,
	["TotemBar"] = true,
	["AspectBar"] = false,
	["AspectSize"] = 25,
	["VerticleAspect"] = false,
}

-- Announcements
C["Announcements"] = {
	["AlertInChat"] = false,
	["AlertInWild"] = false,
	["BrokenAlert"] = false,
	["DispellAlert"] = false,
	["HealthAlert"] = false,
	["InstAlertOnly"] = false,
	["InterruptAlert"] = false,
	["ItemAlert"] = false,
	["KillingBlow"] = false,
	["OnlyCompleteRing"] = false,
	["OwnDispell"] = false,
	["OwnInterrupt"] = false,
	["PullCountdown"] = false,
	["PvPEmote"] = false,
	["QuestNotifier"] = false,
	["QuestProgress"] = false,
	["RareAlert"] = false,
	["ResetInstance"] = false,
	["SaySapped"] = false,
	["AlertChannel"] = {
		["Options"] = {
			[EMOTE] = 6,
			[PARTY .. " / " .. RAID] = 2,
			[PARTY] = 1,
			[RAID] = 3,
			[SAY] = 4,
			[YELL] = 5,
		},
		["Value"] = 2,
	},
}

-- Automation
C["Automation"] = {
	["AutoBlockStrangerInvites"] = false,
	["AutoCollapse"] = false,
	["AutoDeclineDuels"] = false,
	["AutoGoodbye"] = false,
	["AutoInvite"] = false,
	["AutoOpenItems"] = false,
	["AutoQuest"] = false,
	["AutoRelease"] = false,
	["AutoResurrect"] = false,
	["AutoResurrectThank"] = false,
	["AutoReward"] = false,
	["AutoScreenshot"] = false,
	["AutoSkipCinematic"] = false,
	["AutoSummon"] = false,
	["NoBadBuffs"] = false,
	["AutoLoggingCombat"] = false,
	["WhisperInvite"] = "inv+",
}

C["Inventory"] = {
	["AutoSell"] = true,
	["BagBar"] = true,
	["BagBarMouseover"] = true,
	["BagsItemLevel"] = true,
	["BagsPerRow"] = 6,
	["BagsWidth"] = 12,
	["BankPerRow"] = 10,
	["BankWidth"] = 12,
	["DeleteButton"] = true,
	["Enable"] = true,
	["FilterAmmo"] = true,
	["FilterCollection"] = false,
	["FilterConsumable"] = true,
	["FilterCustom"] = false,
	["FilterEquipSet"] = false,
	["FilterEquipment"] = true,
	["FilterFavourite"] = true,
	["FilterGoods"] = true,
	["FilterJunk"] = true,
	["FilterLegendary"] = false,
	["FilterQuest"] = true,
	["GatherEmpty"] = true,
	["IconSize"] = 34,
	["ItemFilter"] = true,
	["ReverseSort"] = false,
	["ShowNewItem"] = true,
	["SpecialBagsColor"] = false,
	["AutoRepair"] = {
		["Options"] = {
			[NONE] = 0,
			[GUILD] = 1,
			[PLAYER] = 2,
		},
		["Value"] = 2,
	},
}

-- Buffs & Debuffs
C["Auras"] = {
	["BuffSize"] = 32,
	["BuffsPerRow"] = 12,
	["DebuffSize"] = 36,
	["DebuffsPerRow"] = 12,
	["Enable"] = true,
	["HideBlizBuff"] = false,
	["Reminder"] = false,
	["ReverseBuffs"] = false,
	["ReverseDebuffs"] = false,
	["TotemSize"] = 32,
	["Totems"] = true,
	["VerticalTotems"] = false,
}

-- Chat
C["Chat"] = {
	["BlockSpammer"] = true,
	["Background"] = true,
	["BlockAddonAlert"] = false,
	["Chatbar"] = true,
	["BlockStranger"] = false,
	["ChatFilterList"] = "%*",
	["ChatFilterWhiteList"] = "",
	["ChatItemLevel"] = true,
	["ChatMenu"] = true,
	["Emojis"] = false,
	["Enable"] = true,
	["EnableFilter"] = true,
	["Fading"] = true,
	["FadingTimeVisible"] = 100,
	["FilterMatches"] = 1,
	["Freedom"] = true,
	["Height"] = 200,
	["Lock"] = true,
	["LogMax"] = 0,
	["OldChatNames"] = false,
	["Sticky"] = false,
	["WhisperColor"] = true,
	["Width"] = 400,
	["TimestampFormat"] = {
		["Options"] = {
			["Disable"] = 1,
			["03:27 PM"] = 2,
			["03:27:32 PM"] = 3,
			["15:27"] = 4,
			["15:27:32"] = 5,
		},
		["Value"] = 1,
	},
}

-- Datatext
C["DataText"] = {
	["Coords"] = false,
	["Friends"] = true,
	["Gold"] = true,
	["Guild"] = true,
	["GuildSortBy"] = 1,
	["GuildSortOrder"] = true,
	["HideText"] = false,
	["IconColor"] = { 102 / 255, 157 / 255, 255 / 255 },
	["Latency"] = true,
	["Location"] = true,
	["System"] = true,
	["Time"] = true,
}

C["AuraWatch"] = {
	["Enable"] = true,
	["ClickThrough"] = false,
	["IconScale"] = 1,
	["WatchSpellRank"] = false,
	["InternalCD"] = {},
	["AuraList"] = {
		["Switcher"] = {},
		["IgnoreSpells"] = {},
	},
}

-- General
C["General"] = {
	["AutoScale"] = true,
	["ColorTextures"] = false,
	["MinimapIcon"] = false,
	--["MissingTalentAlert"] = true,
	["MoveBlizzardFrames"] = false,
	["NoErrorFrame"] = true,
	["NoTutorialButtons"] = false,
	["TexturesColor"] = { 1, 1, 1 },
	["UIScale"] = 0.71111,
	["UseGlobal"] = false,
	["VersionCheck"] = true,
	["Texture"] = "KkthnxUI",
	["SmoothAmount"] = 0.25,
	["BorderStyle"] = {
		["Options"] = {
			["KkthnxUI"] = "KkthnxUI",
			["AzeriteUI"] = "AzeriteUI",
			["KkthnxUI_Pixel"] = "KkthnxUI_Pixel",
			["KkthnxUI_Blank"] = "KkthnxUI_Blank",
		},
		["Value"] = "KkthnxUI",
	},
	["NumberPrefixStyle"] = {
		["Options"] = {
			["Standard: b/m/k"] = 1,
			["Asian: y/w"] = 2,
			["Full Digits"] = 3,
		},
		["Value"] = 1,
	},
	["Profiles"] = {
		["Options"] = {},
	},
}

-- Loot
C["Loot"] = {
	["AutoConfirm"] = false,
	["AutoGreed"] = false,
	["Enable"] = true,
	["FastLoot"] = true,
	["GroupLoot"] = true,
}

-- Minimap
C["Minimap"] = {
	["Calendar"] = true,
	["EasyVolume"] = false,
	["Enable"] = true,
	["MailPulse"] = false,
	["QueueStatusText"] = false,
	["ShowRecycleBin"] = true,
	["Size"] = 190,
	["RecycleBinPosition"] = {
		["Options"] = {
			["BottomLeft"] = 1,
			["BottomRight"] = 2,
			["TopLeft"] = 3,
			["TopRight"] = 4,
		},
		["Value"] = "BottomLeft",
	},
	["LocationText"] = {
		["Options"] = {
			["Always Display"] = "SHOW",
			["Hide"] = "Hide",
			["Minimap Mouseover"] = "MOUSEOVER",
		},
		["Value"] = "MOUSEOVER",
	},
	["BlipTexture"] = {
		["Options"] = {
			["Blank"] = BlipMedia .. "Blip-Blank",
			["Blizzard Big R"] = BlipMedia .. "Blip-BlizzardBigR",
			["Blizzard Big"] = BlipMedia .. "Blip-BlizzardBig",
			["Charmed"] = BlipMedia .. "Blip-Charmed",
			["Default"] = "Interface\\MiniMap\\ObjectIconsAtlas",
			["Glass Spheres"] = BlipMedia .. "Blip-GlassSpheres",
			["Hunter Z Small"] = BlipMedia .. "Blip-HunterZSmall",
			["Nandini New"] = BlipMedia .. "Blip-Nandini-New",
			["Nandini"] = BlipMedia .. "Blip-Nandini",
			["SolidSpheres"] = BlipMedia .. "Blip-SolidSpheres",
		},
		["Value"] = "Interface\\MiniMap\\ObjectIconsAtlas",
	},
}

-- Miscellaneous
C["Misc"] = {
	["AFKCamera"] = true,
	["AutoBubbles"] = false,
	["AutoDismount"] = false,
	["ColorPicker"] = false,
	["EasyMarking"] = false,
	["Focuser"] = true,
	["EnhancedFriends"] = true,
	["HelmCloakToggle"] = false,
	["EnhancedMail"] = true,
	["ExpRep"] = true,
	["GemEnchantInfo"] = false,
	["HideBossEmote"] = false,
	["ImprovedStats"] = true,
	["StatOrder"] = "12345",
	["ItemLevel"] = true,
	["MaxCameraZoom"] = 2.6,
	["MuteSounds"] = true,
	["PetHappiness"] = false,
	["QueueTimers"] = false,
	["ShowWowHeadLinks"] = false,
	["SlotDurability"] = true,
	["TradeTabs"] = true,
	["ShowMarkerBar"] = {
		["Options"] = {
			["Grids"] = 1,
			["Horizontal"] = 2,
			["Vertical"] = 3,
			[DISABLE] = 4,
		},
		["Value"] = 4,
	},
}

C["Nameplate"] = {
	["AKSProgress"] = false,
	["AuraSize"] = 30,
	["CastTarget"] = false,
	["CastbarGlow"] = true,
	["ClassAuras"] = true,
	["ClassIcon"] = false,
	["ColoredTarget"] = false,
	["CustomColor"] = { 0, 0.8, 0.3 },
	["CustomUnitColor"] = false,
	["CustomUnitList"] = "",
	["DPSRevertThreat"] = false,
	["Distance"] = 41,
	["Enable"] = true,
	["ExecuteRatio"] = 0,
	["FriendlyCC"] = false,
	["FullHealth"] = false,
	["HealthTextSize"] = 15,
	["HostileCC"] = true,
	["InsecureColor"] = { 1, 0, 0 },
	["InsideView"] = true,
	["MaxAuras"] = 8,
	["MinAlpha"] = 1,
	["MinScale"] = 1,
	["NameOnly"] = true,
	["NameTextSize"] = 16,
	["NameplateClassPower"] = false,
	["OffTankColor"] = { 0.2, 0.7, 0.5 },
	["PPGCDTicker"] = true,
	["PPHeight"] = 8,
	["PPHideOOC"] = true,
	["PPIconSize"] = 32,
	["PPOnFire"] = false,
	["PPPHeight"] = 6,
	["PPPowerText"] = true,
	["PPWidth"] = 175,
	["PlateAuras"] = true,
	["PlateHeight"] = 16,
	["PlateWidth"] = 180,
	["PowerUnitList"] = "",
	["QuestIndicator"] = false,
	["SecureColor"] = { 1, 0, 1 },
	["SelectedScale"] = 1.2,
	["ShowPlayerPlate"] = false,
	["Smooth"] = false,
	["TankMode"] = false,
	["TargetColor"] = { 0, 0.6, 1 },
	["TargetIndicatorColor"] = { 1, 1, 1 },
	["TransColor"] = { 1, 0.8, 0 },
	["VerticalSpacing"] = 0.7,
	["AuraFilter"] = {
		["Options"] = {
			["White & Black List"] = 1,
			["List & Player"] = 2,
			["List & Player & CCs"] = 3,
		},
		["Value"] = 3,
	},
	["TargetIndicator"] = {
		["Options"] = {
			["Disable"] = 1,
			["Top Arrow"] = 2,
			["Right Arrow"] = 3,
			["Border Glow"] = 4,
			["Top Arrow + Glow"] = 5,
			["Right Arrow + Glow"] = 6,
		},
		["Value"] = 4,
	},
	["TargetIndicatorTexture"] = {
		["Options"] = {
			["Blue Arrow 2" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\BlueArrow2:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\BlueArrow2]],
			["Blue Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\BlueArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\BlueArrow]],
			["Neon Blue Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonBlueArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonBlueArrow]],
			["Neon Green Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonGreenArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonGreenArrow]],
			["Neon Pink Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonPinkArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonPinkArrow]],
			["Neon Red Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonRedArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonRedArrow]],
			["Neon Purple Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonPurpleArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonPurpleArrow]],
			["Purple Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\PurpleArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\PurpleArrow]],
			["Red Arrow 2" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedArrow2.tga:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedArrow2]],
			["Red Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedArrow]],
			["Red Chevron Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedChevronArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedChevronArrow]],
			["Red Chevron Arrow2" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedChevronArrow2:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedChevronArrow2]],
		},
		["Value"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonBlueArrow]],
	},
}

-- Skins
C["Skins"] = {
	["AtlasLoot"] = false,
	["LortiTextures"] = false,
	["Bartender4"] = false,
	["BigWigs"] = false,
	["BlizzardFrames"] = true,
	["ButtonForge"] = false,
	["ChatBubbleAlpha"] = 0.9,
	["ChatBubbles"] = true,
	["ChocolateBar"] = false,
	["DeadlyBossMods"] = false,
	["Details"] = false,
	["Dominos"] = false,
	["Hekili"] = false,
	["RareScanner"] = false,
	["Skada"] = true,
	["Spy"] = false,
	["TellMeWhen"] = false,
	["TitanPanel"] = false,
	["WeakAuras"] = false,

	["FontScale"] = 1,
	["FontOutline"] = false,
}

-- Tooltip
C["Tooltip"] = {
	["ClassColor"] = true,
	["CombatHide"] = false,
	["ShowTalents"] = true,
	["Cursor"] = false,
	["Enable"] = true,
	["FactionIcon"] = true,
	["HideRank"] = true,
	["HideRealm"] = true,
	["HideTitle"] = true,
	["Icons"] = true,
	["ShowIDs"] = true,
	["TargetBy"] = true,
}

-- Unitframe
C["Unitframe"] = {
	["AllTextScale"] = 1, -- Testing

	["AdditionalPower"] = false,
	["AutoAttack"] = true,
	["CastClassColor"] = false,
	["CastReactionColor"] = false,
	["CastbarLatency"] = true,
	["ClassResources"] = false,
	["CombatFade"] = false,
	["CombatText"] = false,
	["DebuffHighlight"] = true,
	["Enable"] = true,
	["FCTOverHealing"] = false,
	["GlobalCooldown"] = true,
	["HotsDots"] = true,
	["OnlyShowPlayerDebuff"] = false,

	-- Player
	["PlayerBuffs"] = false,
	["PlayerBuffsPerRow"] = 7,
	["PlayerCastbar"] = true,
	["PlayerCastbarHeight"] = 25,
	["PlayerCastbarIcon"] = true,
	["PlayerCastbarWidth"] = 360,
	["PlayerDebuffs"] = false,
	["PlayerDebuffsPerRow"] = 6,
	["PlayerHealthHeight"] = 36,
	["PlayerHealthWidth"] = 190,
	["PlayerPowerHeight"] = 16,

	["PvPIndicator"] = true,
	["ShowHealPrediction"] = true,
	["ShowPlayerLevel"] = true,
	["Smooth"] = false,
	["Swingbar"] = false,
	["SwingbarTimer"] = false,

	-- Target
	["TargetHealthHeight"] = 36,
	["TargetHealthWidth"] = 190,
	["TargetPowerHeight"] = 16,
	["TargetBuffs"] = true,
	["TargetBuffsPerRow"] = 6,
	["TargetCastbar"] = true,
	["TargetCastbarIcon"] = true,
	["TargetCastbarHeight"] = 25,
	["TargetCastbarWidth"] = 200,
	["TargetDebuffs"] = true,
	["TargetDebuffsPerRow"] = 6,

	-- Focus
	["FocusBuffs"] = true,
	["FocusCastbar"] = true,
	["FocusCastbarHeight"] = 20,
	["FocusCastbarIcon"] = true,
	["FocusCastbarWidth"] = 180,
	["FocusDebuffs"] = true,
	["FocusHealthHeight"] = 28,
	["FocusHealthWidth"] = 150,
	["FocusPowerHeight"] = 12,

	-- TargetOfTarget
	["TargetTargetHealthHeight"] = 24,
	["TargetTargetHealthWidth"] = 80,
	["TargetTargetPowerHeight"] = 12,
	["HideTargetOfTargetLevel"] = true,
	["HideTargetOfTargetName"] = false,
	["HideTargetofTarget"] = false,

	-- Pet
	["PetHealthHeight"] = 18,
	["PetHealthWidth"] = 90,
	["PetPowerHeight"] = 12,
	["HidePetLevel"] = true,
	["HidePetName"] = false,
	["HidePet"] = false,

	-- FocusTarget
	["FocusTargetHealthHeight"] = 18,
	["FocusTargetHealthWidth"] = 80,
	["FocusTargetPowerHeight"] = 12,
	["HideFocusTargetLevel"] = true,
	["HideFocusTargetName"] = false,
	["HideFocusTarget"] = false,

	["HealthbarColor"] = {
		["Options"] = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		["Value"] = "Class",
	},
	["PortraitStyle"] = {
		["Options"] = {
			["Overlay Portrait"] = "OverlayPortrait",
			["3D Portraits"] = "ThreeDPortraits",
			["Class Portraits"] = "ClassPortraits",
			["New Class Portraits"] = "NewClassPortraits",
			["Default Portraits"] = "DefaultPortraits",
			["No Portraits"] = "NoPortraits",
		},
		["Value"] = "NoPortraits",
	},
}

C["Party"] = {
	["CastbarIcon"] = false,
	["Castbars"] = false,
	["Enable"] = false,
	["HealthHeight"] = 20,
	["HealthWidth"] = 134,
	["PortraitTimers"] = false,
	["PowerHeight"] = 10,
	["ShowBuffs"] = true,
	["ShowHealPrediction"] = true,
	["ShowPartySolo"] = false,
	["ShowPet"] = false,
	["ShowPlayer"] = true,
	["Smooth"] = false,
	["TargetHighlight"] = false,
	["HealthbarColor"] = {
		["Options"] = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		["Value"] = "Class",
	},
}

C["Boss"] = {
	["CastbarIcon"] = true,
	["Castbars"] = true,
	["Enable"] = false,
	["Smooth"] = false,
	["HealthHeight"] = 20,
	["HealthWidth"] = 134,
	["PowerHeight"] = 10,
	["YOffset"] = 54,
	["HealthbarColor"] = {
		["Options"] = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		["Value"] = "Class",
	},
}

C["Arena"] = {
	["CastbarIcon"] = true,
	["Castbars"] = true,
	["Enable"] = true,
	["Smooth"] = false,
	["HealthHeight"] = 20,
	["HealthWidth"] = 134,
	["PowerHeight"] = 10,
	["YOffset"] = 54,
	["HealthbarColor"] = {
		["Options"] = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		["Value"] = "Class",
	},
}

-- Raidframe
C["Raid"] = {
	["DebuffWatch"] = false,
	["DebuffWatchDefault"] = false,
	["DesaturateBuffs"] = false,
	["Enable"] = false,
	["Height"] = 44,
	["HorizonRaid"] = false,
	["MainTankFrames"] = false,
	["ManabarShow"] = false,
	["NumGroups"] = 6,
	["RaidUtility"] = false,
	["ReverseRaid"] = false,
	["ShowHealPrediction"] = false,
	["ShowNotHereTimer"] = false,
	["ShowRaidSolo"] = false,
	["ShowTeamIndex"] = false,
	["Smooth"] = false,
	["TargetHighlight"] = false,
	["Width"] = 70,
	["RaidBuffsStyle"] = {
		["Options"] = {
			["Aura Track"] = "Aura Track",
			["Standard"] = "Standard",
			["None"] = "None",
		},
		["Value"] = "Aura Track",
	},
	["RaidBuffs"] = {
		["Options"] = {
			["Only my buffs"] = "Self",
			["Only castable buffs"] = "Castable",
			["All buffs"] = "All",
		},
		["Value"] = "Self",
	},
	["AuraTrack"] = false,
	["AuraTrackIcons"] = false,
	["AuraTrackSpellTextures"] = false,
	["AuraTrackThickness"] = 5,

	["HealthbarColor"] = {
		["Options"] = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		["Value"] = "Class",
	},
	["HealthFormat"] = {
		["Options"] = {
			["Disable HP"] = 1,
			["Health Percentage"] = 2,
			["Health Remaining"] = 3,
			["Health Lost"] = 4,
		},
		["Value"] = 1,
	},
}

-- Worldmap
C["WorldMap"] = {
	["AlphaWhenMoving"] = 0.2,
	["Coordinates"] = true,
	["FadeWhenMoving"] = true,
	["MapRevealGlow"] = true,
	["MapRevealGlowColor"] = { 0.7, 0.7, 0.7 },
}
