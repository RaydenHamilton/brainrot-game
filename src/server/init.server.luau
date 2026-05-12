local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _PlayerDataServerSetup = require(ReplicatedStorage.Shared.PlayerDataHandler.Implementation._PlayerDataServerSetup)
local SetupPlayer = require(script.SetupPlayer)
local TileHealth = require(script.TileHealth)

_PlayerDataServerSetup.init()

TileHealth.init()

SetupPlayer.init()
