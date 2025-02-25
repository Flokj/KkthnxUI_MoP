local C = KkthnxUI[2]

local DISABLE = DISABLE
local EMOTE = EMOTE
local GUILD = GUILD
local NONE = NONE
local PARTY = PARTY
local PLAYER = PLAYER
local RAID = RAID
local SAY = SAY
local YELL = YELL

-- Actionbar
C["ActionBar"] = {
	Enable = true,
	Hotkeys = true,
	Macro = true,
	Grid = true,
	Cooldown = true,
	MmssTH = 60,
	TenthTH = 3,
	OverrideWA = true,
	MicroMenu = true,
	FadeMicroMenu = false,
	ShowStance = true,
	EquipColor = true,
	TotemBar = true,
	TotemBarSize = 32,
	KeyDown = true,
	ButtonLock = true,
	VehButtonSize = 34,

	Bar1 = true,
	Bar1Flyout = 1,
	Bar1Size = 32,
	Bar1Font = 12,
	Bar1Num = 12,
	Bar1PerRow = 12,
	Bar1Fade = false,

	Bar2 = true,
	Bar2Flyout = 1,
	Bar2Size = 32,
	Bar2Font = 12,
	Bar2Num = 12,
	Bar2PerRow = 12,
	Bar2Fade = false,

	Bar3 = true,
	Bar3Flyout = 1,
	Bar3Size = 32,
	Bar3Font = 12,
	Bar3Num = 12,
	Bar3PerRow = 12,
	Bar3Fade = false,

	Bar4 = true,
	Bar4Flyout = 3,
	Bar4Size = 32,
	Bar4Font = 12,
	Bar4Num = 12,
	Bar4PerRow = 4,
	Bar4Fade = false,

	Bar5 = true,
	Bar5Flyout = 3,
	Bar5Size = 32,
	Bar5Font = 12,
	Bar5Num = 12,
	Bar5PerRow = 4,
	Bar5Fade = false,

	BarPetSize = 26,
	BarPetFont = 12,
	BarPetPerRow = 10,
	BarPetFade = false,

	BarStanceSize = 30,
	BarStanceFont = 12,
	BarStancePerRow = 10,
	BarStanceFade = false,

	Bar6 = false,
	Bar6Flyout = 1,
	Bar6Size = 32,
	Bar6Font = 12,
	Bar6Num = 12,
	Bar6PerRow = 12,
	Bar6Fade = false,

	Bar7 = false,
	Bar7Flyout = 1,
	Bar7Size = 32,
	Bar7Font = 12,
	Bar7Num = 12,
	Bar7PerRow = 12,
	Bar7Fade = false,

	Bar8 = false,
	Bar8Flyout = 1,
	Bar8Size = 32,
	Bar8Font = 12,
	Bar8Num = 12,
	Bar8PerRow = 12,
	Bar8Fade = false,

	BarFadeGlobal = true,
	BarFadeAlpha = 0.1,
	BarFadeDelay = 0,
	BarFadeCombat = true,
	BarFadeTarget = true,
	BarFadeCasting = true,
	BarFadeHealth = true,
	BarFadeVehicle = true,
}

-- Announcements
C["Announcements"] = {
	BrokenAlert = false,
	DispellAlert = false,
	HealthAlert = false,
	InstAlertOnly = false,
	InterruptAlert = false,
	ItemAlert = false,
	OnlyCompleteRing = false,
	OwnDispell = false,
	OwnInterrupt = false,
	PullCountdown = true,
	PvPEmote = true,
	QuestNotifier = false,
	QuestProgress = false,
	ResetInstance = false,
	SaySapped = false,
	AlertChannel = {
		Options = {
			[EMOTE] = 6,
			[PARTY .. " / " .. RAID] = 2,
			[PARTY] = 1,
			[RAID] = 3,
			[SAY] = 4,
			[YELL] = 5,
		},
		Value = 2,
	},
}

-- Automation
C["Automation"] = {
	AutoDeclineDuels = false,
	AutoInvite = false,
	AutoOpenItems = false,
	AutoQuest = false,
	AutoRelease = false,
	AutoResurrect = false,
	AutoResurrectThank = false,
	AutoReward = false,
	AutoSkipCinematic = false,
	AutoSummon = false,
	NoBadBuffs = false,
	AutoLoggingCombat = false,
	WhisperInviteRestriction = false,
	WhisperInvite = "inv+",
}

C["Inventory"] = {
	AutoSell = true,
	BagBar = true,
	BagBarMouseover = false,
	BagBarSize = 32,
	BagsBindOnEquip = false,
	BagsItemLevel = true,
	BagsPerRow = 8,
	BagsWidth = 12,
	BankPerRow = 12,
	BankWidth = 12,
	DeleteButton = true,
	Enable = true,
	FilterAmmo = true,
	FilterCollection = true,
	FilterConsumable = true,
	FilterCustom = false,
	FilterEquipSet = false,
	FilterEquipment = true,
	FilterFavourite = true,
	FilterGoods = true,
	FilterJunk = true,
	FilterLegendary = false,
	FilterQuest = true,
	GatherEmpty = true,
	IconSize = 34,
	ItemFilter = true,
	JustBackpack = false,
	ReverseSort = false,
	ShowNewItem = true,
	SpecialBagsColor = false,
	GrowthDirection = {
		Options = {
			["Horizontal"] = "HORIZONTAL",
			["Vertical"] = "VERTICAL",
		},
		Value = "HORIZONTAL",
	},
	SortDirection = {
		Options = {
			["Ascending"] = "ASCENDING",
			["Descending"] = "DESCENDING",
		},
		Value = "DESCENDING",
	},
	AutoRepair = {
		Options = {
			[NONE] = 0,
			[GUILD] = 1,
			[PLAYER] = 2,
		},
		Value = 2,
	},
}

-- Buffs & Debuffs
C["Auras"] = {
	BuffSize = 34,
	BuffsPerRow = 12,
	DebuffSize = 36,
	DebuffsPerRow = 12,
	Enable = true,
	HideBlizBuff = false,
	Reminder = false,
	ReverseBuffs = false,
	ReverseDebuffs = false,
	TotemSize = 32,
	Totems = false,
	VerticalTotems = false,
}

-- Chat
C["Chat"] = {
	Background = true,
	Chatbar = true,
	ChatItemLevel = true,
	ChatItemGem = false,
	ChatMenu = true,
	ConfigButton = true,
	CopyButton = true,
	Emojis = false,
	ChatClassColor = true,
	Enable = true,
	Fading = true,
	FadingTimeVisible = 100,
	Freedom = true,
	Height = 200,
	Lock = true,
	LogMax = 0,
	OldChatNames = false,
	RollButton = true,
	Sticky = false,
	WhisperColor = true,
	Width = 400,
	TimestampFormat = {
		Options = {
			["Disable"] = 1,
			["03:27 PM"] = 2,
			["03:27:32 PM"] = 3,
			["15:27"] = 4,
			["15:27:32"] = 5,
		},
		Value = 4,
	},
}

-- Datatext
C["DataText"] = {
	Coords = false,
	Friends = false,
	Gold = true,
	Guild = false,
	GuildSortBy = 1,
	GuildSortOrder = true,
	HideText = false,
	IconColor = { 102 / 255, 157 / 255, 255 / 255 },
	Latency = true,
	Location = true,
	Spec = true,
	System = true,
	Time = true,
}

C["AuraWatch"] = {
	Enable = false,
	ClickThrough = false,
	IconScale = 1,
	MinCD = 3,
}

-- General
C["General"] = {
	AutoScale = true,
	ColorTextures = true,
	MinimapIcon = false,
	MoveBlizzardFrames = true,
	NoErrorFrame = true,
	NoTutorialButtons = false,
	TexturesColor = { 1, 1, 1 },
	UIScale = 0.71,
	UseGlobal = false,
	Texture = "Flat",
	SmoothAmount = 0.25,
	BorderStyle = {
		Options = {
			["KkthnxUI"] = "KkthnxUI",
			["AzeriteUI"] = "AzeriteUI",
			["KkthnxUI_Pixel"] = "KkthnxUI_Pixel",
			["KkthnxUI_Blank"] = "KkthnxUI_Blank",
		},
		Value = "KkthnxUI",
	},
	NumberPrefixStyle = {
		Options = {
			["Standard: b/m/k"] = 1,
			["Asian: y/w"] = 2,
			["Full Digits"] = 3,
		},
		Value = 1,
	},
	Profiles = {
		Options = {},
	},
	DeleteProfiles = {
		Options = {},
	},
	GlowMode = {
		Options = {
			["Pixel"] = 1,
			["Autocast"] = 2,
			["Action Button"] = 3,
			["Proc Glow"] = 4,
		},
		Value = 3,
	},
}

-- Loot
C["Loot"] = {
	AutoConfirmLoot = false,
	AutoGreed = false,
	Enable = true,
	FastLoot = true,
	GroupLoot = true,
}

-- Minimap
C["Minimap"] = {
	Calendar = true,
	EasyVolume = false,
	Enable = true,
	MailPulse = false,
	QueueStatusText = false,
	ShowRecycleBin = true,
	Size = 190,
	RecycleBinPosition = {
		Options = {
			["BottomLeft"] = 1,
			["BottomRight"] = 2,
			["TopLeft"] = 3,
			["TopRight"] = 4,
		},
		Value = "BottomLeft",
	},
	LocationText = {
		Options = {
			["Always Display"] = "SHOW",
			["Hide"] = "Hide",
			["Minimap Mouseover"] = "MOUSEOVER",
		},
		Value = "MOUSEOVER",
	},
}

-- Miscellaneous
C["Misc"] = {
	AFKCamera = false,
	AlreadyKnown = true,
	AutoBubbles = false,
	ColorPicker = true,
	ClassColorPlus = true,
	Focuser = false,
	EnhancedFriends = true,
	HelmCloakToggle = true,
	EnhancedMail = true,
	ExpRep = true,
	GemEnchantInfo = true,
	HideBossEmote = true,
	ItemLevel = true,
	MailSaver = false,
	MailTarget = "",
	MaxCameraZoom = 2.6,
	MuteSounds = true,
	QueueTimers = true,
	ShowWowHeadLinks = false,
	SlotDurability = true,
	SlotDurabilityWarning = true,
	TradeTabs = true,
	RaidTool = true,
	DBMCount = "12",
	EasyMarking = false,
	MarkerBarSize = 22,
	EasyMarkKey = {
		Options = {
			["CTRL"] = 1,
			["ALT"] = 2,
			["SHIFT"] = 3,
			["DISABLE"] = 4,
		},
		Value = 1,
	},
	ShowMarkerBar = {
		Options = {
			["Grids"] = 1,
			["Horizontal"] = 2,
			["Vertical"] = 3,
			["DISABLE"] = 4,
		},
		Value = 4,
	},
	ThreatEnable = true,
	ThreatHeight = 17,
	ThreatWidth = 220,
	ThreatBarRows = 5,
	ThreatHideSolo = false,
}

C["Nameplate"] = {
	ColorByDot = false, -- This is not ready
	DotColor = { 1, 0.5, 0.2 },
	DotSpellList = {
		Spells = {},
	},
	AuraSize = 30,
	CastTarget = false,
	ClassIcon = false,
	ColoredTarget = false,
	CustomColor = { 0, 0.8, 0.3 },
	CustomUnitColor = false,
	CustomUnitList = "",
	DPSRevertThreat = false,
	Distance = 41,
	Enable = true,
	ExecuteRatio = 0,
	FriendlyCC = false,
	FullHealth = true,
	HealthTextSize = 15,
	HostileCC = true,
	InsecureColor = { 1, 0, 0 },
	InsideView = true,
	MaxAuras = 8,
	MinAlpha = 1,
	MinScale = 1,
	NameOnly = true,
	NameTextSize = 16,
	NameplateClassPower = false,
	OffTankColor = { 0.2, 0.7, 0.5 },
	PPGCDTicker = true,
	PPHeight = 8,
	PPHideOOC = true,
	PPIconSize = 32,
	PPOnFire = false,
	PPPHeight = 6,
	PPPowerText = true,
	PPWidth = 175,
	PlateAuras = true,
	PlateHeight = 18,
	PlateWidth = 190,
	PowerUnitList = "",
	QuestIndicator = true,
	SecureColor = { 1, 0, 1 },
	SelectedScale = 1.2,
	ShowPlayerPlate = false,
	Smooth = false,
	TarName = false,
	TankMode = false,
	TargetColor = { 0, 0.6, 1 },
	TargetIndicatorColor = { 1, 1, 1 },
	TransColor = { 1, 0.8, 0 },
	VerticalSpacing = 0.7,
	AuraFilter = {
		Options = {
			["White & Black List"] = 1,
			["List & Player"] = 2,
			["List & Player & CCs"] = 3,
		},
		Value = 3,
	},
	TargetIndicator = {
		Options = {
			["Disable"] = 1,
			["Top Arrow"] = 2,
			["Right Arrow"] = 3,
			["Border Glow"] = 4,
			["Top Arrow + Glow"] = 5,
			["Right Arrow + Glow"] = 6,
		},
		Value = 4,
	},
	TargetIndicatorTexture = {
		Options = {
			["Blue Arrow 2" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\BlueArrow2:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\BlueArrow2]],
			["Blue Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\BlueArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\BlueArrow]],
			["Neon Blue Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonBlueArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonBlueArrow]],
			["Neon Green Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonGreenArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonGreenArrow]],
			["Neon Pink Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonPinkArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonPinkArrow]],
			["Neon Red Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonRedArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonRedArrow]],
			["Neon Purple Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\NeonPurpleArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonPurpleArrow]],
			["Purple Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\PurpleArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\PurpleArrow]],
			["Red Arrow 2" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedArrow2:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedArrow2]],
			["Red Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedArrow]],
			["Red Chevron Arrow" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedChevronArrow:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedChevronArrow]],
			["Red Chevron Arrow2" .. "|TInterface\\Addons\\KkthnxUI\\Media\\Nameplates\\RedChevronArrow2:0|t"] = [[Interface\AddOns\KkthnxUI\Media\Nameplates\RedChevronArrow2]],
		},
		Value = [[Interface\AddOns\KkthnxUI\Media\Nameplates\NeonBlueArrow]],
	},
}

-- Skins
C["Skins"] = {
	AtlasLoot = false,
	Bartender4 = false,
	BigWigs = false,
	BlizzardFrames = true,
	ButtonForge = false,
	ChatBubbleAlpha = 0.9,
	ChatBubbles = true,
	ChocolateBar = false,
	DeadlyBossMods = true,
	Details = false,
	Dominos = false,
	RareScanner = false,
	Skada = true,
	WeakAuras = false,
	TradeSkills = true,
	Trainers = true,
	ObjectiveFontSize = 12,
	QuestFontSize = 12,
}

-- Tooltip
C["Tooltip"] = {
	ItemQuality = true,
	Enable = true,
	FactionIcon = true,
	HideJunkGuild = false,
	HideRank = true,
	HideRealm = true,
	HideTitle = true,
	Icons = true,
	LFDRole = false,
	ShowIDs = true,
	TargetBy = true,
	SpecLevelByShift = false,
	CursorMode = {
		Options = {
			["DISABLE"] = 1,
			["LEFT"] = 2,
			["TOP"] = 3,
			["RIGHT"] = 4,
		},
		Value = 1,
	},	
	TipAnchor = {
		Options = {
			["TOPLEFT"] = 1,
			["TOPRIGHT"] = 2,
			["BOTTOMLEFT"] = 3,
			["BOTTOMRIGHT"] = 4,
		},
		Value = 4,
	},
	HideInCombat = {
		Options = {
			["DISABLE"] = 1,
			["ALT"] = 2,
			["SHIFT"] = 3,
			["CTRL"] = 4,
			["ALWAYS"] = 5,
		},
		Value = 1,
	},	
}

-- Unitframe
C["Unitframe"] = {
	AllTextScale = 1.1,
	AdditionalPower = false,
	AutoAttack = true,
	CastClassColor = true,
	CastReactionColor = false,
	CastbarLatency = true,
	ClassResources = false,
	CombatFade = false,
	CombatText = false,
	DebuffHighlight = false,
	Enable = true,
	Range = true,
	FCTOverHealing = false,
	GlobalCooldown = true,
	HotsDots = true,
	OnlyShowPlayerDebuff = false,

	-- Player
	PlayerBuffs = false,
	PlayerBuffsPerRow = 7,
	PlayerCastbar = true,
	PlayerCastbarHeight = 25,
	PlayerCastbarIcon = true,
	PlayerCastbarWidth = 360,
	PlayerDebuffs = false,
	PlayerDebuffsPerRow = 6,
	PlayerHealthHeight = 36,
	PlayerHealthWidth = 190,
	PlayerPowerHeight = 16,

	PvPIndicator = false,
	ShowHealPrediction = true,
	ShowPlayerLevel = true,
	Smooth = false,

	SwingBar = false,
	SwingWidth = 320,
	SwingHeight = 10,
	SwingTimer = false,
	OffOnTop = false,

	-- Target
	TargetHealthHeight = 36,
	TargetHealthWidth = 190,
	TargetPowerHeight = 16,
	TargetBuffs = true,
	TargetBuffsPerRow = 6,
	TargetCastbar = true,
	TargetCastbarIcon = true,
	TargetCastbarHeight = 25,
	TargetCastbarWidth = 200,
	TargetDebuffs = true,
	TargetDebuffsPerRow = 6,

	-- Focus
	FocusBuffs = true,
	FocusCastbar = false,
	FocusCastbarHeight = 20,
	FocusCastbarIcon = true,
	FocusCastbarWidth = 180,
	FocusDebuffs = true,
	FocusHealthHeight = 28,
	FocusHealthWidth = 150,
	FocusPowerHeight = 12,

	-- TargetOfTarget
	TargetTargetHealthHeight = 24,
	TargetTargetHealthWidth = 80,
	TargetTargetPowerHeight = 12,
	HideTargetOfTargetLevel = true,
	HideTargetOfTargetName = false,
	HideTargetofTarget = false,

	-- Pet
	PetHealthHeight = 18,
	PetHealthWidth = 90,
	PetPowerHeight = 12,
	HidePetLevel = true,
	HidePetName = false,
	HidePet = false,

	-- FocusTarget
	FocusTargetHealthHeight = 18,
	FocusTargetHealthWidth = 80,
	FocusTargetPowerHeight = 12,
	HideFocusTargetLevel = true,
	HideFocusTargetName = false,
	HideFocusTarget = true,

	HealthbarColor = {
		Options = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		Value = "Class",
	},
	PortraitStyle = {
		Options = {
			["Overlay Portrait"] = "OverlayPortrait",
			["3D Portraits"] = "ThreeDPortraits",
			["Class Portraits"] = "ClassPortraits",
			["New Class Portraits"] = "NewClassPortraits",
			["Default Portraits"] = "DefaultPortraits",
			["No Portraits"] = "NoPortraits",
		},
		Value = "NoPortraits",
	},
}

C["Party"] = {
	CastbarIcon = false,
	Castbars = false,
	Enable = false,
	HealthHeight = 22,
	HealthWidth = 150,
	PortraitTimers = false,
	PowerHeight = 12,
	ShowBuffs = false,
	ShowHealPrediction = true,
	ShowPartySolo = false,
	ShowPet = false,
	ShowPlayer = true,
	Smooth = false,
	TargetHighlight = false,
	HealthbarColor = {
		Options = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		Value = "Class",
	},
}

C["Boss"] = {
	Castbars = true,
	Enable = true,
	Smooth = false,
	HealthHeight = 20,
	HealthWidth = 134,
	PowerHeight = 10,
	YOffset = 54,
	HealthbarColor = {
		Options = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		Value = "Class",
	},
}

C["Arena"] = {
	CastbarIcon = true,
	Castbars = true,
	Enable = true,
	Smooth = false,
	HealthHeight = 20,
	HealthWidth = 134,
	PowerHeight = 10,
	YOffset = 54,
	HealthbarColor = {
		Options = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		Value = "Class",
	},
}

-- Raidframe
C["Raid"] = {
	DebuffWatch = false,
	DebuffWatchDefault = false,
	DesaturateBuffs = false,
	Enable = false,
	Height = 44,
	HorizonRaid = false,
	MainTankFrames = false,
	PowerBarShow = false,
	ManabarShow = false,
	NumGroups = 6,
	ReverseRaid = false,
	ShowHealPrediction = false,
	ShowNotHereTimer = false,
	ShowRaidSolo = false,
	ShowTeamIndex = false,
	Smooth = false,
	TargetHighlight = false,
	Width = 70,
	RaidBuffsStyle = {
		Options = {
			["Aura Track"] = "Aura Track",
			["Standard"] = "Standard",
			["None"] = "None",
		},
		Value = "Aura Track",
	},
	RaidBuffs = {
		Options = {
			["Only my buffs"] = "Self",
			["Only castable buffs"] = "Castable",
			["All buffs"] = "All",
		},
		Value = "Self",
	},
	AuraTrack = false,
	AuraTrackIcons = false,
	AuraTrackSpellTextures = false,
	AuraTrackThickness = 5,

	HealthbarColor = {
		Options = {
			["Dark"] = "Dark",
			["Value"] = "Value",
			["Class"] = "Class",
		},
		Value = "Class",
	},
	HealthFormat = {
		Options = {
			["Disable HP"] = 1,
			["Health Percentage"] = 2,
			["Health Remaining"] = 3,
			["Health Lost"] = 4,
		},
		Value = 1,
	},
}

-- Worldmap
C["WorldMap"] = {
	SmallWorldMap = true,
	AlphaWhenMoving = 0.2,
	Coordinates = false,
	FadeWhenMoving = true,
	MapRevealGlow = true,
	MaxMapScale = 0.7,
	MapScale = 0.9,
}
