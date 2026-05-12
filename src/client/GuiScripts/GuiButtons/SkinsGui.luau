local StarterPlayer = game:GetService("StarterPlayer")
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local SkinGui = {}
function SkinGui.init()
	GuiAnimations.newButton("SkinsButton", "SkinsFrame")
end
return SkinGui
