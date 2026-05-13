local setup = {}

function setup.init()
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local PlayerDataServerService =
		require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)

	Players.PlayerAdded:Connect(function(player: Player)
		player:SetAttribute("Power", PlayerDataServerService.get(player, "Power"))
		player:SetAttribute("Carry", PlayerDataServerService.get(player, "Carry"))
		player:SetAttribute("Speed", PlayerDataServerService.get(player, "Speed"))
	end)
end
return setup
