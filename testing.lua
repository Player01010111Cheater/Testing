local ReplicatedStorage = game:GetService("ReplicatedStorage").GameEvents:WaitForChild("ActivePetService")

-- Функция для перехвата OnClientEvent для конкретного RemoteEvent
local function interceptRemoteEvent(remote)
    if remote and remote:IsA("RemoteEvent") then
        print("Перехват OnClientEvent для RemoteEvent:", remote.Name)
        remote.OnClientEvent:Connect(function(...)
            local args = {...}
            print("Получены данные от сервера через", remote.Name, ":", args)
            for i, arg in ipairs(args) do
                print("Аргумент", i, ":", tostring(arg), "Тип:", typeof(arg))
            end
        end)
    else
        warn("Ошибка: Объект", remote and remote.Name or "nil", "не является RemoteEvent")
    end
end

interceptRemoteEvent(ReplicatedStorage)
