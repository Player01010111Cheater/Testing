print("GANDON PLAYING..,..")

-- ====== Защита game:Shutdown() ======
local OriginalShutdown = game.Shutdown

-- Создаём защищённый метод
local SafeShutdown = newcclosure(function(...)
    print("Protected Shutdown called")
    return OriginalShutdown(...)
end)

-- Переопределяем доступ через метатаблицу
local mt = getrawmetatable(game)
if mt then
    local oldIndex = mt.__index
    setreadonly(mt, false)
    
    mt.__index = newcclosure(function(t, k)
        if k == "Shutdown" then
            return SafeShutdown
        end
        return oldIndex(t, k)
    end)
    
    setreadonly(mt, true)
end

-- Проверка целостности функции
spawn(function()
    while true do
        -- Правильное сравнение функций, а не их строковых представлений
        if game.Shutdown ~= SafeShutdown then
            print("Tamper detected! Kicking player...")
            local player = game.Players.LocalPlayer
            if player then
                player:Kick("Tamper detected! Shutdown hook attempt!")
            end
            break
        end
        wait(1)
    end
end)

-- ====== Демонстрация защиты ======
print("Попытка хука Shutdown:")
local success, err = pcall(function()
    local old
    old = hookfunction(game.Shutdown, function()
        return nil
    end)
end)

if not success then
    print("Попытка хука провалена:", err)
end
