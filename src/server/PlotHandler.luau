local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)
local Plot = {}

local assets = ReplicatedStorage.Assets.PlotAssets

local function spawnAssest(assest, spawnPart, plot)
	local model = assest:Clone()
	model.Parent = plot
	model:PivotTo(spawnPart.CFrame)
end

function Plot.rest(plot: Model, index: number)
	plot:Destroy()
	local newPlot = ReplicatedStorage.PlotTemplate:Clone()
	newPlot.Parent = Workspace.Plots
	newPlot:PivotTo(Workspace.PlotSpawns[index].CFrame)
	newPlot:SetAttribute("Player", nil)
	newPlot:SetAttribute("Plot", index)
end

local function newPrompt(newStand, text)
	local attachment = newStand:FindFirstChild("ProximityAttachment", true)
	local place = Instance.new("ProximityPrompt")
	place.ActionText = text
	place.Parent = attachment

	return place
end

local function isOwner(player: Player, childofPlot: Instance)
	local plot = childofPlot:FindFirstAncestor("PlotTemplate")
	if plot and plot:GetAttribute("Player") == player.UserId then
		return true
	end
	return false
end

local function PlacePet(player: Player, stand: Model)
	local char = player.Character or player.CharacterAdded:Wait()
	local pet = char:FindFirstChildOfClass("Tool")

	local name = "67"
	local rarity = "Common"
	local mutation = "Diamond"
	local cashRate = `{1}/s`

	local newPet = ServerStorage["Brainrots"][name][mutation]:Clone()

	for i, v in newPet:GetDescendants() do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.CanQuery = false
		end
	end
	newPet.Parent = stand
	newPet:PivotTo(
		stand:FindFirstAncestorOfClass("Folder").Parent.StandSpawns[stand.Name].CFrame
			* CFrame.fromOrientation(0, math.rad(180), 0)
	)
	local info = assets.EntityBillboardTemplate:Clone()
	info.Parent = newPet
	info.NameLabel.Text = name
	info.RarityLabel.Text = rarity
	info.MutationLabel.Text = mutation
	info.CashLabel.Text = cashRate
end
local function PickupPet(player: Player, stand: Model)
	local s = stand.Parent
	local pet = s:FindFirstChild("Diamond")
		or s:FindFirstChild("Easter")
		or s:FindFirstChild("Galaxy")
		or s:FindFirstChild("Golden")
		or s:FindFirstChild("Lava")
		or s:FindFirstChild("Normal")
		or s:FindFirstChild("Rainbow")
	pet:Destroy()
end
local function UpgradePet(player: Player, stand: Model) end

local function placePetProx(promp: ProximityPrompt, player: Player)
	local char = player.Character or player.CharacterAdded:Wait()
	local pet = char:FindFirstChildOfClass("Tool")
	if pet or true then
		promp.ActionText = "Pickup/Swap"
		local upgradeButton = promp:FindFirstAncestor("Stand").Parent.UpgradeButton
		local upgradeGui = upgradeButton.SurfaceGui :: SurfaceGui
		upgradeGui.Enabled = true
		PlacePet(player, promp:FindFirstAncestor("Stand").Parent)
	end
end
local function PickupSwapProx(prox: ProximityPrompt, player: Player)
	prox.ActionText = "Place"
	local upgradeButton = prox:FindFirstAncestor("Stand").Parent.UpgradeButton
	local upgradeGui = upgradeButton.SurfaceGui :: SurfaceGui
	upgradeGui.Enabled = false

	local char = player.Character or player.CharacterAdded:Wait()
	local pet = char:FindFirstChildOfClass("Tool")
	PickupPet(player, prox:FindFirstAncestor("Stand"))
	if pet then
		placePetProx(prox, player)
	end
end

local function loadPlotFromPlotData(player: Player, plot: Model)
	local baselevel = PlayerDataServerService.get(player, "BaseLevel")
	local baseSkin = PlayerDataServerService.get(player, "BaseSkin")

	local upgradeText = plot.BaseUpgrade:FindFirstChild("CurrentUpgrade", true) :: TextLabel
	upgradeText.Text = `{baselevel}/50`

	local floors = math.floor((baselevel - 1) / 10)

	local count = baselevel
	for i = 0, floors do
		local floor: Model = ReplicatedStorage.BaseSkins[baseSkin][`Floor{i}`]:Clone()
		local floorFolder = plot:FindFirstChild(floor.Name, true)
		floor.Parent = floorFolder
		floor:PivotTo(floor.Parent.FloorSpawn.CFrame)
		for index = 1, count do
			if index > 10 then
				count -= 10
				break
			end
			local newStand: Model = assets.StandTemplate:Clone()
			newStand.Name = tostring(index)
			newStand.Parent = floorFolder.Stands
			newStand:PivotTo(floorFolder.StandSpawns[index].CFrame)

			local placeProx = newPrompt(newStand, "Place")

			placeProx.Triggered:Connect(function(plr)
				if isOwner(plr, placeProx) then
					if placeProx.ActionText == "Place" then
						placePetProx(placeProx, plr)
					else
						PickupSwapProx(placeProx, plr)
					end
				end
			end)
		end
	end
end

function Plot.new(plot: Model, index: number, player: Player)
	plot:Destroy()

	local newPlot = ReplicatedStorage.PlotTemplate:Clone()
	newPlot.Parent = Workspace.Plots
	newPlot:PivotTo(Workspace.PlotSpawns[index].CFrame)

	newPlot:SetAttribute("Player", player.UserId)
	newPlot:SetAttribute("Plot", index)

	spawnAssest(assets.CollectAll, newPlot.CollectAllSpawn, newPlot)
	spawnAssest(ReplicatedStorage.BaseUpgrade, newPlot.SignSpawn, newPlot)

	local playericon = assets.HomeBillboard:Clone()
	playericon.Parent = newPlot.BillboardSpawnPart

	local ImageSize = Enum.ThumbnailSize.Size420x420 -- Thumbnail Size
	local ImageType = Enum.ThumbnailType.HeadShot -- Thumbnail Type

	local content = game.Players:GetUserThumbnailAsync(player.UserId, ImageType, ImageSize) -- Gets Image from UserId

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

local function collectCash(player: Player, cashModel: Model)
	if isOwner(player, cashModel) then
		local collectionPart = cashModel:FindFirstChild("TouchPart", true) :: BasePart
		if not collectionPart:GetAttribute("Hit") then
			collectionPart:SetAttribute("Hit", true)
			collectionPart.Color = Color3.fromRGB(196, 40, 28)
			collectionPart.Position = collectionPart.Position - Vector3.new(0, collectionPart.Size.Y , 0)
			local cash = collectionPart:GetAttribute("Cash")
			if cash then
				collectionPart:SetAttribute("Cash", 0)
				PlayerDataServerService.add(player, "Cash", cash)
			end
			task.wait(1)
			collectionPart:SetAttribute("Hit", nil)
			collectionPart.Position = collectionPart.Position + Vector3.new(0, collectionPart.Size.Y , 0)
			collectionPart.Color = Color3.fromRGB(101, 143, 99)
		end
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

	local char = player.Character
	if char then
		characterAdded(char)
	end
	player.CharacterAdded:Connect(function(char: Model)
		characterAdded(char)
	end)
end

function Plot.init()
	for index, plot in Workspace.Plots:GetChildren() do
		Plot.rest(plot, index)
	end
	Players.playerAdded:Connect(playerAdded)
	Players.PlayerRemoving:Connect(removePlot)
end

return Plot
