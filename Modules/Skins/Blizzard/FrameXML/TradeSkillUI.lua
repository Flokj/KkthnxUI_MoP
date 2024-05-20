local K, C = KkthnxUI[1], KkthnxUI[2]

C.themes["Blizzard_TradeSkillUI"] = function()
	if not C["Skins"].TradeSkills then return end
	if not C["Skins"].BlizzardFrames then return end
	
	TradeSkillListScrollFrameScrollBar:SkinScrollBar()
	TradeSkillDetailScrollFrameScrollBar:SkinScrollBar()
	TradeSkillFrameBottomLeftTexture:Hide()
	TradeSkillFrameBottomRightTexture:Hide()

	TradeSkillRankFrameBorder:StripTextures()
	TradeSkillRankFrame:StripTextures()
	TradeSkillRankFrame:SetStatusBarTexture(K.GetTexture(C["General"].Texture))
	TradeSkillRankFrame.SetStatusBarColor = K.Noop
	TradeSkillRankFrame:GetStatusBarTexture():SetGradient("VERTICAL", CreateColor(.1, .3, .9, 1), CreateColor(.2, .4, 1, 1))
	TradeSkillRankFrame:CreateBorder()
	TradeSkillRankFrame:SetWidth(220)

	TradeSkillExpandButtonFrame:DisableDrawLayer("BACKGROUND")

	TradeSkillDetailScrollChildFrame:StripTextures()

	hooksecurefunc("TradeSkillFrame_SetSelection", function(id)
		local skillType = select(2, GetTradeSkillInfo(id))
		if skillType == "header" then return end

		local tex = TradeSkillSkillIcon:GetNormalTexture()
		if tex then
			tex:SetTexCoord(.08, .92, .08, .92)
		end

		local skillLink = GetTradeSkillItemLink(id)
		if skillLink then
			local quality = select(3, GetItemInfo(skillLink))
			if quality and quality > 1 then
				local r, g, b = GetItemQualityColor(quality)
				TradeSkillSkillName:SetTextColor(r, g, b)
			else
				TradeSkillSkillName:SetTextColor(1, 1, 1)
			end
		end
	end)
end