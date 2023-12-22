local K, C = unpack(KkthnxUI)
local Module = K:GetModule("Blizzard")

-- Sourced: NDui

local function SetupMirrorBars(bar)
	local statusbar = bar.StatusBar or _G[bar:GetName() .. "StatusBar"]
	if statusbar then
		statusbar:SetAllPoints()
	elseif bar.SetStatusBarTexture then
		bar:SetStatusBarTexture()
	end
	local text = _G[bar:GetName() .. "Text"]

	bar:SetSize(222, 22)
	bar:StripTextures(true)

	text:ClearAllPoints()
	text:SetFontObject(K.UIFont)
	text:SetFont(text:GetFont(), 12, nil)
	text:SetPoint("BOTTOM", bar, "TOP", 0, 4)

	bar.spark = bar:CreateTexture(nil, "OVERLAY")
	bar.spark:SetSize(64, bar:GetHeight())
	bar.spark:SetTexture(C["Media"].Textures.Spark128Texture)
	bar.spark:SetBlendMode("ADD")
	bar.spark:SetPoint("CENTER", statusbar:GetStatusBarTexture(), "RIGHT", 0, 0)

	bar:CreateBorder()
end

function Module:CreateMirrorBars()
	local previous
	for i = 1, 3 do
		local bar = _G["MirrorTimer" .. i]
		SetupMirrorBars(bar)

		if previous then
			bar:SetPoint("TOP", previous, "BOTTOM", 0, -6)
		end
		previous = bar
	end
end
