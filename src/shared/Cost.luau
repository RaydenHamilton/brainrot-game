local BrainrotData = require(script.Parent.BrainrotData)
local Settings = require(script.Parent.Settings)
local cost = {}

function cost.getPetUpgradePrice(petData): number
	local mulitplier = BrainrotData.Mutation[petData.Mutation].Multiplier
	local baseprice = BrainrotData[petData.Name].Cash

	if petData.Level == 0 then
		return 0
	end
	return math.round(baseprice * mulitplier * 1.28 * 1.25 ^ petData.Level)
end

function cost.getBaseUpgradePrice(baselevel)
	return Settings.Plot.Multiplier ^ (baselevel - Settings.Plot.Offset) * Settings.Plot.Base
end

function cost.GetItemTotalCost(ProductName, startLevel, amount)
	local startCost = Settings[ProductName].Base
	local multiplier = Settings[ProductName].Multiplier
	local offset = Settings[ProductName].Offset

	local total = 0

	local endLevel = startLevel + amount

	for level = startLevel, endLevel do
		total += startCost * (multiplier ^ (level - offset - 1))
	end

	return total
end

function cost.getCashRate(petData): number
	return math.round(
		BrainrotData[petData.Name].Cash * BrainrotData.Mutation[petData.Mutation].Multiplier * 1.15 ^ petData.Level
	)
end

return cost
