local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cost = require(ReplicatedStorage.Shared.Cost)
local SetupPlayer = require(script.Parent.SetupPlayer)
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)
local perchesHandler = {}

local function purches(
	player: Player,
	ProductName: string,
	amount: number,
	getCost: boolean
): { cost: number?, amount: number?, message: string?, success: boolean? }
	local playerProductAmount = PlayerDataServerService.get(player, ProductName)

	local cost = Cost.GetItemTotalCost(ProductName, playerProductAmount + 1, amount)

	if getCost then
		return { cost = math.round(cost), amount = playerProductAmount }
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

	cost = Cost.GetItemTotalCost(ProductName, playerProductAmount + 11, amount)

	return { success = true, cost = cost, amount = playerProductAmount + amount }
end

function perchesHandler.init()
	ReplicatedStorage.Remotes.Purches.OnServerInvoke = purches
end
return perchesHandler
