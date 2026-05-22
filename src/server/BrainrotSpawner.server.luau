local FlagStandService = game:GetService("FlagStandService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local BrainrotData = require(ReplicatedStorage.Shared.BrainrotData)
local Petsystem = require(script.Parent.Petsystem)
local Settings = require(ReplicatedStorage.Shared.Settings)
local tiles = Workspace.Tiles

local function pickRandom(tbl)
	local totalWeight = 0

	-- Add all percentages together
	for _, weight in pairs(tbl) do
		totalWeight += weight
	end

	-- Pick random number
	local random = math.random() * totalWeight

	local current = 1

	for item, weight in pairs(tbl) do
		current += weight

		if random <= current then
			return item
		end
	end
	return nil
end

for name, rates in Settings.ZoneRarity do
	task.spawn(function()
		while task.wait(Settings.ZoneSpawnRates[name]) do
			local zoneTiles = tiles[name]:GetChildren()
			local spawnTile = math.random(1, #zoneTiles)
			local Position = zoneTiles[spawnTile].TilePart.Position

			local rarity = pickRandom(rates)
			if not rarity then
				continue
			end

			local brainrots = ServerStorage.Brainrots[rarity]:GetChildren()
			local index = math.random(1, #brainrots)
			local petName = brainrots[index].Name
			local mutation = pickRandom(BrainrotData.MutationChance)
			local brainrot = Petsystem.createBrainrot(petName, mutation, Workspace.EntitiesFolder)
			brainrot:ScaleTo(1)
			brainrot:PivotTo(
				CFrame.new(Position + Vector3.new(0, brainrot.PrimaryPart.Size.Y / 2, 0))
					* CFrame.fromEulerAnglesXYZ(0, math.rad(-90), 0)
			)
			brainrot.PrimaryPart.Anchored = true
			local gui = brainrot:FindFirstChild("EntityBillboardTemplate", true)
			local clock = gui:FindFirstChild("ClockTimer")
			clock.Visible = true
			clock.TextLabel.Text = 60

			local prox = Instance.new("ProximityPrompt")
			prox.Parent = brainrot.PrimaryPart
			prox.ActionText = "Pickup"
			prox.RequiresLineOfSight = false

			prox.Triggered:Connect(function(player: Player)
				local char = player.Character or player.CharacterAdded:Wait()
				local charrying = char:GetAttribute("Carrying")
				local charryLimit = player:GetAttribute("Carry")
				if charrying + 1 < charryLimit then
					char:SetAttribute("Carrying", charrying + 1)
					Petsystem.pickupPet(player, petName, 0, mutation)
					brainrot:Destroy()
				end
			end)

			task.spawn(function()
				while task.wait(1) and clock and clock.Parent and tonumber(clock.TextLabel.Text) > 0 do
					local timer = tonumber(clock.TextLabel.Text)
					clock.TextLabel.Text = timer - 1
				end
				task.wait(1)
				brainrot:Destroy()
			end)
		end
	end)
end
