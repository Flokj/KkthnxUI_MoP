local K, C = KkthnxUI[1], KkthnxUI[2]

tinsert(C.defaultThemes, function()

	local WorldMapFrame = WorldMapFrame

	WorldMapFrame.BorderFrame:Hide()
	WorldMapZoneDropDown:Hide()
	WorldMapContinentDropDown:Hide()
	WorldMapZoneMinimapDropDown:Hide()
	WorldMapZoomOutButton:Hide()
	WorldMapMagnifyingGlassButton:SetAlpha(0)

	WorldMapFrame:SetHitRectInsets(1, 1, 1, 1)
	WorldMapFrame:SetClampedToScreen(false)

	MiniWorldMapTitle:SetAlpha(0)

end)
