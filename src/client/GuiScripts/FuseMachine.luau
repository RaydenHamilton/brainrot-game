local StarterPlayer = game:GetService("StarterPlayer")
local Workspace = game:GetService("Workspace")
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local fuseMachine = {}

function fuseMachine.init()
	GuiAnimations.newZone(Workspace.FuseMachineZone, "FuseMachineFrame")
end
return fuseMachine
