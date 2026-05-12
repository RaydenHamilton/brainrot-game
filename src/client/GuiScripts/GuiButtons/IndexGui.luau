local StarterPlayer = game:GetService("StarterPlayer")
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local indexGui = {}

function indexGui.init()
	GuiAnimations.newButton("IndexButton", "IndexFrame")
end

return indexGui
