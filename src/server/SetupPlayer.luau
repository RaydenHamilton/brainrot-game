local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataServerService =
	require(ReplicatedStorage.Shared.PlayerDataHandler.SystemPackage.PlayerDataServerService)

local setup = {}

setup.Speed = function(player: Player)
	local char = player.Character or player.CharacterAdded:Wait()
	local speed = PlayerDataServerService.get(player, "Speed")
	char:WaitForChild("Humanoid").WalkSpeed = speed
	player:SetAttribute("Speed", speed)
end

setup.Cash = function(player: Player)
	local cash = PlayerDataServerService.get(player, "Cash")
	player:SetAttribute("Speed", cash)
end

setup.Power = function(player: Player)
	player:SetAttribute("Power", PlayerDataServerService.get(player, "Power"))
end

setup.Carry = function(player: Player)
	player:SetAttribute("Carry", PlayerDataServerService.get(player, "Carry"))
end

local function setupCharacter(player)
	setup.Speed(player)
end

local function setupPlayer(player)
	player.CharacterAdded:Connect(function()
		setupCharacter(player)
	end)
	setup.Carry(player)
	setup.Power(player)
end

function setup.init()
	local Players = game:GetService("Players")
	for _, player in Players:GetChildren() do
		setupPlayer(player)
	end
	Players.PlayerAdded:Connect(function(player: Player)
		local char = player.Character
		if char then
			setupCharacter(player)
		end
		setupPlayer(player)
	end)
end
return setup
