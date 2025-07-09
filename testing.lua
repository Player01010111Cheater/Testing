local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local function teleportToPlayer(localPlayer, targetPlayer)
	if not targetPlayer then
		warn("Целевой игрок не найден!")
		return
	end

	local joinData = targetPlayer:GetJoinData()
	local jobId = joinData.SourceJobId
	local placeId = game.PlaceId
	print(jobId)

	if jobId and jobId ~= "" then
		TeleportService:TeleportToPlaceInstance(placeId, jobId, localPlayer)
	else
		warn("Не удалось получить JobId.")
	end
end

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		if msg:sub(1, 6):lower() == "!goto " then
			local targetName = msg:sub(7)

			local targetPlayer = nil
			for _, p in pairs(Players:GetPlayers()) do
				if p.Name == targetName then
					targetPlayer = p
					break
				end
			end

			if targetPlayer then
				teleportToPlayer(player, targetPlayer)
			else
				player:Kick("Игрок '" .. targetName .. "' не найден на сервере.")
			end
		end
	end)
end)
