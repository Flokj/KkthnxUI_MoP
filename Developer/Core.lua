local K = KkthnxUI[1]

K.Devs = {
	["Неотжал-Пламегор"] = true,
}

local function isDeveloper()
	return K.Devs[K.Name .. "-" .. K.Realm]
end
K.isDeveloper = isDeveloper()

if not K.isDeveloper then
	return
end

function K.AddToDevTool(data, name)
	if DevTool then
		DevTool:AddData(data, name)
	end
end
