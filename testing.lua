-- Хранит оригинальные функции для мониторинга
local FunctionMonitor = {
    Functions = {
        {Name = "game.Shutdown", Original = game.Shutdown, Parent = game, Key = "Shutdown"}
    }
}

-- Кикает игрока при обнаружении изменений
local function kickPlayer(reason)
    if game.Players.LocalPlayer then
        game.Players.LocalPlayer:Kick(reason)
    end
end

-- Защищает функции через метатаблицы
local function setupMetatableProtection(parent, key, original)
    local mt = getrawmetatable(parent)
    if not mt then return end
    
    setreadonly(mt, false)
    
    mt.__index = newcclosure(function(t, k)
        if k == key and oldIndex(t, k) ~= original then
            kickPlayer("Tamper detected: " .. key .. " modified!")
        end
        return k == key and original or oldIndex(t, k)
    end)
    
    mt.__newindex = newcclosure(function(t, k, v)
        if k == key then
            kickPlayer("Tamper detected: Attempt to modify " .. key .. "!")
            return
        end
        if oldNewIndex then oldNewIndex(t, k, v) end
    end)
    
    setreadonly(mt, true)
end

-- Постоянная проверка целостности
game:GetService("RunService").Heartbeat:Connect(function()
    for _, func in ipairs(FunctionMonitor.Functions) do
        if func.Parent[func.Key] ~= func.Original then
            kickPlayer("Tamper detected: " .. func.Name .. " modified!")
        end
    end
end)

-- Инициализация защиты
for _, func in ipairs(FunctionMonitor.Functions) do
    setupMetatableProtection(func.Parent, func.Key, func.Original)
end
