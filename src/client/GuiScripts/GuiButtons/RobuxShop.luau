local StarterPlayer = game:GetService("StarterPlayer")
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local RobuxShop = {}

function RobuxShop.init()
	GuiAnimations.newButton("ShopButton", "ShopFrame")
end
return RobuxShop
