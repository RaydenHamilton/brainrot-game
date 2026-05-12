local StarterPlayer = game:GetService("StarterPlayer")
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local rebirth = {}

function rebirth.init()
	GuiAnimations.newButton("RebirthButton", "RebirthFrame")
end
return rebirth
