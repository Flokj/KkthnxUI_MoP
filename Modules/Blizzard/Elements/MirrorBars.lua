local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Blizzard")

local function StyleMirrorBar(bar)
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

	local spark = bar:CreateTexture(nil, "OVERLAY")
	spark:SetSize(64, bar:GetHeight())
	spark:SetTexture(C["Media"].Textures.Spark128Texture)
	spark:SetBlendMode("ADD")
	spark:SetPoint("CENTER", statusbar:GetStatusBarTexture(), "RIGHT", 0, 0)

	bar:CreateBorder()
end

function Module:CreateMirrorBars()
	local previous
	for i = 1, 3 do
		local bar = _G["MirrorTimer" .. i]
		StyleMirrorBar(bar)

		if previous then
			bar:SetPoint("TOP", previous, "BOTTOM", 0, -6)
		end
		previous = bar
	end
end
