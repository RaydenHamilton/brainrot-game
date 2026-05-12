local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local shop = {}

function shop.init()
	GuiAnimations.newZone(Workspace.UpgradesZone, "UpgradesFrame")
end

return shop
