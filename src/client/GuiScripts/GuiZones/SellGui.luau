local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local sell = {}

function sell.init()
	GuiAnimations.newZone(Workspace.SellZone, "SellFrame")
end

return sell
