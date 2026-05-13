local Players = game:GetService("Players")
local player = Players.LocalPlayer

local EatSystem = {}

local connenctions = {}
local changedParts = {}
local touchingPart = {}

local function restParts()
	if player.Character.Humanoid.Health == 0 then
		for _, connection in connenctions do
			connection:Disconnect()
		end
		connenctions = {}
		task.wait(1)
	end
	touchingPart = {}

	for _, part in changedParts do
		local tile = part.Parent and part.Parent:FindFirstChild("TilePart") :: BasePart

		part.CanCollide = true
		tile.SelectionBox.Visible = false
		tile.Transparency = 0
		tile.Size = Vector3.new(tile.Size.X, 2, tile.Size.Z)
		tile.Position = Vector3.new(tile.Position.X, 51.9, tile.Position.Z)
	end
	changedParts = {}
end

local function touched(part: BasePart, bodyPart: BasePart)
	if
		part.Parent and part.Parent.Name ~= "Tile" and part.Name ~= "Hitbox"
		or not part.Parent
		or touchingPart[part]
	then
		if part.Name == "ClaimArea" then
			restParts()
		end
		return
	end
	touchingPart[part] = bodyPart
	table.insert(changedParts, part)

	local tile = part.Parent and part.Parent:FindFirstChild("TilePart") :: BasePart
	local power = player:GetAttribute("Power")
	local health = tile.Parent.Parent:GetAttribute("Health")

	tile.SelectionBox.Visible = true

	while touchingPart[part] == bodyPart do
		tile.Size = tile.Size - Vector3.new(0, power / health)
		tile.Position = tile.Position - Vector3.new(0, power / health / 2, 0)
		if tile.Size.Y < 0.01 then
			tile.Transparency = 1
			part.CanCollide = false

			tile.SelectionBox.Visible = false
			return
		end
		task.wait(0.1)
	end
end

local function stopTouch(part: BasePart, bodyPart: BasePart)
	if touchingPart[part] == bodyPart then
		touchingPart[part] = nil

		local tile = part.Parent and part.Parent:FindFirstChild("TilePart") :: BasePart
		tile.SelectionBox.Visible = false

		if touchingPart[part] then
			return
		end
	end
end

local function setupCharacter(char)
	local humanoid = char:WaitForChild("Humanoid") :: Humanoid

	humanoid.Died:Connect(restParts)

	for _, bodyPart in char:GetChildren() do
		if not bodyPart:IsA("BasePart") then
			continue
		end
		table.insert(
			connenctions,
			bodyPart.Touched:Connect(function(part: BasePart)
				touched(part, bodyPart)
			end)
		)

		table.insert(
			connenctions,
			bodyPart.TouchEnded:Connect(function(part: BasePart)
				stopTouch(part, bodyPart)
			end)
		)
	end
end

function EatSystem.init()
	local char = player.Character or player.CharacterAdded:Wait()
	setupCharacter(char)
	player.CharacterAdded:Connect(function(char: Model)
		setupCharacter(char)
	end)
end
return EatSystem
