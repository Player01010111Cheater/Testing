-- Таблица для хранения оригинальных функций
local FunctionMonitor = {
    Functions = {
        {
            Name = "HttpService.RequestAsync",
            Original = game:GetService("HttpService").RequestAsync,
            Parent = game:GetService("HttpService"),
            Key = "RequestAsync"
        },
        {
            Name = "game.Shutdown",
            Original = game.Shutdown,
            Parent = game,
            Key = "Shutdown"
        }
        -- Добавьте другие функции для мониторинга сюда, например:
        -- { Name = "Players.Kick", Original = game.Players.Kick, Parent = game.Players, Key = "Kick" }
    }
}

-- Функция для кика игрока
local function kickPlayer(reason)
    local player = game.Players.LocalPlayer
    if player then
        player:Kick(reason)
    end
end

-- Настройка перехвата метатаблиц для каждого объекта
local function setupMetatableProtection(parent, key, original)
    local mt = getrawmetatable(parent)
    if not mt then return end
    
    local oldIndex = mt.__index
    local oldNewIndex = mt.__newindex
    
    setreadonly(mt, false)
    
    -- Перехват обращений к функции
    mt.__index = newcclosure(function(t, k)
        if k == key then
            local current = oldIndex(t, k)
            if current ~= original then
                kickPlayer("Tamper detected: " .. key .. " modified!")
            end
            return original -- Всегда возвращаем оригинальную функцию
        end
        return oldIndex(t, k)
    end)
    
    -- Перехват попыток изменения функции
    mt.__newindex = newcclosure(function(t, k, v)
        if k == key then
            kickPlayer("Tamper detected: Attempt to modify " .. key .. "!")
            return -- Блокируем изменение
        end
        if oldNewIndex then
            oldNewIndex(t, k, v)
        end
    end)
    
    setreadonly(mt, true)
end

-- Периодическая проверка целостности функций
game:GetService("RunService").Heartbeat:Connect(function()
    for _, func in ipairs(FunctionMonitor.Functions) do
        local current = func.Parent[func.Key]
        if current ~= func.Original then
            kickPlayer("Tamper detected: " .. func.Name .. " modified!")
        end
    end
end)

-- Инициализация защиты для каждой функции
for _, func in ipairs(FunctionMonitor.Functions) do
    setupMetatableProtection(func.Parent, func.Key, func.Original)
end
