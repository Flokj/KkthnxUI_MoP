local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Skins")

local CreateFrame = _G.CreateFrame
local hooksecurefunc = _G.hooksecurefunc

function Module:ReskinSkada()
	if not C["Skins"].Skada then return	end
	if not C_AddOns.IsAddOnLoaded("Skada") then return end

	local pairs, ipairs, tinsert = pairs, ipairs, table.insert
	local Skada = Skada
	if not Skada then return end

	local barSpacing = 1
	local barmod = Skada.displays["bar"]
	local function StripOptions(options)
		if options.baroptions then
			options.baroptions.args.barspacing = nil
			options.baroptions.args.barfont = nil
		end
		if options.titleoptions then
			options.titleoptions.args.texture = nil
			options.titleoptions.args.bordertexture = nil
			options.titleoptions.args.thickness = nil
			options.titleoptions.args.margin = nil
			options.titleoptions.args.color = nil
			options.titleoptions.args.font = nil
		end
		--options.windowoptions = nil
	end

	barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
	barmod.AddDisplayOptions = function(self, win, options)
		self:AddDisplayOptions_(win, options)
		StripOptions(options)
	end

	for _, options in pairs(Skada.options.args.windows.args) do
		if options.type == "group" then
			StripOptions(options.args)
		end
	end

	barmod.ApplySettings_ = barmod.ApplySettings
	barmod.ApplySettings = function(self, win)
		barmod.ApplySettings_(self, win)
		local window = win.bargroup
		if win.db.enabletitle then
			window.button:SetBackdrop(nil)
		end
		window:SetSpacing(barSpacing)
		window:SetFrameLevel(5)
		window.SetFrameLevel = K.Noop
		window:SetBackdrop(nil)
		window.borderFrame:StripTextures()

		if not window.bg then
			window.bg = CreateFrame("Frame", nil, window, "BackdropTemplate")
			window.bg:SetAllPoints(window)
			window.bg:SetFrameLevel(window:GetFrameLevel())
			window.bg:CreateBorder()
		end
		window.bg:ClearAllPoints()
		if win.db.enabletitle then
			window.bg:SetPoint("TOPLEFT", window.button, "TOPLEFT", -2, 2)
		else
			window.bg:SetPoint("TOPLEFT", window, "TOPLEFT", -2, 2)
		end
		window.bg:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 2, -2)

		window.button:SetBackdropColor(1, 1, 1, 0)
		window.button:SetFrameStrata("MEDIUM")
		window.button:SetFrameLevel(5)
		window:SetFrameStrata("MEDIUM")
	end

	local function EmbedWindow(window, width, barheight, height, ofsx, ofsy)
		window.db.barwidth = width
		window.db.barheight = barheight
		if window.db.enabletitle then
			height = height - barheight
		end
		window.db.background.height = height
		window.db.spark = false
		window.db.barslocked = true
		window.bargroup:ClearAllPoints()
		window.bargroup:SetPoint("TOPLEFT", UIParent, "TOPLEFT", ofsx, ofsy)
		barmod.ApplySettings(barmod, window)
	end

	local windows = {}
	local function EmbedSkada()
		if #windows == 1 then
			EmbedWindow(windows[1], 320, 18, 190)
		elseif #windows == 2 then
			EmbedWindow(windows[1], 320, 18, 190)
			EmbedWindow(windows[2], 260, 18, 150)
		end
	end

	for _, window in ipairs(Skada:GetWindows()) do
		window:UpdateDisplay()
	end

	Skada.CreateWindow_ = Skada.CreateWindow
	function Skada:CreateWindow(name, db)
		Skada:CreateWindow_(name, db)
		wipe(windows)
		for _, window in ipairs(Skada:GetWindows()) do
			tinsert(windows, window)
		end
		--EmbedSkada()
	end

	Skada.DeleteWindow_ = Skada.DeleteWindow
	function Skada:DeleteWindow(name)
		Skada:DeleteWindow_(name)
		wipe(windows)
		for _, window in ipairs(Skada:GetWindows()) do
			tinsert(windows, window)
		end
		EmbedSkada()
	end

	EmbedSkada()

	-- Change Skada Default Settings
	Skada.windowdefaults.bartexture = "Serenity"
	Skada.windowdefaults.classicons = false
	Skada.windowdefaults.title.fontsize = 12
	Skada.windowdefaults.title.color = {r=0,g=0,b=0,a=.3}
	Skada.windowdefaults.barfontsize = 12
	Skada.windowdefaults.barbgcolor = {r=0,g=0,b=0,a=0}

	-- Change Skada NumberFormat
	Skada.options.args.generaloptions.args.numberformat = nil

	function Skada:FormatNumber(number)
		if number then return K.ShortValue(number) end
	end
end