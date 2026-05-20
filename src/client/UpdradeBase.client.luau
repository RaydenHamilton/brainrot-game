local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local Notifcation = require(StarterPlayer.StarterPlayerScripts.Client.GuiScripts.Notifcation)

local player = Players.LocalPlayer

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

local sign = plot:FindFirstChild("BaseUpgrade")
local button: GuiButton = sign:FindFirstChild("Upgrade", true)

button.Activated:Connect(function()
	local data = ReplicatedStorage.Remotes.UpgradeBase:InvokeServer(sign)
	Notifcation.new(data.message)
end)
