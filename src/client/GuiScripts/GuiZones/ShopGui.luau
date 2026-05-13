local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local shop = {}

local function updateLable(frame) end

local function buyButton(frame: Frame, ProductName: string)
	local ragButton = frame:WaitForChild("SpeedUpgrade") :: GuiButton
	local ragPrice = ragButton.TextLabel
	local robuxButton = frame:WaitForChild("RobuxPurchaseButton") :: GuiButton
	local amountLable = frame:WaitForChild("AmountLabel")

	local buySuccess, data = true, {}

	if buySuccess then
		updateLable(frame, data)
	end
end

local function loadData(tab)
	
end

function shop.init()
	local frame = GuiAnimations.newZone(Workspace.UpgradesZone, "UpgradesFrame")
	local window = frame.Container.ScrollingFrame

	local tabs = {
		{ frame = window.VacuumPowerUpgrade, name = "Power", amount = 10 },
		{ frame = window.VacuumPowerUpgrade2, name = "Power", amount = 100 },
		{ frame = window.GrabUpgrade, name = "Grab", amount = 1 },
		{ frame = window.SpeedUpgrade, name = "Speed", amount = 1 },
	}
	for _, tab in tabs do
		loadData(tab)
	end
end

return shop
