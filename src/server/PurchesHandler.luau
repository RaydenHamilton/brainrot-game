local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SetupPlayer = require(script.Parent.SetupPlayer)
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)
local Settings = require(ReplicatedStorage.Shared.Settings)
local perchesHandler = {}

local function GetTotalCost(ProductName, startLevel, amount)
	local startCost = Settings[ProductName].Base
	local multiplier = Settings[ProductName].Multiplier
	local offset = Settings[ProductName].Offset

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

	local cost = GetTotalCost(ProductName, playerProductAmount + 1, amount)

	if getCost then
		return { cost = cost, amount = playerProductAmount }
	end

	local playerCash = PlayerDataServerService.get(player, "Cash")
	if cost <= playerCash then
		playerCash -= cost
		PlayerDataServerService.set(player, "Cash", playerCash)
		local newAmount = playerProductAmount + amount
		PlayerDataServerService.set(player, ProductName, newAmount)
		SetupPlayer[ProductName](player)
	else
		return { success = false, message = "Not Enough Money" }
	end

	cost = GetTotalCost(ProductName, playerProductAmount + 11, amount)

	return { success = true, cost = cost, amount = playerProductAmount + amount }
end

function perchesHandler.init()
	ReplicatedStorage.Remotes.Purches.OnServerInvoke = purches
end
return perchesHandler
