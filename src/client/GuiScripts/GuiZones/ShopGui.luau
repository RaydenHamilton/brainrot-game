local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local NumberShortener = require(ReplicatedStorage.Shared.NumberShortener)
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local Notifcation = require(StarterPlayer.StarterPlayerScripts.Client.GuiScripts.Notifcation)
local shop = {}
local purchesRemoteFunction = ReplicatedStorage.Remotes.Purches

local frame = GuiAnimations.newZone(Workspace.UpgradesZone, "UpgradesFrame")
local window = frame.Container.ScrollingFrame

local tabs = {
	{ frame = window.VacuumPowerUpgrade, name = "Power", amount = 10 },
	{ frame = window.VacuumPowerUpgrade2, name = "Power", amount = 100 },
	{ frame = window.GrabUpgrade, name = "Carry", amount = 1 },
	{ frame = window.SpeedUpgrade, name = "Speed", amount = 1 },
}

local function updateLable(tab: { frame: Frame, name: string, amount: number }, data: { cost: number, amount: number })
	local ragButton = tab.frame:WaitForChild(`RegularPurchaseButton`) :: GuiButton
	local ragPrice = ragButton.TextLabel :: TextLabel
	local robuxButton = tab.frame:WaitForChild("RobuxPurchaseButton") :: GuiButton
	local amountLable = tab.frame:WaitForChild("AmountLabel") :: TextLabel

	ragPrice.Text = `${NumberShortener.Number(data.cost)}`
	amountLable.Text = `{data.amount} > {data.amount + tab.amount}`
end

local function loadData(tab: { frame: Frame, name: string, amount: number })
	local data = purchesRemoteFunction:InvokeServer(tab.name, tab.amount, true)

	if data then
		updateLable(tab, data)
	end
end

local function buyButton(tab: { frame: Frame, name: string, amount: number })
	local ragButton = tab.frame:WaitForChild(`RegularPurchaseButton`) :: GuiButton
	ragButton.Activated:Connect(function(a0: InputObject, a1: number)
		local data = purchesRemoteFunction:InvokeServer(tab.name, tab.amount)

		if data.success then
			updateLable(tab, data)
			for _, otherTab in tabs do
				if tab.name == otherTab and tab.frame ~= otherTab.frame then
					loadData(otherTab)
				end
			end
		else
			Notifcation.new(data.message)
		end
	end)
end

function shop.init()
	for _, tab in tabs do
		loadData(tab)
		buyButton(tab)
	end
end

return shop
