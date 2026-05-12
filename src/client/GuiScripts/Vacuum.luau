local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local vacuum = {}

function vacuum.init()
	GuiAnimations.newZone(Workspace.VacuumZone, "VacuumShopFrame")
end
return vacuum
