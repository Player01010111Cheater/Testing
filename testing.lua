local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MovePetEvent = ReplicatedStorage.GameEvents:WaitForChild("ActivePetService") -- Замените на имя вашего RemoteEvent

-- Сохраняем оригинальную функцию FireServer
local oldFireServer = MovePetEvent.FireServer

-- Переопределяем FireServer для отладки
MovePetEvent.FireServer = function(self, ...)
    local args = {...} -- Захватываем все аргументы
    print("Перехват FireServer. Аргументы:", args) -- Выводим аргументы в консоль
    for i, arg in ipairs(args) do
        print("Аргумент", i, ":", arg, "Тип:", typeof(arg))
    end
    -- Вызываем оригинальную функцию, чтобы не сломать игру
    return oldFireServer(self, ...)
end
