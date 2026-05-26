local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")

local Cost = require(ReplicatedStorage.Shared.Cost)
local NumberShortener = require(ReplicatedStorage.Shared.NumberShortener)
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)

local sell = {}
local remotes = ReplicatedStorage.Remotes

local function sellServer(sellType)
	local sellRemote = remotes.SellItem
	sellRemote:FireServer(sellType)
end

function sell.init()
	local sellFrame = GuiAnimations.newZone(Workspace.SellZone, "SellFrame")

	local container = sellFrame.Container
	local sellInventory = container.InventoryValue
	local itemcontainer = container.ScrollingFrame

	local dataRemote = remotes.ClientData

	local function clear()
		for _, oldItem in itemcontainer:GetChildren() do
			oldItem:Destroy()
		end
	end

	local function sellAll()
		clear()
		sellServer("All")
		sellInventory.SellValueLabel.Text = `Inventory Value: ${0}`
	end

	local function loadShop()
		local data = dataRemote:InvokeServer("Inventory")
		local total = 0

		clear()
		for _, item in data do
			local name = item[1]
			local petData = { Name = name, Level = 0, Mutation = "Normal" }
			local cost = Cost.getCashRate(petData) * 2

			local itemFrame = itemcontainer:FindFirstChild(petData.Name)
			if not itemFrame then
				itemFrame = sellInventory:Clone()
				itemFrame.Parent = itemcontainer
				itemFrame.Name = petData.Name
				itemFrame:SetAttribute("Count", 0)

				local sellButton = itemFrame.SellAll :: GuiButton
				sellButton.Activated:Connect(function()
					sellServer(petData.Name)

					local totalPets = itemFrame:GetAttribute("Count") - 1
					itemFrame:SetAttribute("Count", totalPets)
					itemFrame.SellValueLabel.Text = `{petData.Name}x{totalPets} Value: ${cost * totalPets}`
					total -= cost

					sellInventory.SellValueLabel.Text = `Inventory Value: {NumberShortener.Number(total)}`
					if totalPets < 1 then
						itemFrame:Destroy()
					end
				end)
			end
			local totalPets = itemFrame:GetAttribute("Count") + 1

			itemFrame:SetAttribute("Count", totalPets)
			itemFrame.SellValueLabel.Text = `{petData.Name}x{totalPets} Value: ${cost * totalPets}`

			total += cost
		end
		sellInventory.SellValueLabel.Text = `Inventory Value: ${NumberShortener.Number(total)}`
		sellInventory.SellAll.Activated:Connect(sellAll)
	end

	sellFrame.AttributeChanged:Connect(loadShop)
end

return sell
