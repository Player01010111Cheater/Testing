local targetRemote = game:GetService("ReplicatedStorage").GameEvents:WaitForChild("ActivePetService")

-- Хук namecall'ов
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if not checkcaller() then
        local method = getnamecallmethod()
        
        if method == "FireServer" and self == targetRemote then
            warn("[MyRemoteEvent] FireServer вызван!")
            local args = {...}
            for i, v in ipairs(args) do
                print("Аргумент " .. i .. ":", v)
            end
        end
    end

    return oldNamecall(self, ...)
end)
