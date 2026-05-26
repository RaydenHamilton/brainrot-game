local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataServerService = require(script.Parent.PlayerDataServerService)
local ClientData = {}

local function getData(player, dataName)
	return PlayerDataServerService.get(player, dataName)
end

function ClientData.init()
	ReplicatedStorage.Remotes.ClientData.OnServerInvoke = getData
end

return ClientData
