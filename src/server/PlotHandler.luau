local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)
local Plot = {}

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

local function loadPlotFromPlotData(player: Player, plot: Model)
	local baselevel = PlayerDataServerService.get(player, "BaseLevel")
	local baseSkin = PlayerDataServerService.get(player, "BaseSkin")

	local upgradeText = plot.BaseUpgrade:FindFirstChild("CurrentUpgrade", true) :: TextLabel
	upgradeText.Text = `{baselevel}/50`

	local floors = math.floor(baselevel / 10)

	for i = 0, floors do
		local floor: Model = ReplicatedStorage.BaseSkins[baseSkin][`Floor{i}`]:Clone()
		floor.Parent = plot:FindFirstChild(floor.Name, true)
		floor:PivotTo(floor.Parent.FloorSpawn.CFrame)
	end
end

function Plot.new(plot: Model, index: number, player: Player)
	plot:Destroy()

	local newPlot = ReplicatedStorage.PlotTemplate:Clone()
	newPlot.Parent = Workspace.Plots
	newPlot:PivotTo(Workspace.PlotSpawns[index].CFrame)

	newPlot:SetAttribute("Player", player.UserId)
	newPlot:SetAttribute("Plot", index)

	local assest = ReplicatedStorage.Assets.PlotAssets

	spawnAssest(assest.CollectAll, newPlot.CollectAllSpawn, newPlot)
	spawnAssest(ReplicatedStorage.BaseUpgrade, newPlot.SignSpawn, newPlot)

	local playericon = assest.HomeBillboard:Clone()
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

function Plot.init()
	for index, plot in Workspace.Plots:GetChildren() do
		Plot.rest(plot, index)
	end
	Players.playerAdded:Connect(findPlot)
	Players.PlayerRemoving:Connect(removePlot)
end

return Plot
