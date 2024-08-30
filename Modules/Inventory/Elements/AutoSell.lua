local K, C = KkthnxUI[1], KkthnxUI[2]
local Module = K:GetModule("Bags")

local table_wipe = table.wipe

local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local UseContainerItem = C_Container and C_Container.UseContainerItem or UseContainerItem
local C_Timer_After = C_Timer.After
local C_TransmogCollection_GetItemInfo = C_TransmogCollection.GetItemInfo
local IsShiftKeyDown = IsShiftKeyDown

local autoSellStop = true -- Flag to stop the selling process
local sellCache = {} -- Table to store items that have already been processed
local errorText = ERR_VENDOR_DOESNT_BUY -- Error message for when the vendor doesn't buy certain items

local function startSelling()
	if autoSellStop then return end

	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			if autoSellStop then return end

			local info = GetContainerItemInfo(bag, slot)
			if info and not sellCache["b" .. bag .. "s" .. slot] and info.hyperlink and not info.hasNoValue and (info.quality == 0 or KkthnxUIDB.Variables[K.Realm][K.Name].CustomJunkList[info.itemID]) then
				sellCache["b" .. bag .. "s" .. slot] = true
				UseContainerItem(bag, slot)
				C_Timer_After(0.15, startSelling)
				return
			end
		end
	end
end

local function updateAutoSell(event, ...)
	if not C["Inventory"].AutoSell then return end

	local _, arg = ...
	if event == "MERCHANT_SHOW" then
		if IsShiftKeyDown() then return end

		autoSellStop = false
		table_wipe(sellCache)
		startSelling()
		K:RegisterEvent("UI_ERROR_MESSAGE", updateAutoSell)
	elseif (event == "UI_ERROR_MESSAGE" and arg == errorText) or event == "MERCHANT_CLOSED" then
		autoSellStop = true
		K:UnregisterEvent("UI_ERROR_MESSAGE")
	end
end

function Module:CreateAutoSell()
	K:RegisterEvent("MERCHANT_SHOW", updateAutoSell)
	K:RegisterEvent("MERCHANT_CLOSED", updateAutoSell)
end
