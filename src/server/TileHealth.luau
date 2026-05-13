local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Settings = require(ReplicatedStorage.Shared.Settings)
local health = {}

function health.init()
	for _, folder in Workspace.Tiles:GetChildren() do
		folder:SetAttribute("Health", Settings.Zones[folder.Name])
	end
end

return health
