local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local BrainrotData = require(ReplicatedStorage.Shared.BrainrotData)
local PetSystem = {}

local function createLabel(brainrotRoot: BasePart, petName: string, mutation: string)
	local rarity = BrainrotData[petName].Rarity
	local brainrotInfo = ReplicatedStorage.Assets.BrainrotAssets.EntityBillboardTemplate:Clone()
	brainrotInfo.MaxDistance = 100
	brainrotInfo.Parent = brainrotRoot
	brainrotInfo.CashLabel.Text = `${BrainrotData[petName].Cash * BrainrotData.Mutation[mutation].Multiplier}/s`
	brainrotInfo.NameLabel.Text = `{petName}`
	brainrotInfo.RarityLabel.Text = `{rarity}`
	brainrotInfo.RarityLabel.TextColor3 = BrainrotData.Rarity[rarity].Color

	if rarity == "Common" then
		brainrotInfo.RarityLabel.SecretGradient.Enabled = false
	end
	brainrotInfo.MutationLabel.Text = `{mutation}`
	brainrotInfo.MutationLabel.Visible = mutation ~= "Normal" and true or false
	brainrotInfo.MutationLabel.Gradient.Color = BrainrotData.Mutation[mutation].Gradient
end
function PetSystem.createBrainrot(petName: string, mutation: string, parent: Instance)
	local brainrots = ServerStorage.Brainrots
	local brainrot: Model = brainrots[petName][mutation]:Clone()
	local brainrotRoot = brainrot.PrimaryPart
	brainrot.Parent = parent
	if parent:IsA("BasePart") then
		print(parent)
		brainrot:PivotTo(parent.CFrame * CFrame.new(0, 3, -1))
	end
	brainrotRoot.Anchored = false

	createLabel(brainrotRoot, petName, mutation)
	return brainrot
end

local function weldTo(brainrotRoot, rootpart)
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = brainrotRoot
	weld.Part1 = rootpart
	weld.Parent = brainrotRoot
end

function PetSystem.givePet(player: Player, petName, level: number, mutation: string)
	local tool = ReplicatedStorage.Assets.TemplateTool:Clone()

	local brainrot = PetSystem.createBrainrot(petName, mutation, tool.Handle)

	weldTo(brainrot.PrimaryPart, tool.Handle)

	tool:SetAttribute("Level", level)
	tool:SetAttribute("Name", petName)
	tool:SetAttribute("Mutation", mutation)

	tool.Name = petName
	tool.Parent = player.Backpack
end

function PetSystem.pickupPet(player: Player, petName: string, level: number, mutation: string)
	local character = player.Character
	if not character then
		return
	end

	local rootpart = character.HumanoidRootPart
	local brainrot = PetSystem.createBrainrot(petName, mutation, rootpart)

	brainrot:SetAttribute("Level", level)
	brainrot:SetAttribute("Name", petName)
	brainrot:SetAttribute("Mutation", mutation)

	local brainrotRoot = brainrot.PrimaryPart

	weldTo(brainrotRoot, rootpart)
end

return PetSystem
