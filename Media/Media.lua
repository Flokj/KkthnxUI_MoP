local K, C = unpack(KkthnxUI)

local mediaFolder = K.MediaFolder
C["Media"] = {
	["Sounds"] = {
		KillingBlow = mediaFolder .. "Sounds\\KillingBlow.ogg",
	},

	["Backdrops"] = {
		ColorBackdrop = { 0.045, 0.045, 0.045, 0.9 },
	},

	["Borders"] = {
		AzeriteUIBorder = mediaFolder .. "Border\\AzeriteUI\\Border.tga",
		AzeriteUITooltipBorder = mediaFolder .. "Border\\AzeriteUI\\Border_Tooltip.tga",
		ColorBorder = { 1, 1, 1 }, -- Doesn't feel like this fits here
		GlowBorder = mediaFolder .. "Border\\Border_Glow_Overlay.tga",
		KkthnxUIBorder = mediaFolder .. "Border\\KkthnxUI\\Border.tga",
		KkthnxUITooltipBorder = mediaFolder .. "Border\\KkthnxUI\\Border_Tooltip.tga",
	},

	["Textures"] = {
		ArrowTexture = mediaFolder .. "Textures\\Arrow.tga",
		BlankTexture = "Interface\\BUTTONS\\WHITE8X8",
		CopyChatTexture = mediaFolder .. "Chat\\Copy.tga",
		GlowTexture = mediaFolder .. "Textures\\GlowTex.tga",
		LogoSmallTexture = mediaFolder .. "Textures\\LogoSmall.tga",
		LogoTexture = mediaFolder .. "Textures\\Logo.tga",
		MouseoverTexture = mediaFolder .. "Textures\\Mouseover.tga",
		NewClassIconsTexture = mediaFolder .. "Unitframes\\NEW-ICONS-CLASSES.blp",
		Spark128Texture = mediaFolder .. "Textures\\Spark_128",
		Spark16Texture = mediaFolder .. "Textures\\Spark_16",
		TargetIndicatorTexture = mediaFolder .. "Nameplates\\TargetIndicatorArrow.blp",
	},

	["Fonts"] = {
		BlankFont = mediaFolder .. "Fonts\\Invisible.ttf",
	},

	["Statusbars"] = {
		AltzUI = mediaFolder .. "Statusbars\\AltzUI.tga",
		AsphyxiaUI = mediaFolder .. "Statusbars\\AsphyxiaUI.tga",
		AzeriteUI = mediaFolder .. "Statusbars\\AzeriteUI.tga",
		Clean = mediaFolder .. "Statusbars\\Clean.tga",
		Flat = mediaFolder .. "Statusbars\\Flat.tga",
		Glamour7 = mediaFolder .. "Statusbars\\Glamour7.tga",
		GoldpawUI = mediaFolder .. "Statusbars\\GoldpawUI.tga",
		KkthnxUI = mediaFolder .. "Statusbars\\Statusbar",
		KuiBright = mediaFolder .. "Statusbars\\KuiStatusbarBright.tga",
		Kui = mediaFolder .. "Statusbars\\KuiStatusbar.tga",
		Palooza = mediaFolder .. "Statusbars\\Palooza.tga",
		PinkGradient = mediaFolder .. "Statusbars\\PinkGradient.tga",
		Rain = mediaFolder .. "Statusbars\\Rain.tga",
		SkullFlowerUI = mediaFolder .. "Statusbars\\SkullFlowerUI.tga",
		Tukui = mediaFolder .. "Statusbars\\ElvTukUI.tga",
		WGlass = mediaFolder .. "Statusbars\\Wglass.tga",
		Water = mediaFolder .. "Statusbars\\Water.tga",
		ZorkUI = mediaFolder .. "Statusbars\\ZorkUI.tga",
	},
}

local statusbars = C["Media"].Statusbars
local defaultTexture = statusbars.KkthnxUI

function K.GetTexture(texture)
	return statusbars[texture] and statusbars[texture] or defaultTexture
end

-- Register media types
if K.SharedMedia then
	for mediaType, mediaTable in pairs(C["Media"]) do
		for name, path in pairs(mediaTable) do
			K.SharedMedia:Register(mediaType, name, path)
		end
	end
end
