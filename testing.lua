local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

-- Телепортирует игрока localPlayer на сервер targetPlayer
local function teleportToPlayer(localPlayer, targetPlayer)
	if not (localPlayer and targetPlayer) then return end

	local jobId = targetPlayer:GetJoinData().SourceJobId
	local placeId = game.PlaceId

	-- Телепортируем localPlayer на тот же сервер, что и targetPlayer
	TeleportService:TeleportToPlaceInstance(placeId, jobId, localPlayer)
end

-- Пример: когда кто-то пишет команду в чате
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		if msg:sub(1, 6) == "!goto " then
			local targetName = msg:sub(7)
			local targetPlayer = Players:FindFirstChild(targetName)

			if targetPlayer then
				teleportToPlayer(player, targetPlayer)
			else
				player:Kick("Игрок не найден на сервере.")
			end
		end
	end)
end)
