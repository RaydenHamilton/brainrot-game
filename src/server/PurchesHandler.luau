local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)
local Settings = require(ReplicatedStorage.Shared.Settings)
local perchesHandler = {}

local purchesType = {}

local function GetTotalCost(startCost, multiplier, startLevel, amount)
	local total = 0

	local endLevel = startLevel + amount

	for level = startLevel, endLevel do
		total += startCost * (multiplier ^ (level - 1))
	end

	return total
end

local function purches(player: Player, ProductName: string, amount: number): boolean
	local playerProductAmount = PlayerDataServerService.get(player, ProductName)
	local cost =
		GetTotalCost(Settings[ProductName].Base, Settings[ProductName].Multiplier, playerProductAmount + 1, amount)

	local playerCash = PlayerDataServerService.get(player, "Cash")

	if cost <= playerCash then
		purchesType[ProductName](player, amount)
		playerCash -= cost
		PlayerDataServerService.set(player, "Cash", playerCash)
		PlayerDataServerService.set(player, ProductName, playerProductAmount + amount)
	else
		return false, "Not Enough Money"
	end

	cost = GetTotalCost(Settings[ProductName].Base, Settings[ProductName].Multiplier, playerProductAmount + 11, amount)

	return true, cost
end

purchesType.Speed = function(player, amount) end

purchesType.Power = function(player, amount) end

function perchesHandler.init()
	ReplicatedStorage.Remotes.Purches.OnServerInvoke = purches
end
return perchesHandler
