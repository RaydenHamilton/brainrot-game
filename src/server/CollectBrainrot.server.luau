local Players = game:GetService("Players")
local Petsystem = require(script.Parent.Petsystem)

local function characterAdded(character: Model, player: Player)
	local root = character:WaitForChild("HumanoidRootPart") :: Part
	character:SetAttribute("Carrying", 0)
	root.Touched:Connect(function(hitPart: BasePart)
		if hitPart and hitPart.Name == "ClaimArea" then
			while root:FindFirstChildOfClass("Model") do
				local brainrot = root:FindFirstChildOfClass("Model")
				local name = brainrot:GetAttribute("Name")
				local level = brainrot:GetAttribute("Level")
				local mutation = brainrot:GetAttribute("Mutation")
				Petsystem.givePet(player, name, level, mutation)
				brainrot:Destroy()
			end
			character:SetAttribute("Carrying", 0)
		end
	end)
end

local function playerAdded(player: Player)
	local character = player.Character
	if character then
		characterAdded(character, player)
	end
	player.CharacterAdded:Connect(function(character: Model)
		characterAdded(character, player)
	end)
end

for i, player in Players:GetChildren() do
	playerAdded(player)
end

Players.PlayerAdded:Connect(function(player: Player)
	playerAdded(player)
end)
