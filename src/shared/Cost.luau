local BrainrotData = require(script.Parent.BrainrotData)
local cost = {}

function cost.getPetUpgradePrice(petData): number
	local mulitplier = BrainrotData.Mutation[petData.Mutation].Multiplier
	local baseprice = BrainrotData[petData.Name].Cash

	if petData.Level == 0 then
		return 0
	end
	return math.round(baseprice * mulitplier * 1.28 * 1.25 ^ petData.Level)
end

return cost
