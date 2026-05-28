local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BrainrotData = require(ReplicatedStorage.Shared.BrainrotData)
local Petsystem = require(script.Parent.Petsystem)
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)
local Settings = require(ReplicatedStorage.Shared.Settings)
local randomPet = require(ReplicatedStorage.Shared.randomPet)
local fuseEvent = ReplicatedStorage.Remotes.FuseEvent

local function removeOldPet(player: Player, petData)
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:FindFirstChild("Humanoid") :: Humanoid
	humanoid:UnequipTools()
	for _, pet in player.Backpack:GetChildren() do
		if
			pet:GetAttribute("Name") == petData[1]
			and pet:GetAttribute("Level") == petData[2]
			and pet:GetAttribute("Mutation") == petData[3]
		then
			pet:Destroy()
			return
		end
	end
end

local function claim(player: Player)
	local fuseData = PlayerDataServerService.get(player, "FuseMachine")
	local startTime = fuseData.StartTime
	local rarity = fuseData.ClaimableRarity
	local timeToGet = Settings.FuseTime[rarity]
	if startTime + timeToGet - tick() < 0 then
		local petName = randomPet.randomBrainRot(rarity)
		local mutation = randomPet.randomMutation()
		Petsystem.givePet(player, petName, 0, mutation)
	end
end
local function findPet(inventory, petData)
	for i, v in ipairs(inventory) do
		if v[1] == petData[1] and v[2] == petData[2] and v[3] == petData[3] then
			return i
		end
	end

	return nil
end

local function place(player, slot, petData)
	local inventory = PlayerDataServerService.get(player, "Inventory")
	local index = findPet(inventory, petData)
	removeOldPet(player, inventory[index])
	inventory[index] = nil
	local fuseData = PlayerDataServerService.get(player, "FuseMachine")
	local oldPet = fuseData.Slots[slot]
	if oldPet then
		Petsystem.givePet(player, oldPet[1], oldPet[2], oldPet[3])
	end
	fuseData.Slots[slot] = petData

	PlayerDataServerService.set(player, "Inventory", inventory)
	PlayerDataServerService.set(player, "FuseMachine", fuseData)
end

local function nextRarity(rarity)
	local list = {
		"Common",
		"Rare",
		"Epic",
		"Legendary",
		"Mythic",
		"God",
		"Secret",
	}
	local index = table.find(list, rarity)
	return list[index + 1]
end

local function fuse(player)
	local fuseData = PlayerDataServerService.get(player, "FuseMachine")
	local lastslot = nil
	for index, slot in fuseData.Slot do
		if index == 1 then
			lastslot = slot
			if not slot then
				return
			end
		elseif lastslot[1] ~= slot[1] then
			return
		end
	end

	fuseData.Slots = {}
	fuseData.ClaimableRarity = nextRarity(BrainrotData[lastslot[1]].Rarity)
	fuseData.StartTime = tick()

	PlayerDataServerService.set(player, "FuseMachine", fuseData)
end

local function remove(player, slot)
	local fuseData = PlayerDataServerService.get(player, "FuseMachine")
	local slotdata = fuseData.Slots[slot]
	Petsystem.givePet(player, slotdata[1], slotdata[2], slotdata[3])
	fuseData.Slots[slot] = nil
	PlayerDataServerService.set(player, "FuseMachine", fuseData)
end

local function changeFuseData(player, buttonName: string, brainrotData)
	-- what we want to put in to the fuseSlot

	if buttonName == "Claim" then
		claim(player)
	elseif buttonName == "Fuse" then
		fuse(player)
	elseif buttonName == "Remove" then
		remove(player, brainrotData)
	else
		brainrotData = { brainrotData.name, brainrotData.level, brainrotData.mutation }
		local slot = string.sub(buttonName, #buttonName)
		place(player, slot, brainrotData)
	end
end

fuseEvent.OnServerEvent:Connect(changeFuseData)
