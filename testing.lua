print("GANDON PLAYING..,..")

-- ====== Список защищаемых функций ======
local ProtectedFunctions = {
    {
        Object = game,
        Key = "Shutdown",
        Original = game.Shutdown
    },
    {
        Object = game.Players,
        Key = "Kick",
        Original = game.Players.Kick
    }
}

-- ====== Создаем защищенные версии ======
for _, func in ipairs(ProtectedFunctions) do
    func.SafeVersion = newcclosure(function(...)
        print("Protected " .. func.Key .. " called")
        return func.Original(...)
    end)
end

-- ====== Переопределяем доступ через метатаблицы ======
for _, func in ipairs(ProtectedFunctions) do
    local mt = getrawmetatable(func.Object)
    if mt then
        local oldIndex = mt.__index
        setreadonly(mt, false)
        
        mt.__index = newcclosure(function(t, k)
            if k == func.Key then
                return func.SafeVersion
            end
            return oldIndex(t, k)
        end)
        
        setreadonly(mt, true)
    end
end

-- ====== Проверка целостности всех функций ======
spawn(function()
    while true do
        for _, func in ipairs(ProtectedFunctions) do
            -- Проверяем, не изменили ли оригинальную функцию
            if func.Object[func.Key] ~= func.SafeVersion then
                print("Tamper detected on " .. func.Key .. "! Kicking player...")
                local player = game.Players.LocalPlayer
                if player then
                    player:Kick("Tamper detected! " .. func.Key .. " hook attempt!")
                end
                return
            end
        end
        wait(1)
    end
end)

-- ====== Демонстрация защиты ======
print("Testing protection...")

-- Попытка перехвата Shutdown
pcall(function()
    game.Shutdown = function() print("Hacked Shutdown!") end
end)

-- Попытка перехвата Kick
pcall(function()
    game.Players.Kick = function() print("Hacked Kick!") end
end)

