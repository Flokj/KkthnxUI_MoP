local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Skins")

local function ExythUIColor()
		for i, v in pairs({
			-- UNIT FRAMES
			PlayerFrameTexture,
			TargetFrameTextureFrameTexture,
			PetFrameTexture,
			PartyMemberFrame1Texture,
			PartyMemberFrame2Texture,
			PartyMemberFrame3Texture,
			PartyMemberFrame4Texture,
			PartyMemberFrame1PetFrameTexture,
			PartyMemberFrame2PetFrameTexture,
			PartyMemberFrame3PetFrameTexture,
			PartyMemberFrame4PetFrameTexture,
			TargetFrameToTTextureFrameTexture,
			FocusFrameToTTextureFrameTexture,
			FocusFrameTextureFrameTexture,
			--[[Boss1TargetFrameTextureFrameTexture,
			Boss2TargetFrameTextureFrameTexture,
			Boss3TargetFrameTextureFrameTexture,
			Boss4TargetFrameTextureFrameTexture,
			Boss5TargetFrameTextureFrameTexture,
			Boss1TargetFrameSpellBar.Border,
			Boss2TargetFrameSpellBar.Border,
			Boss3TargetFrameSpellBar.Border,
			Boss4TargetFrameSpellBar.Border,
			Boss5TargetFrameSpellBar.Border,]]
			Rune1BorderTexture,
			Rune2BorderTexture,
			Rune3BorderTexture,
			Rune4BorderTexture,
			Rune5BorderTexture,
			Rune6BorderTexture,
			CastingBarFrame.Border,
			FocusFrameSpellBar.Border,
			TargetFrameSpellBar.Border,
		--	TargetFrameSpellBar.BorderShield,
		--	FocusFrameSpellBar.BorderShield,
			TotemBorderTexture,
			-- MainMenuBar
			SlidingActionBarTexture0,
			SlidingActionBarTexture1,
			BonusActionBarTexture0,
			BonusActionBarTexture1,
			BonusActionBarTexture,
			MainMenuBarTexture0,
			MainMenuBarTexture1,
			MainMenuBarTexture2,
			MainMenuBarTexture3,
			MainMenuMaxLevelBar0,
			MainMenuMaxLevelBar1,
			MainMenuMaxLevelBar2,
			MainMenuMaxLevelBar3,
			MainMenuXPBarTexture0,
			MainMenuXPBarTexture1,
			MainMenuXPBarTexture2,
			MainMenuXPBarTexture3,
			ReputationWatchBarTexture0,
			ReputationWatchBarTexture1,
			ReputationWatchBarTexture2,
			ReputationWatchBarTexture3,
			ReputationXPBarTexture0,
			ReputationXPBarTexture1,
			ReputationXPBarTexture2,
			ReputationXPBarTexture3,
			MainMenuBarLeftEndCap,
			MainMenuBarRightEndCap,
			StanceBarLeft,
			StanceBarMiddle,
			StanceBarRight,
			ShapeshiftBarLeft,
			ShapeshiftBarMiddle,
			ShapeshiftBarRight,
			-- ArenaFrames
			ArenaEnemyFrame1Texture,
			ArenaEnemyFrame2Texture,
			ArenaEnemyFrame3Texture,
			ArenaEnemyFrame4Texture,
			ArenaEnemyFrame5Texture,
			ArenaEnemyFrame1SpecBorder,
			ArenaEnemyFrame2SpecBorder,
			ArenaEnemyFrame3SpecBorder,
			ArenaEnemyFrame4SpecBorder,
			ArenaEnemyFrame5SpecBorder,
			ArenaEnemyFrame1PetFrameTexture,
			ArenaEnemyFrame2PetFrameTexture,
			ArenaEnemyFrame3PetFrameTexture,
			ArenaEnemyFrame4PetFrameTexture,
			ArenaEnemyFrame5PetFrameTexture,
			ArenaPrepFrame1Texture,
			ArenaPrepFrame2Texture,
			ArenaPrepFrame3Texture,
			ArenaPrepFrame4Texture,
			ArenaPrepFrame5Texture,
			ArenaPrepFrame1SpecBorder,
			ArenaPrepFrame2SpecBorder,
			ArenaPrepFrame3SpecBorder,
			ArenaPrepFrame4SpecBorder,
			ArenaPrepFrame5SpecBorder,
			-- PANES
			CharacterFrameTitleBg,
			CharacterFrameBg,
			-- MINIMAP
			MinimapBorder,
			MinimapBorderTop,
			MiniMapTrackingButtonBorder,
			-- CompactRaidFrame
			CompactRaidFrameManagerBorderTop,
			CompactRaidFrameManagerBorderTopLeft,
			CompactRaidFrameManagerBorderTopRight,
			CompactRaidFrameManagerBorderBottom,
			CompactRaidFrameManagerBorderBottomLeft,
			CompactRaidFrameManagerBorderBottomRight,
			CompactRaidFrameManagerBorderLeft,
			CompactRaidFrameManagerBorderRight,
			CompactRaidFrameManagerBg,
			CompactRaidFrameContainerBorderFrameBorderTop,
			CompactRaidFrameContainerBorderFrameBorderTopLeft,
			CompactRaidFrameContainerBorderFrameBorderTopRight,
			CompactRaidFrameContainerBorderFrameBorderBottom,
			CompactRaidFrameContainerBorderFrameBorderBottomLeft,
			CompactRaidFrameContainerBorderFrameBorderBottomRight,
			CompactRaidFrameContainerBorderFrameBorderLeft,
			CompactRaidFrameContainerBorderFrameBorderRight,
			select(1, ComboPoint1:GetRegions()),
			select(1, ComboPoint2:GetRegions()),
			select(1, ComboPoint3:GetRegions()),
			select(1, ComboPoint4:GetRegions()),
			select(1, ComboPoint5:GetRegions())
		}) do
			v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end

	local CustomTotemBorder1 = CreateFrame("Frame", "CustomTotemBorder1", TotemFrameTotem1)
	CustomTotemBorder1Texture = CustomTotemBorder1:CreateTexture(nil, "OVERLAY")
	CustomTotemBorder1Texture:SetPoint("CENTER", TotemFrameTotem1)

	local CustomTotemBorder2 = CreateFrame("Frame", "CustomTotemBorder2", TotemFrameTotem2)
	CustomTotemBorder2Texture = CustomTotemBorder2:CreateTexture(nil, "OVERLAY")
	CustomTotemBorder2Texture:SetPoint("CENTER", TotemFrameTotem2)

	local CustomTotemBorder3 = CreateFrame("Frame", "CustomTotemBorder3", TotemFrameTotem3)
	CustomTotemBorder3Texture = CustomTotemBorder3:CreateTexture(nil, "OVERLAY")
	CustomTotemBorder3Texture:SetPoint("CENTER", TotemFrameTotem3)

	local CustomTotemBorder4 = CreateFrame("Frame", "CustomTotemBorder4", TotemFrameTotem4)
	CustomTotemBorder4Texture = CustomTotemBorder4:CreateTexture(nil, "OVERLAY")
	CustomTotemBorder4Texture:SetPoint("CENTER", TotemFrameTotem4)

	for i = 1, 4 do
   	 _G["CustomTotemBorder" .. i]:SetFrameLevel(11)
    	_G["CustomTotemBorder" .. i .. "Texture"]:SetTexture("Interface\\CharacterFrame\\TotemBorder")
    	_G["CustomTotemBorder" .. i .. "Texture"]:SetSize(38, 38)
	end

	for i = 1, 4 do
		_G["CustomTotemBorder" .. i .. "Texture"]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end
	
	if C["Skins"].LortiTextures then 

	  --BANK
	  local vectors = {BankFrame:GetRegions()}
	  for i = 1, 3 do
		  vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	  end

	  --Darker color stuff
	  for i,v in pairs({
		  LootFrameInsetBg,
			LootFrameTitleBg,
		  MerchantFrameTitleBg,
	  }) do
			 v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	  end

	  --PAPERDOLL/Characterframe
	  local a, b, c, d, _, e = PaperDollFrame:GetRegions()
	  for _, v in pairs({a, b, c, d, e })do
			 v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	  end

	  -- WorldMapFrame
	  local vectors = {WorldMapFrame.BorderFrame:GetRegions()}
	  for i = 1, 12 do
		  vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	  end
		
	  -- GameMenuFrame
	  local vectors = {GameMenuFrame:GetRegions()}
	  for i = 1, 1 do
		  vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	  end

	  for i, v in pairs({
		  GameMenuFrame.RightEdge,
		  GameMenuFrame.LeftEdge,
		  GameMenuFrame.BottomRightCorner,
		  GameMenuFrame.BottomLeftCorner,
		  GameMenuFrame.TopRightCorner,
		  GameMenuFrame.TopLeftCorner,
		  GameMenuFrame.BottomEdge,
		  GameMenuFrame.TopEdge
	  }) do
		  v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	  end

	  -- Skilltab
	  local a, b, c, d = SkillFrame:GetRegions()
	  for _, v in pairs({a, b, c ,d }) do
		  v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	  end

	  for _, v in pairs({ReputationDetailCorner, ReputationDetailDivider }) do
		  v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	  end

		--Reputation Frame
	  local a, b, c, d = ReputationFrame:GetRegions()
	  for _, v in pairs({a, b, c, d }) do
		  v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	  end
	end
	if not IsAddOnLoaded("Blizzard_ArenaUI") then 
		LoadAddOn("Blizzard_ArenaUI")
	end 
end

local function ThemeBlizzAddons(addon)
	if not C["Skins"].LortiTextures then return end

	-- Wardrobe
	local _, a, b, c, d = DressUpFrame:GetRegions()
	for _, v in pairs({a, b, c, d, e}) do
       	v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
    end
		
	if CraftFrame ~= nil then
		local vectors = {CraftFrame:GetRegions()}
		for i = 1, 6 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end
	end
	
	if TradeFrame ~= nil then
		local vectors = {TradeFrame:GetRegions()}
		for i = 2, 1 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end
		
		for _, v in pairs({
			TradeFrameBg,
			TradeFrameBottomBorder,
			TradeFrameButtonBottomBorder,
			TradeFrameLeftBorder,
			TradeFrameRightBorder,
			TradeFrameTitleBg,
			TradeFrameTopBorder,
			TradeFrameTopRightCorner,
			TradeFrameBtnCornerLeft,
			TradeFrameBtnCornerRight,
			TradeFramePortraitFrame,
			TradeRecipientLeftBorder,
			TradeRecipientBG,
			TradeRecipientPortraitFrame,
			TradeRecipientBotLeftCorner,
		}) do
			v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end
	end

	-- ItemSocketingFrame
	if ItemSocketingFrame ~= nil then
		local vectors = {ItemSocketingFrame:GetRegions()}
		for i = 2, 2 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end
	end
	
-- Macro's
    if addon == "Blizzard_MacroUI" then
        local a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r = MacroFrame:GetRegions()
        for _, v in pairs({a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r})do
            v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
        end
        
        for _, v in pairs({
            MacroFrameTab1Left,
            MacroFrameTab1Right,
            MacroFrameTab1Middle,
            MacroFrameTab1LeftDisabled,
            MacroFrameTab1MiddleDisabled,
            MacroFrameTab1RightDisabled,
            MacroFrameTab2Left,
            MacroFrameTab2Right,
            MacroFrameTab2Middle,
            MacroFrameTab2LeftDisabled,
            MacroFrameTab2MiddleDisabled,
            MacroFrameTab2RightDisabled,
        }) do
            v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
        end

    end
	
-- GlyphFrame
	if addon == "Blizzard_GlyphUI" then
		local vectors = {GlyphFrame:GetRegions()}
		for i = 1, 1 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end

		for _, v in pairs({
			GlyphFrameGlyph1Background,
			GlyphFrameGlyph2Background,
			GlyphFrameGlyph3Background,
			GlyphFrameGlyph4Background,
			GlyphFrameGlyph5Background,
			GlyphFrameGlyph1Ring,
			GlyphFrameGlyph2Ring,
			GlyphFrameGlyph3Ring,
			GlyphFrameGlyph4Ring,
			GlyphFrameGlyph5Ring,
			GlyphFrameGlyph1Setting,
			GlyphFrameGlyph2Setting,
			GlyphFrameGlyph3Setting,
			GlyphFrameGlyph4Setting,
			GlyphFrameGlyph5Setting,
		}) do
			v:SetVertexColor(1,1,1)
		end
	end

	-- CalendarFrame
	if addon == "Blizzard_Calendar" then
		local vectors = {CalendarFrame:GetRegions()}
		for i = 1, 13 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end
	end

	if addon == "Blizzard_BindingUI" then
		-- KeyBindingFrame
		local vectors = {KeyBindingFrame:GetRegions()}
		for i = 1, 1 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end

		local vectors = {KeyBindingFrame.header:GetRegions()}

		for i = 1, 6 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end

		for _, v in pairs({
			KeyBindingFrame.BottomEdge,
			KeyBindingFrame.TopEdge,
			KeyBindingFrame.LeftEdge,
			KeyBindingFrame.RightEdge,
			KeyBindingFrame.BottomLeftCorner,
			KeyBindingFrame.TopLeftCorner,
			KeyBindingFrame.BottomRightCorner,
			KeyBindingFrame.TopRightCorner,
			KeyBindingFrameBottomBorder,
			KeyBindingFrameTopBorder,
			KeyBindingFrameRightBorder,
			KeyBindingFrameLeftBorder,
			KeyBindingFrameBottomLeftCorner,
			KeyBindingFrameBottomRightCorner,
			KeyBindingFrameTopLeftCorner,
			KeyBindingFrameTopRightCorner,
		}) do
			v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end
	end

		if addon == "Blizzard_TimeManager" then
			for _, v in pairs({StopwatchFrame:GetRegions()})do
				v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end

			local a, b, c = StopwatchTabFrame:GetRegions()
			for _, v in pairs({a, b, c})do
				v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end

			local a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r =  TimeManagerFrame:GetRegions()
			for _, v in pairs({a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r})do
				v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end

			for _, v in pairs({TimeManagerFrameInset:GetRegions()})do
				v:SetVertexColor(.65, .65, .65)
			end

			TimeManagerClockButton:GetRegions():SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end

		--RECOLOR Achievement

		if addon == "Blizzard_AchievementUI" then
			local a, b, c, d, e, f, g, h, i, j, k, l, m, n, o = AchievementFrame:GetRegions()
			for _, v in pairs({a, b, c, d, e, f, g, h, i, j, k, l, m, n, o}) do
				v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end
		end

		-- Barber
		if addon == "Blizzard_BarbershopUI" then
			local a, b, c = BarberShopFrame:GetRegions()
			for _, v in pairs({a, b, c}) do
				v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end
		end

		--RECOLOR TALENTS

		if addon == "Blizzard_TalentUI" then
			local vectors = {PlayerTalentFrame:GetRegions()}
			for i = 2, 6 do
				vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end

			local vectors = {PlayerTalentFramePointsBar:GetRegions()}
			for i = 1, 4 do
				vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end
			
			PlayerSpecTab1Background:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			PlayerSpecTab2Background:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		
			for _, v in pairs({
				PlayerTalentFrameScrollFrameBackgroundTop,
				PlayerTalentFrameScrollFrameBackgroundBottom,
				PlayerTalentFrameTab1LeftDisabled,
				PlayerTalentFrameTab1MiddleDisabled,
				PlayerTalentFrameTab1RightDisabled,
				PlayerTalentFrameTab2LeftDisabled,
				PlayerTalentFrameTab2MiddleDisabled,
				PlayerTalentFrameTab2RightDisabled,
				PlayerTalentFrameTab3LeftDisabled,
				PlayerTalentFrameTab3MiddleDisabled,
				PlayerTalentFrameTab3RightDisabled,
				PlayerTalentFrameTab4LeftDisabled,
				PlayerTalentFrameTab4MiddleDisabled,
				PlayerTalentFrameTab4RightDisabled,
			}) do
				v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end
		end

		--RECOLOR TRADESKILL
		if addon == "Blizzard_TradeSkillUI" then
			local vectors = {TradeSkillFrame:GetRegions()}
			for i = 2, 6 do
				vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end
		end

		-- ClassTrainerFrame
		if addon == "Blizzard_TrainerUI" then
			local _, a, b, c, d, _, e, f, g, h = ClassTrainerFrame:GetRegions()

			for _, v in pairs({ a, b, c, d, e, f, g, h})do
				v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end
		end

		-- InspectFrame/InspectTalentFrame/InspectPVPFrame

		if addon == "Blizzard_InspectUI" then
			for _, v in pairs({
				InspectTalentFramePointsBarBorderLeft,
				InspectTalentFramePointsBarBorderMiddle,
				InspectTalentFramePointsBarBorderRight,
				InspectTalentFramePointsBarBackground,
				InspectFrameTab1LeftDisabled,
				InspectFrameTab1MiddleDisabled,
				InspectFrameTab1RightDisabled,
				InspectFrameTab2LeftDisabled,
				InspectFrameTab2MiddleDisabled,
				InspectFrameTab2RightDisabled,
				InspectFrameTab3LeftDisabled,
				InspectFrameTab3MiddleDisabled,
				InspectFrameTab3RightDisabled,
			}) do
				v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end
			local vectors = {InspectPaperDollFrame:GetRegions()}
			for i = 1, 4 do
				vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end

			local vectors = {InspectPVPFrame:GetRegions()}
			for i = 1, 5 do
				vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end

			local vectors = {InspectTalentFrame:GetRegions()}
			for i = 1, 5 do
				vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end

			local vectors = {InspectTalentFrameScrollFrame:GetRegions()}
			for i = 1, 2 do
				vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
			end
		end

	-- LFGListingFrame
	if addon == "Blizzard_LookingForGroupUI" then
		for _, v in pairs({
			LFGParentFrameTab1LeftDisabled,
			LFGParentFrameTab1MiddleDisabled,
			LFGParentFrameTab1RightDisabled,
			LFGParentFrameTab1LeftDisabled,
			LFGParentFrameTab1MiddleDisabled,
			LFGParentFrameTab1RightDisabled,
			LFGParentFrameTab2LeftDisabled,
			LFGParentFrameTab2MiddleDisabled,
			LFGParentFrameTab2RightDisabled,
		}) do
			v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end

		local vectors = {LFGListingFrame:GetRegions()}
		for i = 1, 3 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end

		local vectors = {LFGBrowseFrame:GetRegions()}
		for i = 1, 4 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end
	end

	-- AuctionFrame
	if addon == "Blizzard_AuctionUI" then
		local vectors = {AuctionFrame:GetRegions()}
		for i = 2, 7 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end
	end
end

local function DarkerFrames()
if not C["Skins"].LortiTextures then return end
	-- HONOR
	local vectors = {PVPFrame:GetRegions()}
	for i = 3, 7 do
		vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end
	--Character Tabs

	local a, b, c, d, e, f = CharacterFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, b, c, d, e, f  = CharacterFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, b, c, d, e, f  = CharacterFrameTab3:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, b, c, d, e, f = CharacterFrameTab4:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, b, c, d, e, f, _, h = CharacterFrameTab5:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	-- HelpFrame
	local vectors = {HelpFrame:GetRegions()}
	for i = 1, 1 do
		vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end
	for _, v in pairs({
		HelpFrameLeftBorder,
		HelpFrameRightBorder,
		HelpFrameBottomBorder,
		HelpFrameTopBorder,
		HelpFrameBotLeftCorner,
		HelpFrameBotRightCorner,
		HelpFrameTopRightCorner,
		HelpFrameTopLeftCorner,
		HelpFrameBtnCornerLeft,
		HelpFrameBtnCornerRight,
		HelpFrameButtonBottomBorder,
	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	-- VideoOptionsFrame
	local vectors = {VideoOptionsFrame:GetRegions()}
	for i = 1, 1 do
		vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end
	for _, v in pairs({
		VideoOptionsFrame.BottomEdge,
		VideoOptionsFrame.TopEdge,
		VideoOptionsFrame.LeftEdge,
		VideoOptionsFrame.RightEdge,
		VideoOptionsFrame.BottomLeftCorner,
		VideoOptionsFrame.TopLeftCorner,
		VideoOptionsFrame.BottomRightCorner,
		VideoOptionsFrame.TopRightCorner,
	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	-- InterfaceOptionsFrame
	local vectors = {InterfaceOptionsFrame:GetRegions()}
	for i = 1, 1 do
		vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end
	for _, v in pairs({
		InterfaceOptionsFrame.BottomEdge,
		InterfaceOptionsFrame.TopEdge,
		InterfaceOptionsFrame.LeftEdge,
		InterfaceOptionsFrame.RightEdge,
		InterfaceOptionsFrame.BottomLeftCorner,
		InterfaceOptionsFrame.TopLeftCorner,
		InterfaceOptionsFrame.BottomRightCorner,
		InterfaceOptionsFrame.TopRightCorner,
	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	-- AddonList
	local vectors = {AddonList:GetRegions()}
	for i = 1, 1 do
		vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end
	for _	, v in pairs({
		AddonListBotLeftCorner,
		AddonListBotRightCorner,
		AddonListTopLeftCorner,
		AddonListTopRightCorner,
		AddonListBottomBorder,
		AddonListTopBorder,
		AddonListRightBorder,
		AddonListLeftBorder,
		AddonListBottomLeftCorner,
		AddonListBottomRightCorner,
		AddonListTopLeftCorner,
		AddonListTopRightCorner,
		AddonListBtnCornerLeft,
		AddonListBtnCornerRight,
		AddonListButtonBottomBorder,
		AddonListInsetInsetBottomBorder,
	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	-- ACP											
	if (IsAddOnLoaded("ACP")) then
		local vectors = {ACP_AddonList:GetRegions()}
		for i = 1, 7 do
			vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end
	end

	-- Social Frame
	local a, b, c, d, e, f, g, _, i, j, k, l, n, o, p, q, r, _, _ = FriendsFrame:GetRegions()
	for _, v in pairs({
		a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r,
		FriendsFrameInset:GetRegions(),
		--WhoFrameListInset:GetRegions()
	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	FriendsFrameInsetInsetBottomBorder:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	WhoFrameEditBoxInset:GetRegions():SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	WhoFrameDropDownLeft:SetVertexColor(0.5,0.5,0.5)
	WhoFrameDropDownMiddle:SetVertexColor(0.5,0.5,0.5)
	WhoFrameDropDownRight:SetVertexColor(0.5,0.5,0.5)

	local a, b, c, d, e, f, g, h, i = WhoFrameEditBoxInset:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end
	
	local a, b, c, d, e, f, g, h, i = WhoFrameListInset:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end
	local a, b, c, d, e, f = FriendsFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, b, c, d, e, f = FriendsFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, b, c, d, e, f  = FriendsFrameTab3:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, b, c, d, e, f  = FriendsFrameTab4:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end
	
	-- MERCHANT
	local _, a, b, c, d, _, _, _, e, f, g, h, j, k = MerchantFrame:GetRegions()
	for _, v in pairs({a, b, c ,d, e, f, g, h, j, k
	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	--MerchantPortrait
	for _, v in pairs({
		MerchantFramePortrait
	}) do
		v:SetVertexColor(1, 1, 1)
	end

	-- Currency Frame
	local vectors = {TokenFrame:GetRegions()}
	for i = 1, 4 do
		vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end
end

local function ThirdFrames()
	if not C["Skins"].LortiTextures then return end
	--PETPAPERDOLL/PET Frame
	local vectors = {PetPaperDollFrame:GetRegions()}
	for i = 2, 5 do
		vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, _, c = PetPaperDollFrameCompanionFrame:GetRegions()
	for _, v in pairs({a, c}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	-- SPELLBOOK
	local _, a, b, c, d = SpellBookFrame:GetRegions()
	for _, v in pairs({a, b, c, d}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	for i = 1, MAX_SKILLLINE_TABS  do
		local vertex = _G["SpellBookSkillLineTab"..i]:GetRegions()
		vertex:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	if not SpellBookFrame.Material then
		SpellBookFrame.Material = SpellBookFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
		SpellBookFrame.Material:SetTexture("Interface\\AddOns\\KKthnxUI\\Media\\Textures\\Quest\\QuestBG")
		SpellBookFrame.Material:SetWidth(547)
		SpellBookFrame.Material:SetHeight(541)
		SpellBookFrame.Material:SetPoint('TOPLEFT', SpellBookFrame, 22, -74)
		SpellBookFrame.Material:SetVertexColor(.7, .7, .7)
	end

	-- Quest Log Frame

	local vectors = {QuestLogFrame:GetRegions()}
    for i = 2, 3 do
         vectors[i]:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
    end

	if IsAddOnLoaded("Leatrix_Plus") and LeaPlusDB["EnhanceQuestLog"] == "On" and not QuestLogFrame.Material then
		QuestLogFrame.Material = QuestLogFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
		QuestLogFrame.Material:SetTexture("Interface\\AddOns\\KKthnxUI\\Media\\Textures\\Quest\\QuestBG")
		QuestLogFrame.Material:SetWidth(531)
		QuestLogFrame.Material:SetHeight(625)
		QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, -10, 0)
		QuestLogFrame.Material:SetVertexColor(.8, .8, .8)
	else
		QuestLogFrame.Material = QuestLogFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
		QuestLogFrame.Material:SetTexture("Interface\\AddOns\\KKthnxUI\\Media\\Textures\\Quest\\QuestBG")
		QuestLogFrame.Material:SetWidth(531)
		QuestLogFrame.Material:SetHeight(511)
		QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, -10, 0)
		QuestLogFrame.Material:SetVertexColor(.8, .8, .8)
	end

	-- Gossip Frame
	local a, b, c, d, e, f, g, h, i = GossipFrameGreetingPanel:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	if not GossipFrameGreetingPanel.Material then 
		GossipFrameGreetingPanel.Material = GossipFrameGreetingPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
		GossipFrameGreetingPanel.Material:SetTexture("Interface\\AddOns\\KKthnxUI\\Media\\Textures\\Quest\\QuestBG")
		GossipFrameGreetingPanel.Material:SetWidth(514)
		GossipFrameGreetingPanel.Material:SetHeight(522)
		GossipFrameGreetingPanel.Material:SetPoint('TOPLEFT', GossipFrameGreetingPanel, 22, -74)
		GossipFrameGreetingPanel.Material:SetVertexColor(0.7,0.7,0.7)
	end

	-- Quest Frame Reward panel
	local a, b, c, d, e, f, g, h, i = QuestFrameRewardPanel:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	if not QuestFrameRewardPanel.Material then
		QuestFrameRewardPanel.Material = QuestFrameRewardPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
		QuestFrameRewardPanel.Material:SetTexture("Interface\\AddOns\\KKthnxUI\\Media\\Textures\\Quest\\QuestBG")
		QuestFrameRewardPanel.Material:SetWidth(514)
		QuestFrameRewardPanel.Material:SetHeight(522)
		QuestFrameRewardPanel.Material:SetPoint('TOPLEFT', QuestFrameRewardPanel, 22, -74)
		QuestFrameRewardPanel.Material:SetVertexColor(0.7,0.7,0.7)
	end
	
	--Mailbox

	for _, v in pairs({
		MailFrameBg,
		MailFrameBotLeftCorner,
		MailFrameBotRightCorner,
		MailFrameBottomBorder,
		MailFrameBtnCornerLeft,
		MailFrameBtnCornerRight,
		MailFrameButtonBottomBorder,
		MailFrameLeftBorder,
		MailFramePortraitFrame,
		MailFrameRightBorder,
		MailFrameTitleBg,
		MailFrameTopBorder,
		MailFrameTopLeftCorner,
		MailFrameTopRightCorner,
		MailFrameInsetInsetBottomBorder,
		MailFrameInsetInsetBotLeftCorner,
		MailFrameInsetInsetBotRightCorner,
	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, b, c, d, e, f  = MailFrameTab1:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, b, c, d, e, f  = MailFrameTab2:GetRegions()
	for _, v in pairs({a, b, c, d, e, f}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	--THINGS THAT SHOULD REMAIN THE REGULAR COLOR
	for _,v in pairs({
		BankPortraitTexture,
		BankFrameTitleText,
		MerchantFramePortrait,
		WhoFrameTotals
	}) do
		v:SetVertexColor(1, 1, 1)
	end

	for _,v in pairs({
		SlidingActionBarTexture0,
		SlidingActionBarTexture1,
		MainMenuBarTexture0,
		MainMenuBarTexture1,
		MainMenuBarTexture2,
		MainMenuBarTexture3,
		MainMenuMaxLevelBar0,
		MainMenuMaxLevelBar1,
		MainMenuMaxLevelBar2,
		MainMenuMaxLevelBar3,
		MainMenuXPBarTexture0,
		MainMenuXPBarTexture1,
		MainMenuXPBarTexture2,
		MainMenuXPBarTexture3,
		MainMenuXPBarTexture4,
		ReputationWatchBar.StatusBar.WatchBarTexture0,
		ReputationWatchBar.StatusBar.WatchBarTexture1,
		ReputationWatchBar.StatusBar.WatchBarTexture2,
		ReputationWatchBar.StatusBar.WatchBarTexture3,
		ReputationWatchBar.StatusBar.XPBarTexture0,
		ReputationWatchBar.StatusBar.XPBarTexture1,
		ReputationWatchBar.StatusBar.XPBarTexture2,
		ReputationWatchBar.StatusBar.XPBarTexture3,

	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	CompactRaidFrameManagerToggleButton:SetNormalTexture("Interface\\AddOns\\KKthnxUI\\Media\\Textures\\raid\\RaidPanel-Toggle")

	local a, b, c, d, e, f, g, h, i = QuestFrameDetailPanel:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	if not QuestFrameDetailPanel.Material then
		QuestFrameDetailPanel.Material = QuestFrameDetailPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
		QuestFrameDetailPanel.Material:SetTexture("Interface\\AddOns\\KKthnxUI\\Media\\Textures\\Quest\\QuestBG")
		QuestFrameDetailPanel.Material:SetWidth(514)
		QuestFrameDetailPanel.Material:SetHeight(522)
		QuestFrameDetailPanel.Material:SetPoint('TOPLEFT', QuestFrameDetailPanel, 22, -74)
		QuestFrameDetailPanel.Material:SetVertexColor(0.7,0.7,0.7)
	end

	local a, b, c, d, e, f, g, h, i = QuestFrameProgressPanel:GetRegions()
	for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	QuestFrameProgressPanel.Material = QuestFrameProgressPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
	QuestFrameProgressPanel.Material:SetTexture("Interface\\AddOns\\KKthnxUI\\Media\\Textures\\Quest\\QuestBG")
	QuestFrameProgressPanel.Material:SetWidth(514)
	QuestFrameProgressPanel.Material:SetHeight(522)
	QuestFrameProgressPanel.Material:SetPoint('TOPLEFT', QuestFrameProgressPanel, 22, -74)
	QuestFrameProgressPanel.Material:SetVertexColor(0.7,0.7,0.7)
																				  
	-- LFG/LFM Frame
	if(LFGFrame ~= nil) then
		LFGParentFrameBackground:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])

		local a, b, c, d, e, f  = LFGParentFrameTab1:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end

		local a, b, c, d, e, f  = LFGParentFrameTab2:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
		end
	end

	-- Dropdown Lists
	for _, v in pairs({
		DropDownList1MenuBackdrop.BottomEdge,
		DropDownList1MenuBackdrop.BottomLeftCorner,
		DropDownList1MenuBackdrop.BottomRightCorner,
		DropDownList1MenuBackdrop.LeftEdge,
		DropDownList1MenuBackdrop.RightEdge,
		DropDownList1MenuBackdrop.TopEdge,
		DropDownList1MenuBackdrop.TopLeftCorner,
		DropDownList1MenuBackdrop.TopRightCorner,
		DropDownList2MenuBackdrop.BottomEdge,
		DropDownList2MenuBackdrop.BottomLeftCorner,
		DropDownList2MenuBackdrop.BottomRightCorner,
		DropDownList2MenuBackdrop.LeftEdge,
		DropDownList2MenuBackdrop.RightEdge,
		DropDownList2MenuBackdrop.TopEdge,
		DropDownList2MenuBackdrop.TopLeftCorner,
		DropDownList2MenuBackdrop.TopRightCorner,
	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	-- Color Picker Frame

	for _, v in pairs({
		ColorPickerFrame.BottomEdge,
		ColorPickerFrame.BottomLeftCorner,
		ColorPickerFrame.BottomRightCorner,
		ColorPickerFrame.LeftEdge,
		ColorPickerFrame.RightEdge,
		ColorPickerFrame.TopEdge,
		ColorPickerFrame.TopLeftCorner,
		ColorPickerFrame.TopRightCorner,
		ColorPickerFrameHeader,
	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	-- Keyring

	local a, b, c, d = KeyRingButton:GetRegions()
		for _, v in pairs({b}) do
			v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	-- Action Bar Arrows

	local a, b, c, d = ActionBarUpButton:GetRegions()
		for _, v in pairs({a}) do
			v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local a, b, c, d = ActionBarDownButton:GetRegions()
		for _, v in pairs({a}) do
			v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	MainMenuBarPageNumber:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])

	for _, v in pairs({
		PlayerTitleDropDownLeft,
		PlayerTitleDropDownMiddle,
		PlayerTitleDropDownRight,
		PlayerTitleDropDownButtonNormalTexture,
	}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end

	local _, b, c, d, e = BattlefieldFrame:GetRegions()
	for _, v in pairs({b, c, d, e}) do
		v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
	end


	-- Scoreboard
		local a, b, c, d, e, f, _, _, _, _ ,_, l = WorldStateScoreFrame:GetRegions()
    	for _, v in pairs({a, b, c, d, e, f, l}) do
			v:SetVertexColor(C["General"].TexturesColor[1], C["General"].TexturesColor[2], C["General"].TexturesColor[3])
    	end	
end

local Size = CreateFrame("Frame")
Size:RegisterEvent("ADDON_LOADED")
Size:SetScript("OnEvent", function()
	ExythUIColor()
	ThirdFrames()
	DarkerFrames()
end)

-- This will never unregister, because no sane person loads all the addons during the session.
local BlizzOfc = CreateFrame("Frame")
BlizzOfc:RegisterEvent("ADDON_LOADED")
BlizzOfc:SetScript("OnEvent", function(self, event, addon)
	if event then
		ThemeBlizzAddons(addon)
	end
end)