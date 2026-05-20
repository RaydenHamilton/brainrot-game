local Data = {}

Data.Mutation = {
	["Easter"] = {
		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.858824, 0.007843, 0.603922)),
			ColorSequenceKeypoint.new(1, Color3.new(0.572549, 0.023529, 0.498039)),
		}),
		Multiplier = 1,
	},
	["Galaxy"] = {
		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.52549, 0.023529, 0.941176)),
			ColorSequenceKeypoint.new(1, Color3.new(0.54902, 0.184314, 0.960784)),
		}),
		Multiplier = 1,
	},
	["Golden"] = {
		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.631373, 0.858824, 0.007843)),
			ColorSequenceKeypoint.new(1, Color3.new(0.901961, 0.913725, 0.266667)),
		}),
		Multiplier = 1,
	},
	["Lava"] = {
		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 0.12549, 0.12549)),
			ColorSequenceKeypoint.new(1, Color3.new(0.960784, 0.301961, 0.301961)),
		}),
		Multiplier = 1,
	},
	["Normal"] = {
		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, Color3.new(0.572549, 0.023529, 0.498039)),
		}),
		Multiplier = 1,
	},

	["Diamond"] = {
		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.25098, 0.364706, 1)),
			ColorSequenceKeypoint.new(1, Color3.new(0.635294, 0.478431, 1)),
		}),
		Multiplier = 1,
	},
}
Data.MutationChance = { Normal = 1, Lava = 1, Golden = 1, Galaxy = 1, Easter = 1, Diamond = 1 }
Data.Rarity = {
	Common = { Color = Color3.new(0.792157, 0.792157, 0.792157) },
	Rare = { Color = Color3.new(0.066667, 0.541176, 0.92549) },
	Epic = { Color = Color3.new(0.572549, 0.023529, 0.678431) },
	Legendary = { Color = Color3.new(0.866667, 0.854902, 0.027451) },
	Mythic = { Color = Color3.new(0.866667, 0.388235, 0.866667) },
	God = { Color = Color3.new(0.541176, 0.541176, 0.541176) },
	Secret = { Color = Color3.new() },
}

Data["67"] = { Cash = 67, Rarity = "Common" }

return Data
