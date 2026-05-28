local ServerStorage = game:GetService("ServerStorage")
local BrainrotData = require(script.Parent.BrainrotData)
local pickRandom = {}

function pickRandom.randomBrainRot(rarity)
	local brainrots = ServerStorage.Brainrots[rarity]:GetChildren()
	local index = math.random(1, #brainrots)
	local petName = brainrots[index].Name
	return petName
end

local function randomPick(tbl)
	local totalWeight = 0

	-- Add all percentages together
	for _, weight in pairs(tbl) do
		totalWeight += weight
	end

	-- Pick random number
	local random = math.random() * totalWeight

	local current = 1

	for item, weight in pairs(tbl) do
		current += weight

		if random <= current then
			return item
		end
	end
	return nil
end

function pickRandom.randomMutation()
	return randomPick(BrainrotData.MutationChance)
end
return pickRandom
