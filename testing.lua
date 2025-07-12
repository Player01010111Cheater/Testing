local targetRemote = game:GetService("ReplicatedStorage").GameEvents:WaitForChild("ActivePetService")

local oldNamecall
local count = 0
local lastLogTime = tick()

oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if not checkcaller() then
        local method = getnamecallmethod()
        
        if method == "FireServer" and self == targetRemote then
            count = count + 1
            local now = tick()

            -- логируем только раз в 1 секунду или первые 5 раз
            if count <= 5 or now - lastLogTime > 1 then
                warn("[ActivePetService] FireServer вызван!")
                local args = {...}
                for i, v in ipairs(args) do
                    print("  Аргумент " .. i .. ":", v)
                end
                lastLogTime = now
            end
        end
    end

    return oldNamecall(self, ...)
end)

warn("✅ Хук установлен")

