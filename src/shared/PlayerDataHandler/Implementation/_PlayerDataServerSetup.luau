local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)

local playerDataServerSetup = {}
playerDataServerSetup.__index = playerDataServerSetup

local profileTemplate = {
	Cash = 0,
	Speed = 16,
	Power = 10,
	Carry = 1,
	Invontory = {}, -- {level, name, type}
	BaseLevel = 10,
	BaseData = {}, -- {Stand,floor,{level, name, type}}
	BaseSkins = {},
	BaseSkin = "Basic Base",
	Index = {}, -- {name , type},
	Rebirth = 0,
	Settings = { Sound = 100, SoundEffects = 100, Popups = false },
	Tools = {},
	EquppedTool = "base",
	Points = 0,
}

function playerDataServerSetup.init()
	PlayerDataServerService.init(profileTemplate)

	Players.PlayerAdded:Connect(PlayerDataServerService.playerAdded)
	Players.PlayerRemoving:Connect(PlayerDataServerService.playerRemoving)
end

return playerDataServerSetup
