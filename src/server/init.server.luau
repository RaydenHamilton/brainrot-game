local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Petsystem = require(script.Petsystem)
local PlotHandler = require(script.PlotHandler)
local PurchesHandler = require(script.PurchesHandler)
local _PlayerDataServerSetup = require(ReplicatedStorage.Shared.PlayerDataHandler.Implementation._PlayerDataServerSetup)
local SetupPlayer = require(script.SetupPlayer)
local TileHealth = require(script.TileHealth)

TileHealth.init()
_PlayerDataServerSetup.init()
SetupPlayer.init()

PurchesHandler.init()
PlotHandler.init()

-- testing
Players.PlayerAdded:Connect(function(player: Player)
	player.characterAdded:Connect(function()
		Petsystem.givePet(player, "67", 1, "Golden", "Common")
		Petsystem.givePet(player, "67", 1, "Golden", "Common")
	end)
end)
