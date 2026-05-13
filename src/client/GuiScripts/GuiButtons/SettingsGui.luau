local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")
local GuiAnimations = require(StarterPlayer.StarterPlayerScripts.Client.GuiAnimations)
local SettingsGui = {}

local step = 0.1

local function snap(number, factor)
	if factor == 0 then
		return number
	else
		return math.floor(number / factor + 0.5) * factor
	end
end

local function InputEnded(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		RunService:UnbindFromRenderStep("MusicSlider")
		RunService:UnbindFromRenderStep("SoundEffectSlider")
	end
end

local function moveButton(button: GuiButton)
	local mousePos = UserInputService:GetMouseLocation().X
	local BtnPos = button.Position
	local container = button.Parent :: Frame
	local frameSize = container.AbsoluteSize.X
	local framePosition = container.AbsolutePosition.X
	local pos = snap((mousePos - framePosition) / frameSize, step)
	local percentage = math.clamp(pos, 0, 1)
	button.Position = UDim2.new(percentage, 0, BtnPos.Y.Scale, BtnPos.Y.Offset)
	return percentage
end

local function changeMusic(button)
	local percentage = moveButton(button)
	SoundService.BackgroundMusic.Volume = percentage
end

local function changeSoundEffect(button)
	local percentage = moveButton(button)
	for _, sound: Sound in SoundService.SFX:GetChildren() do
		sound.Volume = percentage
	end
end

function SettingsGui.init()
	local frame = GuiAnimations.newButton("SettingsButton", "SettingsFrame")

	local musicSliderButton = frame.Container.Music.Holder.Slider :: GuiButton
	local soundEffectSliderButton = frame.Container.SFX.Holder.Slider :: GuiButton

	musicSliderButton.MouseButton1Down:Connect(function()
		RunService:BindToRenderStep("MusicSlider", Enum.RenderPriority.Camera.Value, function()
			changeMusic(musicSliderButton)
		end)
	end)

	soundEffectSliderButton.MouseButton1Down:Connect(function()
		RunService:BindToRenderStep("SoundEffectSlider", Enum.RenderPriority.Camera.Value, function()
			changeSoundEffect(soundEffectSliderButton)
		end)
	end)

	UserInputService.InputEnded:Connect(InputEnded)
end
return SettingsGui
