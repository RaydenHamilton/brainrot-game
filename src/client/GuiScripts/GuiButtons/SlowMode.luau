local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local DefualtSpeed = 16

local function TweenRight(guiObject)
	local goal = {
		Position = UDim2.new(1 - 0.17, 0, 0.5, 0),
	}

	local tweenInfo = TweenInfo.new(
		0.5, -- time
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(guiObject, tweenInfo, goal)
	tween:Play()

	return tween
end

local function TweenLeft(guiObject)
	local goal = {
		Position = UDim2.new(0.17, 0, 0.5, 0),
	}

	local tweenInfo = TweenInfo.new(
		0.5, -- time
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(guiObject, tweenInfo, goal)
	tween:Play()

	return tween
end

local SlowMode = {}
local player = Players.LocalPlayer

local frame = player:WaitForChild("PlayerGui"):WaitForChild("MainGui").SlowMode

function SlowMode.init()
	local button = frame.ImageButton

	button.Activated:connect(function()
		if button.Frame.Green.Enabled then
			TweenLeft(button.Frame)
			button.Frame.Red.Enabled = true
			button.Frame.Green.Enabled = false
			local char = player.Character or player.CharacterAdded:Wait()
			local humanoid = char:WaitForChild("Humanoid") :: Humanoid
			humanoid.WalkSpeed = player:GetAttribute("Speed")
		elseif button.Frame.Red.Enabled then
			TweenRight(button.Frame)
			button.Frame.Green.Enabled = true
			button.Frame.Red.Enabled = false
			local char = player.Character or player.CharacterAdded:Wait()
			local humanoid = char:WaitForChild("Humanoid") :: Humanoid
			humanoid.WalkSpeed = DefualtSpeed
		end
	end)
end
return SlowMode
