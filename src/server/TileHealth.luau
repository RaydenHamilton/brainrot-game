local Workspace = game:GetService("Workspace")
local health = {}

local values = {}

values["Zone1"] = 1000
values["Zone2"] = 5000
values["Zone3"] = 10000
values["Zone4"] = 5000
values["Zone5"] = 5000
values["Zone6"] = 5000
values["Zone7"] = 5000
values["Zone8"] = 5000
values["Zone9"] = 5000
values["Zone10"] = 5000
values["Zone11"] = 5000
values["Zone12"] = 5000

values["Zone13"] = 5000
values["Zone14"] = 10000
values["Zone15"] = 5000
values["Zone16"] = 5000
values["Zone17"] = 5000
values["Zone18"] = 5000
values["Zone19"] = 5000
values["Zone20"] = 5000
values["Zone21"] = 5000

function health.init()
	for _, folder in Workspace.Tiles:GetChildren() do
		folder:SetAttribute("Health", values[folder.Name])
	end
end

return health
