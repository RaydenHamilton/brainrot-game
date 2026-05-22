local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
