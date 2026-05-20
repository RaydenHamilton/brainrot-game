local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local Notifcation = require(StarterPlayer.StarterPlayerScripts.Client.GuiScripts.Notifcation)

local player = Players.LocalPlayer
local remoteFunction = ReplicatedStorage.Remotes.UpgradePet

local function findPlot()
	for _, child in ipairs(Workspace.Plots:GetChildren()) do
		if child:GetAttribute("Player") == player.UserId then
			return child
		end
	end
	return false
end

repeat
	task.wait(1)
until findPlot()

local plot = findPlot()

local stands = {}
local events = {}
local function showStandUI(stand, boolean: boolean)
	stand:FindFirstChild("SurfaceGui", true).Enabled = boolean
end

local floorFolderEvent = {}

local function getStands()
	stands = {}
	for _, event in events do
		event:Disconnect()
	end
	events = {}
	for _, floor in plot.Floors:GetChildren() do
		if not floorFolderEvent[floor.Name] then
			floorFolderEvent[floor.Name] = floor.Stands.ChildAdded:connect(getStands)
		end
		for _, standTemplate in floor.Stands:GetChildren() do
			table.insert(stands, standTemplate)
		end
	end
	for _, standTemplate: Model in stands do
		local event = standTemplate:FindFirstChild("Upgrade", true).Activated:Connect(function()
			local data = remoteFunction:InvokeServer(standTemplate)
			Notifcation.new(data.message)
		end)
		local show = standTemplate.ChildAdded:Connect(function()
			showStandUI(standTemplate, true)
		end)

		local hide = standTemplate.ChildRemoved:Connect(function()
			showStandUI(standTemplate, false)
		end)
		table.insert(events, event)
		table.insert(events, show)
		table.insert(events, hide)
	end
end
task.wait(1)
getStands()
