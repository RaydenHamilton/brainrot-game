local NumberShortener = require(script.Parent.NumberShortener)
local animateCash = {}

function animateCash.new(textLabel: TextLabel, newAmount: number, oldAmount: number, Shorten: boolean)
	local total = oldAmount
	local loops = 15
	task.spawn(function()
		for index = 1, loops, 1 do
			task.wait(0.01)

			total += (newAmount - oldAmount) / loops
			textLabel.Text = `${Shorten and NumberShortener.Number(math.round(total)) or math.round(total)}`
		end
	end)
end
return animateCash
