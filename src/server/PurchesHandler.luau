local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SetupPlayer = require(script.Parent.SetupPlayer)
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)
local Settings = require(ReplicatedStorage.Shared.Settings)
local perchesHandler = {}

local purchesType = {}

local function GetTotalCost(startCost, multiplier, startLevel, amount, offset)
	local total = 0

	local endLevel = startLevel + amount

	for level = startLevel, endLevel do
		total += startCost * (multiplier ^ (level - offset - 1))
	end

	return total
end

local function purches(
	player: Player,
	ProductName: string,
	amount: number,
	getCost: boolean
): { cost: number?, amount: number?, message: string?, success: boolean? }
	local playerProductAmount = PlayerDataServerService.get(player, ProductName)
	local cost = GetTotalCost(
		Settings[ProductName].Base,
		Settings[ProductName].Multiplier,
		playerProductAmount + 1,
		amount,
		Settings[ProductName].Offset
	)
	if getCost then
		return { cost = cost, amount = playerProductAmount }
	end

	local playerCash = PlayerDataServerService.get(player, "Cash")
	if cost <= playerCash then
		playerCash -= cost
		PlayerDataServerService.set(player, "Cash", playerCash)
		PlayerDataServerService.set(player, ProductName, playerProductAmount + amount)
		SetupPlayer[ProductName](player)
	else
		return { success = false, message = "Not Enough Money" }
	end

	cost = GetTotalCost(Settings[ProductName].Base, Settings[ProductName].Multiplier, playerProductAmount + 11, amount)

	return { success = true, cost = cost, amount = playerProductAmount + amount }
end

function perchesHandler.init()
	ReplicatedStorage.Remotes.Purches.OnServerInvoke = purches
end
return perchesHandler
