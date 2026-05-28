local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local BrainrotData = require(ReplicatedStorage.Shared.BrainrotData)
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local fuseMachine = {}

local fuseEvent = ReplicatedStorage.Remotes.FuseEvent

local brainrotSlots: Frame
local container: Frame
local selected: GuiButton?

local function changeBrainrotIcon(template, brainrotData)
	local emptyText = template:FindFirstChild("Empty") :: TextLabel
	emptyText.Visible = false
	template.Rarity.Text = BrainrotData[brainrotData.name].Rarity
	template.Rarity.Visible = true
	template:SetAttribute("Name", brainrotData.name)
	template:SetAttribute("Level", brainrotData.level)
	template:SetAttribute("Mutation", brainrotData.mutation)
	template.RemoveButton.Visible = false

	local icon = template:FindFirstChild("ImageLabel") :: ImageLabel
	icon.Visible = true
	icon.Image = ReplicatedStorage.Images[brainrotData.name].Image
	return template
end

local function createIcon(brainrotData: {}): GuiButton?
	local template = brainrotSlots:FindFirstChild("Placed1")
	if template then
		template = template:Clone()
	else
		return nil
	end
	local petData = { name = brainrotData[1], level = brainrotData[2], mutation = brainrotData[3] }

	template.Parent = container:FindFirstChild("Table") :: ScrollingFrame
	changeBrainrotIcon(template, petData)

	return template
end

local function placeInFuseMachine(brainrotButton: GuiButton)
	selected = brainrotButton
end

local function clear()
	for _, item in container:FindFirstChild("Table"):GetChildren() do
		if item:IsA("ImageButton") then
			item:Destroy()
		end
	end
end

local function loadInventory()
	clear()
	local inventory = ReplicatedStorage.Remotes.ClientData:InvokeServer("Inventory")
	for _, brainrot in inventory do
		local button = createIcon(brainrot)
		button.Activated:Connect(function()
			placeInFuseMachine(button)
		end)
	end
end

local function remove(button: GuiButton)
	local index = string.sub(button.Name, #button.Name)
	fuseEvent:FireServer("Remove", index)

	local emptyText = button:FindFirstChild("Empty") :: TextLabel
	emptyText.Visible = true
	button.Rarity.Visible = false
	button:SetAttribute("Name", nil)
	button:SetAttribute("Level", nil)
	button:SetAttribute("Mutation", nil)

	local icon = button:FindFirstChild("ImageLabel") :: ImageLabel
	icon.Visible = false
end

local function fuseSlotClicked(fuseSlot: GuiButton)
	if not selected then
		return
	end

	if fuseSlot:FindFirstChild("Empty").Visible then
		selected:Destroy()
	else
		local oldBrainrotData = {
			name = fuseSlot:GetAttribute("Name"),
			level = fuseSlot:GetAttribute("Level"),
			mutation = fuseSlot:GetAttribute("Mutation"),
		}
		changeBrainrotIcon(selected, oldBrainrotData)
	end

	local brainrotData = {
		name = selected:GetAttribute("Name"),
		level = selected:GetAttribute("Level"),
		mutation = selected:GetAttribute("Mutation"),
	}
	fuseEvent:FireServer(fuseSlot.Name, brainrotData)

	changeBrainrotIcon(fuseSlot, brainrotData)

	local removeButton = fuseSlot.RemoveButton :: GuiButton
	removeButton.Activated:Connect(function()
		fuseSlot.RemoveButton.Visible = false
		remove(fuseSlot)
	end)
	fuseSlot.RemoveButton.Visible = true
	selected = nil
end
local function loadBrainrots()
	local fuseData = ReplicatedStorage.Remotes.ClientData:InvokeServer("FuseMachine")
	for index, slot in fuseData.Slots do
		slot = { name = slot[1], level = slot[2], mutation = slot[3] }
		local button = brainrotSlots:FindFirstChild(`Placed{index}`) :: GuiButton
		changeBrainrotIcon(button, slot)

		local removeButton = button.RemoveButton :: GuiButton
		removeButton.Activated:Connect(function()
			button.RemoveButton.Visible = false
			remove(button)
		end)
		button.RemoveButton.Visible = true

		button.Activated:Connect(function(a0: InputObject, a1: number)
			fuseSlotClicked(button)
		end)
	end
	loadInventory()
end

function fuseMachine.init()
	local frame = GuiAnimations.newZone(Workspace.FuseMachineZone, "FuseMachineFrame")
	container = frame:FindFirstChild("Container") :: Frame
	brainrotSlots = container:FindFirstChild("PlacedBrainrots") :: Frame
	loadBrainrots()
	frame.Changed:Connect(function(change: string)
		if change == "Visible" and frame.Visible == true then
			loadInventory()
		end
	end)
	Players.LocalPlayer.Backpack.ChildAdded:Connect(loadInventory)
	Players.LocalPlayer.Backpack.ChildRemoved:Connect(loadInventory)
end

return fuseMachine
