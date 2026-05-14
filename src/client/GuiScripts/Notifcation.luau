local Players = game:GetService("Players")
local Notifaction = {}

local player = Players.LocalPlayer
local playergui = player:WaitForChild("PlayerGui")
local timer = tick()

function Notifaction.new(message: string)
	local notifaction: Frame = playergui.MainGui.Top.TutorialBox
	local newNotifaction = notifaction.Parent.NotificationContainer:FindFirstChild(message)
	if not newNotifaction then
		newNotifaction = notifaction:Clone()
		newNotifaction.Parent = notifaction.Parent.NotificationContainer
		newNotifaction.Visible = true
		newNotifaction.Name = message
		newNotifaction:SetAttribute("Count", 0)
	end

	newNotifaction:SetAttribute("Count", newNotifaction:GetAttribute("Count") + 1)
	local text = message
	local count = newNotifaction:GetAttribute("Count")

	if count > 1 then
		text = `{message}(x{count})`
	end
	local textlabel = newNotifaction.TextLabel :: TextLabel
	textlabel.Text = text
	timer = tick()

	textlabel.TextTransparency = 0
	textlabel.UIStroke.Transparency = 0
	newNotifaction.Transparency = 0.7
	repeat
		task.wait(1)
	until timer < tick() - 3
	while task.wait() and textlabel.TextTransparency < 1 and text == textlabel.Text do
		textlabel.TextTransparency += 0.011
		textlabel.UIStroke.Transparency += 0.01
		newNotifaction.Transparency += 0.1 / 2.5
	end

	if newNotifaction and text == textlabel.Text then
		newNotifaction:Destroy()
	end
end
return Notifaction
