local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Miscellaneous")

-- Sourced:on alThreatMeter(by Allez)
local pairs = pairs
local select = select
local wipe = wipe

function Module:CreateThreatbar()
	if not C["Misc"].ThreatEnable then return end

	local spacing = 5
	local bar, tList, barList = {}, {}, {}
	local targeted = false
	
	RAID_CLASS_COLORS["PET"] = {r = 0, g = 0.7, b = 0, colorStr = "ff00b200"}
	
	local ThreatAnchor = CreateFrame("Frame", "KKUI_ThreatMeter", UIParent)
	ThreatAnchor:SetSize(C["Misc"].ThreatWidth + 4, (C["Misc"].ThreatHeight * C["Misc"].ThreatBarRows) + (spacing * (C["Misc"].ThreatBarRows - 1)) + 4)
	K.Mover(ThreatAnchor, "ThreatAnchor", "ThreatAnchor", { "TOPLEFT", UIParent, "BOTTOMRIGHT", -565, 113 })

	local function AddUnit(unit)
		local threatpct, _, threatval = select(3, UnitDetailedThreatSituation(unit, "target"))
		if threatval and threatval < 0 then
			threatval = threatval + 410065408
		end
	
		threatval = threatval and math.floor(threatval / 100)
	
		local guid = UnitGUID(unit)
		if not tList[guid] then
			tinsert(barList, guid)
			tList[guid] = {
				name = UnitName(unit),
				class = UnitIsPlayer(unit) and select(2, UnitClass(unit)) or "PET",
			}
		end
		tList[guid].pct = threatpct or 0
		tList[guid].val = threatval or 0
	end
	
	local function CheckUnit(unit)
		if UnitExists(unit) and UnitIsVisible(unit) then
			AddUnit(unit)
			if UnitExists(unit.."pet") then
				AddUnit(unit.."pet")
			end
		end
	end
	
	local function AddBar()
		local bar = CreateFrame("Statusbar", nil, UIParent)
		bar:SetSize(C["Misc"].ThreatWidth, C["Misc"].ThreatHeight)
		bar:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
		bar:SetMinMaxValues(0, 100)
		bar:CreateBorder()
	
		bar.bg = bar:CreateTexture(nil, "BACKGROUND")
		bar.bg:SetAllPoints(bar)
		bar.bg:SetTexture(K.GetTexture(C["General"].Texture))
	
		bar.left = K.CreateFontString(bar, 12, "", "", false, "LEFT", 3, 0)
		bar.left:SetPoint("LEFT", 4, 0)
		bar.left:SetJustifyH("LEFT")
	
		bar.right = K.CreateFontString(bar, 12, "", "", false, "RIGHT", -3, 0)
		bar.right:SetPoint("RIGHT", -1, 0)
		bar.right:SetJustifyH("RIGHT")
	
		bar:Hide()
		return bar
	end
	
	local function SortMethod(a, b)
		return tList[b].pct < tList[a].pct
	end
	
	local function UpdateBars()
		for _, v in pairs(bar) do
			v:Hide()
		end
		table.sort(barList, SortMethod)
		for i = 1, #barList do
			local cur = tList[barList[i]]
			local max = tList[barList[1]]
			if i > C["Misc"].ThreatBarRows or not cur or cur.pct == 0 then break end
			if not bar[i] then
				bar[i] = AddBar()
				if i == 1 then
					bar[i]:SetPoint("TOP", ThreatAnchor, "TOP", 0, -2)
				else
					bar[i]:SetPoint("TOPLEFT", bar[i-1], "BOTTOMLEFT", 0, -spacing)
				end
			end
			bar[i]:SetValue(100 * cur.pct / max.pct)
			local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[cur.class]
			bar[i]:SetStatusBarColor(color.r, color.g, color.b)
			bar[i].bg:SetVertexColor(color.r, color.g, color.b, 0.2)
			bar[i].left:SetText(cur.name)
			bar[i].right:SetText(string.format("%s [%d%%]", K.ShortValue(cur.val), cur.pct))
			bar[i]:Show()
		end
	end
	
	local function UpdateThreat()
		if targeted then
			if GetNumGroupMembers() > 0 then
				local unit = IsInRaid() and "raid" or "party"
				for i = 1, GetNumGroupMembers(), 1 do
					CheckUnit(unit..i)
				end
			end
			CheckUnit("targettarget")
			CheckUnit("player")
		end
		UpdateBars()
	end
	
	local function OnEvent(_, event)
		if event == "PLAYER_TARGET_CHANGED" or event == "UNIT_THREAT_LIST_UPDATE" then
			if C["Misc"].ThreatHideSolo == true and GetNumGroupMembers() == 0 then
				targeted = false
			else
				if UnitExists("target") and not UnitIsDead("target") and not UnitIsPlayer("target") and UnitCanAttack("player", "target") then
					targeted = true
				else
					targeted = false
				end
			end
		end
		if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_REGEN_ENABLED" then
			wipe(tList)
			wipe(barList)
		end
		UpdateThreat()
	end
	
	local addon = CreateFrame("Frame")
	addon:SetScript("OnEvent", OnEvent)
	addon:RegisterEvent("PLAYER_TARGET_CHANGED")
	addon:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
	addon:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	SlashCmdList["KKUI_THREAT"] = function()
		for i = 1, C["Misc"].ThreatBarRows do
			tList[i] = {
				name = UnitName("player"),
				class = select(2, UnitClass("player")),
				pct = i / C["Misc"].ThreatBarRows * 100,
				val = i * 10000,
			}
			tinsert(barList, i)
		end
		UpdateBars()
		wipe(tList)
		wipe(barList)
	end
	SLASH_KKUI_THREAT1 = "/kkthreat"
	SLASH_KKUI_THREAT2 = "/kkth"
	SLASH_KKUI_THREAT3 = "/threat"
	SLASH_KKUI_THREAT4 = "/еркуфе"
end