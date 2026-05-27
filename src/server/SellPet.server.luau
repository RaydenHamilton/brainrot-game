local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cost = require(ReplicatedStorage.Shared.Cost)
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)
local sellRemote = ReplicatedStorage.Remotes.SellItem

local function getpetStats(pet: Model)
	return {
		Name = pet:GetAttribute("Name"),
		Level = pet:GetAttribute("Level"),
		Mutation = pet:GetAttribute("Mutation"),
	}
end

local function UnequipTools(player: Player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid:UnequipTools()
	end
end

local function removeFromPlayer(player, petSaveData)
	local backpack = player.Backpack

	for _, pet in backpack:GetChildren() do
		local petData = getpetStats(pet)
		if
			petData.Name == petSaveData[1]
			and petData.Level == petSaveData[2]
			and petData.Mutation == petSaveData[3]
		then
			pet:Destroy()
			return
		end
	end
end

local function sell(player: Player, itemType)
	local items = PlayerDataServerService.get(player, "Inventory")

	UnequipTools(player)
	local total = 0
	if itemType == "All" then
		local backpack = player.Backpack
		for _, pet in backpack:GetChildren() do
			local petData = { Name = getpetStats(pet).Name, Level = 0, Mutation = "Normal" }
			local cost = Cost.getCashRate(petData) * 2
			total += cost
			pet:Destroy()
		end

		items = {}
	else
		for index, item in items do
			local name = item[1]
			if name == itemType then
				local petData = { Name = name, Level = 0, Mutation = "Normal" }
				local cost = Cost.getCashRate(petData) * 2
				total += cost
				removeFromPlayer(player, item)
				items[index] = nil
				break
			end
		end
	end

	PlayerDataServerService.add(player, "Cash", total)
	PlayerDataServerService.set(player, "Inventory", items)
end

sellRemote.OnServerEvent:Connect(sell)
