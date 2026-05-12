local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Camera = workspace.CurrentCamera

local normalFOV = 70
local shopFOV = 50

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local openedFrames = {}
local player = Players.LocalPlayer
local Shop = {}

local buttonTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function AddHoverEffect(button: GuiButton)
	local originalSize = button.Size

	local hoverSize = UDim2.new(
		originalSize.X.Scale * 1.10,
		originalSize.X.Offset,
		originalSize.Y.Scale * 1.10,
		originalSize.Y.Offset
	)

	button.MouseEnter:Connect(function()
		local tween = TweenService:Create(button, buttonTweenInfo, { Size = hoverSize })
		tween:Play()
	end)

	button.MouseLeave:Connect(function()
		local tween = TweenService:Create(button, buttonTweenInfo, { Size = originalSize })
		tween:Play()
	end)
	button.Activated:Connect(function()
		if button.Size == originalSize then
			local big = TweenService:Create(button, buttonTweenInfo, { Size = hoverSize })
			big:Play()
			big.Completed:Wait()
		end
		local small = TweenService:Create(button, buttonTweenInfo, { Size = originalSize })
		small:Play()
	end)
end

local function yourRootPart(part)
	local char = player.Character or player.CharacterAdded:Wait()

	if char then
		if char.HumanoidRootPart == part then
			return true
		end
	end
	return false
end

local function Popup(frame: Frame)
	local originalPosition = frame.Position
	frame.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 1.2, 0)
	frame.Visible = true
	local openTween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = originalPosition,
	})

	openTween:Play()

	local fov = TweenService:Create(Camera, tweenInfo, { FieldOfView = shopFOV })
	fov:Play()
end

local function HidePopup(frame: Frame, dontchangeFOV)
	local originalPosition = frame.Position

	local downPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 1.2, 0)

	local tween = TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = downPosition,
	})

	tween:Play()
	if not dontchangeFOV then
		local fov = TweenService:Create(Camera, tweenInfo, { FieldOfView = normalFOV })
		fov:Play()
	end
	tween.Completed:Wait()

	frame.Visible = false
	frame.Position = originalPosition
end

local function openShop(part, frame)
	if not yourRootPart(part) and part ~= true then
		return
	end
	if #openedFrames > 0 then
		for _, oldframe in openedFrames do
			HidePopup(oldframe, true)
		end
	end
	table.insert(openedFrames, frame)
	Popup(frame)
end

local function closeShop(part, frame)
	if not yourRootPart(part) and part ~= true then
		return
	end

	table.remove(openedFrames, table.find(openedFrames, frame))
	HidePopup(frame)
	frame.Visible = false
end

function Shop.newZone(zone: BasePart, frameName: string)
	local frame = player:WaitForChild("PlayerGui"):WaitForChild("MainGui").Frames[frameName]
	zone.Touched:Connect(function(part)
		openShop(part, frame)
	end)

	zone.TouchEnded:Connect(function(part: BasePart)
		closeShop(part, frame)
	end)

	local xbutton = frame:FindFirstChild("XButton", true) :: GuiButton
	if xbutton then
		xbutton.Activated:connect(function()
			closeShop(true, frame)
		end)
	end
end

function Shop.newButton(buttonName: string, frameName: string)
	local frame = player:WaitForChild("PlayerGui"):WaitForChild("MainGui").Frames[frameName]

	local button = player:WaitForChild("PlayerGui"):WaitForChild("MainGui"):FindFirstChild(buttonName, 2)
	button.Activated:Connect(function()
		if frame.Visible == false then
			openShop(true, frame)
		else
			closeShop(true, frame)
		end
	end)

	local xbutton = frame:FindFirstChild("XButton", true) :: GuiButton
	if xbutton then
		xbutton.Activated:connect(function()
			closeShop(true, frame)
		end)
	end
end

function Shop.init()
	for _, button in player:WaitForChild("PlayerGui"):WaitForChild("MainGui"):GetDescendants() do
		if button:IsA("GuiButton") then
			AddHoverEffect(button)
		end
	end
end

return Shop
