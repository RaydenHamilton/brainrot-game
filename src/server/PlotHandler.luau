local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AnimateCash = require(ReplicatedStorage.Shared.AnimateCash)
local BrainrotData = require(ReplicatedStorage.Shared.BrainrotData)
local NumberShortener = require(ReplicatedStorage.Shared.NumberShortener)
local Petsystem = require(script.Parent.Petsystem)
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)
local Settings = require(ReplicatedStorage.Shared.Settings)

local Plot = {}

local assets = ReplicatedStorage.Assets.PlotAssets

local function getCashRate(petData): number
	return math.round(
		BrainrotData[petData.Name].Cash * BrainrotData.Mutation[petData.Mutation].Multiplier * 1.15 ^ petData.Level
	)
end

local function getStandTemplate(child)
	local standTemplate = child:FindFirstAncestor("Stand")
	return standTemplate.Parent
end

local function spawnAssest(assest, spawnPart, plot)
	local model = assest:Clone()
	model.Parent = plot
	model:PivotTo(spawnPart.CFrame)
end

function Plot.rest(plot: Model, index: number)
	if plot then
		plot:Destroy()
	end
	local newPlot = ReplicatedStorage.PlotTemplate:Clone()
	newPlot.Parent = Workspace.Plots
	newPlot:PivotTo(Workspace.PlotSpawns[index].CFrame)
	newPlot:SetAttribute("Player", nil)
	newPlot:SetAttribute("Plot", index)
end

local function newPrompt(standTemplate)
	local attachment = standTemplate:FindFirstChild("ProximityAttachment", true)
	local prox = Instance.new("ProximityPrompt")
	prox.ActionText = "Place"
	prox.Parent = attachment
	return prox
end

local function isOwner(player: Player, childofPlot: Instance)
	local plot = childofPlot:FindFirstAncestor("PlotTemplate")
	if plot and plot:GetAttribute("Player") == player.UserId then
		return true
	end
	return false
end

local function getPetFromStand(stand: Model): Model?
	return stand:FindFirstChild("Diamond") :: Model?
		or stand:FindFirstChild("Easter") :: Model?
		or stand:FindFirstChild("Galaxy") :: Model?
		or stand:FindFirstChild("Golden") :: Model?
		or stand:FindFirstChild("Lava") :: Model?
		or stand:FindFirstChild("Normal") :: Model?
		or stand:FindFirstChild("Rainbow") :: Model?
end

local function getPetUpgradePrice(petData): number
	local mulitplier = BrainrotData.Mutation[petData.Mutation].Multiplier
	local baseprice = BrainrotData[petData.Name].Cash

	if petData.Level == 0 then
		return 0
	end
	return math.round(baseprice * mulitplier * 1.28 * 1.25 ^ petData.Level)
end

local function GetAttributes(pet): {}
	return {
		Level = pet:GetAttribute("Level"),
		Name = pet:GetAttribute("Name"),
		Mutation = pet:GetAttribute("Mutation"),
	}
end

local function updatalabel(standTemplate: Model)
	local pet = getPetFromStand(standTemplate)
	if not pet then
		return
	end
	local petData = GetAttributes(pet)

	local upgradeGui = standTemplate:FindFirstChild("SurfaceGui", true) :: SurfaceGui

	local currentLevel = upgradeGui:FindFirstChild("CurrentUpgrade", true)
	local currentPrice = upgradeGui:FindFirstChild("Price", true)
	local cost = getPetUpgradePrice(petData)

	if cost == 0 then
		currentPrice.Text = `Free!`
	else
		currentPrice.Text = `${NumberShortener.Number(cost)}`
	end
	currentLevel.Text = `Lvl {petData.Level} > lvl {petData.Level + 1}`

	pet:FindFirstChild("CashLabel", true).Text = `${NumberShortener.Number(getCashRate(petData))}/s`

	local scale = 0.4 + petData.Level * 0.1
	if scale > 1.1 then
		scale = 1.1
	end

	pet:ScaleTo(scale)

	local standRoot = standTemplate:FindFirstChild("Main", true)
	pet:PivotTo(
		standRoot.CFrame * CFrame.fromOrientation(0, math.rad(180), 0) * CFrame.new(0, pet.PrimaryPart.Size.Y / 2, 0)
	)
end

local function PlacePet(player: Player, standTemplate: Model, petData)
	local newPet = Petsystem.createBrainrot(petData.Name, petData.Mutation, standTemplate)
	newPet.PrimaryPart.Anchored = true

	newPet:SetAttribute("Name", petData.Name)
	newPet:SetAttribute("Level", petData.Level)
	newPet:SetAttribute("Mutation", petData.Mutation)
	local stand = standTemplate:FindFirstChild("Stand")
	local standRoot = stand:FindFirstChild("Main")

	newPet:PivotTo(
		standRoot.CFrame * CFrame.fromOrientation(0, math.rad(180), 0) * CFrame.new(0, newPet.PrimaryPart.Size.Y / 2, 0)
	)

	local data = PlayerDataServerService.get(player, "BaseData")

	local floor = standTemplate.Parent.Parent
	if not data[floor.Name] then
		data[floor.Name] = {}
	end
	data[floor.Name][standTemplate.Name] = petData
	PlayerDataServerService.set(player, "BaseData", data)

	updatalabel(standTemplate)
end

local function PickupPet(player: Player, standTemplate: Model)
	local pet = getPetFromStand(standTemplate)
	if not pet then
		return
	end

	local petData = GetAttributes(pet)

	Petsystem.givePet(player, petData.Name, petData.Level, petData.Mutation)

	local data = PlayerDataServerService.get(player, "BaseData")

	local floor = standTemplate.Parent.Parent
	if not data[floor.Name] then
		data[floor.Name] = {}
	end
	data[floor.Name][standTemplate.Name] = nil
	PlayerDataServerService.set(player, "BaseData", data)

	pet:Destroy()
end

local function UpgradePet(player: Player, standTemplate: Model)
	local pet = getPetFromStand(standTemplate)
	local petData = GetAttributes(pet)
	local cash = PlayerDataServerService.get(player, "Cash")

	local cost = getPetUpgradePrice(petData)

	if cash >= cost then
		petData.Level += 1
		pet:SetAttribute("Level", petData.Level)

		local data = PlayerDataServerService.get(player, "BaseData")

		local floor = standTemplate.Parent.Parent
		if not data[floor.Name] then
			data[floor.Name] = {}
		end
		data[floor.Name][standTemplate.Name] = petData
		PlayerDataServerService.set(player, "BaseData", data)

		updatalabel(standTemplate)
		return { message = `{petData.Name} level {petData.Level}` }
	end
	return { message = `not enough money to upgrade brainrot` }
end

local function collectCash(player: Player, cashModel: Model)
	if not isOwner(player, cashModel) then
		return
	end

	local collectionPart = cashModel:FindFirstChild("TouchPart", true) :: BasePart

	if collectionPart:GetAttribute("Hit") then
		return
	end

	collectionPart:SetAttribute("Hit", true)
	collectionPart.Color = Color3.fromRGB(196, 40, 28)
	collectionPart.Position -= Vector3.new(0, collectionPart.Size.Y, 0)
	local cash = collectionPart:GetAttribute("Cash")
	if cash then
		collectionPart:SetAttribute("Cash", 0)
		PlayerDataServerService.add(player, "Cash", cash)
	end

	AnimateCash.new(collectionPart.CashBillboard.CashLabel, 0, cash or 0, true)
	task.wait(0.5)
	collectionPart:SetAttribute("Hit", nil)
	collectionPart.Color = Color3.fromRGB(101, 143, 99)
	collectionPart.Position += Vector3.new(0, collectionPart.Size.Y, 0)
end

local function placePetProx(prox: ProximityPrompt, player: Player)
	local char = player.Character or player.CharacterAdded:Wait()
	local pet = char:FindFirstChildOfClass("Tool")
	if not pet then
		return
	end
	local standTemplate = getStandTemplate(prox)
	local collectButton = standTemplate:FindFirstChild("TouchPart", true)

	prox.ActionText = "Pickup/Swap"
	collectButton.CashBillboard.Enabled = true

	local petData = GetAttributes(pet)
	pet:Destroy()
	if not pet then
		return
	end
	PlacePet(player, standTemplate, petData)

	local inventory = PlayerDataServerService.get(player, "Inventory")
	table.remove(inventory, table.find(inventory, { petData.Name, petData.Level, petData.Mutation }))
	PlayerDataServerService.set(player, "Inventory", inventory)
end

local function PickupSwapProx(prox: ProximityPrompt, player: Player)
	local standTemplate = getStandTemplate(prox)
	local upgradeButton = standTemplate.UpgradeButton

	local cashModel = upgradeButton.parent.CashModel
	local collectButton = cashModel.TouchPart

	prox.ActionText = "Place"
	collectButton.CashBillboard.Enabled = false

	task.spawn(function()
		collectCash(player, cashModel)
	end)

	local char = player.Character or player.CharacterAdded:Wait()
	local pet = char:FindFirstChildOfClass("Tool")
	PickupPet(player, standTemplate)

	if pet then
		local petData = GetAttributes(pet)
		pet:Destroy()
		PlacePet(player, standTemplate, petData)
	end
end

local function newStand(index, floorFolder)
	if floorFolder.Stands:FindFirstChild(tostring(index)) then
		return
	end
	local standTemplate: Model = assets.StandTemplate:Clone()
	standTemplate.Name = tostring(index)
	standTemplate.Parent = floorFolder.Stands
	standTemplate:PivotTo(floorFolder.StandSpawns[index].CFrame)

	local placeProx = newPrompt(standTemplate)

	placeProx.Triggered:Connect(function(plr)
		if not isOwner(plr, placeProx) then
			return
		end

		if placeProx.ActionText == "Place" then
			placePetProx(placeProx, plr)
		else
			PickupSwapProx(placeProx, plr)
		end
	end)
end
local function getBaseUpgradePrice(baselevel)
	return Settings.Plot.Multiplier ^ (baselevel - Settings.Plot.Offset) * Settings.Plot.Base
end

local function updateSign(plot, baselevel)
	local sign = plot:FindFirstChild("BaseUpgrade")
	local upgradeText = sign:FindFirstChild("CurrentUpgrade", true) :: TextLabel
	local priceText = sign:FindFirstChild("Price", true)
	upgradeText.Text = `{baselevel}/50`
	priceText.Text = `${NumberShortener.Number(getBaseUpgradePrice(baselevel))}`
end

local function updatePlot(plot, baseSkin, baselevel)
	local floors = math.floor((baselevel - 1) / 10)

	local count = baselevel

	for i = 0, floors do
		local floorFolder = plot:FindFirstChild(`Floor{i}`, true)
		local floor: Model? = floorFolder:FindFirstChild(`Floor{i}`)
		if not floor then
			floor = ReplicatedStorage.BaseSkins[baseSkin][`Floor{i}`]:Clone() :: Model
			floor.Parent = floorFolder
			floor:PivotTo(floorFolder.FloorSpawn.CFrame)
		end
		for index = 1, count do
			if index > 10 then
				count -= 10
				break
			end
			newStand(index, floorFolder)
		end
	end
end

local function upgradeBase(player: Player, plotChild)
	if not isOwner(player, plotChild) then
		return { message = "not your base" }
	end
	local plot = plotChild:FindFirstAncestor("PlotTemplate")
	local baselevel = PlayerDataServerService.get(player, "BaseLevel")
	local baseSkin = PlayerDataServerService.get(player, "BaseSkin")
	local cost = getBaseUpgradePrice(baselevel)
	local playerCash = PlayerDataServerService.get(player, "Cash")
	if cost > playerCash then
		return { message = "not enough money" }
	end

	playerCash -= cost
	baselevel += 1

	PlayerDataServerService.set(player, "Cash", playerCash)
	PlayerDataServerService.set(player, "BaseLevel", baselevel)
	updateSign(plot, baselevel)
	updatePlot(plot, baseSkin, baselevel)
	return { message = `Base level {baselevel}` }
end

local function loadBrainrots(player: Player, plot)
	local baseData = PlayerDataServerService.get(player, "BaseData")
	for floorName, stands in baseData do
		for standName, petData in stands do
			local standTemplate = plot.Floors[floorName].Stands[standName]
			PlacePet(player, standTemplate, petData)
			local collectButton = standTemplate:FindFirstChild("TouchPart", true)
			standTemplate:FindFirstChild("ProximityPrompt", true).ActionText = "Pickup/Swap"
			collectButton.CashBillboard.Enabled = true
		end
	end
end

local function loadPlotFromPlotData(player: Player, plot: Model)
	local baselevel = PlayerDataServerService.get(player, "BaseLevel")
	local baseSkin = PlayerDataServerService.get(player, "BaseSkin")

	updateSign(plot, baselevel)
	updatePlot(plot, baseSkin, baselevel)
end

function Plot.new(plot: Model, index: number, player: Player)
	if plot then
		plot:Destroy()
	end

	local newPlot = ReplicatedStorage.PlotTemplate:Clone()
	newPlot.Parent = Workspace.Plots
	newPlot:PivotTo(Workspace.PlotSpawns[index].CFrame)

	newPlot:SetAttribute("Player", player.UserId)
	newPlot:SetAttribute("Plot", index)

	spawnAssest(assets.CollectAll, newPlot.CollectAllSpawn, newPlot)
	spawnAssest(ReplicatedStorage.BaseUpgrade, newPlot.SignSpawn, newPlot)

	local playericon = assets.HomeBillboard:Clone()
	playericon.Parent = newPlot.BillboardSpawnPart

	local ImageSize = Enum.ThumbnailSize.Size420x420
	local ImageType = Enum.ThumbnailType.HeadShot

	local content = game.Players:GetUserThumbnailAsync(player.UserId, ImageType, ImageSize)

	playericon.ImageLabel.Image = content
	playericon.TextLabel.Text = player.Name

	loadPlotFromPlotData(player, newPlot)
end

local function findPlot(player)
	for _, plot in Workspace.Plots:GetChildren() do
		local index = plot:GetAttribute("Plot")
		local isPlayer = plot:GetAttribute("Player")
		if not isPlayer then
			Plot.new(plot, index, player)
		end
		break
	end
end

local function removePlot(player)
	for _, plot in Workspace.Plots:GetChildren() do
		local index = plot:GetAttribute("Plot")
		local isPlayer = plot:GetAttribute("Player")
		if isPlayer == player.UserId then
			Plot.rest(plot, index)
		end
		break
	end
end

local function characterAdded(char)
	local player = Players:GetPlayerFromCharacter(char)
	char.HumanoidRootPart.Touched:Connect(function(hitPart)
		local cashModel = hitPart:FindFirstAncestor("CashModel")
		if cashModel then
			collectCash(player, cashModel)
		end
	end)
end

local function playerAdded(player)
	findPlot(player)

	local character = player.Character
	if character then
		characterAdded(character)
	end
	player.CharacterAdded:Connect(function(char: Model)
		characterAdded(char)
	end)
end

local function updateCash()
	task.spawn(function()
		while task.wait(1) do
			pcall(function()
				for _, template in Workspace.Plots:GetChildren() do
					for _, floor in template.Floors:GetChildren() do
						for _, stand in floor.Stands:GetChildren() do
							local pet: Model? = getPetFromStand(stand)
							if not pet then
								continue
							end
							local petData = GetAttributes(pet)
							local cash = stand.CashModel.TouchPart:GetAttribute("Cash") or 0
							local newCash = cash + getCashRate(petData)

							local touchPart = stand.CashModel.TouchPart

							task.spawn(function()
								AnimateCash.new(touchPart.CashBillboard.CashLabel, newCash, cash, true)
							end)
							touchPart:SetAttribute("Cash", newCash)
						end
					end
				end
			end)
		end
	end)
end

function Plot.init()
	for index, plot in Workspace.PlotSpawns:GetChildren() do
		Plot.rest(nil, plot.Name)
	end
	for _, player in Players:GetChildren() do
		playerAdded(player)
	end
	Players.playerAdded:Connect(playerAdded)
	Players.PlayerRemoving:Connect(removePlot)
	updateCash()

	ReplicatedStorage.Remotes.UpgradeBase.OnServerInvoke = upgradeBase
	ReplicatedStorage.Remotes.UpgradePet.OnServerInvoke = UpgradePet
	ReplicatedStorage.Remotes.PlayerLoaded.OnServerEvent:Connect(loadBrainrots)
end

return Plot
