-- ====== Защита Shutdown ======

-- 1️⃣ Сохраняем оригинальный Shutdown
local OriginalShutdown = game.Shutdown

-- 2️⃣ Создаём защищённую версию через newcclosure
local SafeShutdown = newcclosure(function(...)
    print("Protected Shutdown called")
    OriginalShutdown(...) -- оригинальная логика Shutdown
end)

-- 3️⃣ Сохраняем хэш для проверки вмешательств
local ShutdownHash = tostring(SafeShutdown)

-- 4️⃣ Переопределяем доступ через метатаблицу
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if k == "Shutdown" then
        return SafeShutdown
    end
    return oldIndex(t, k)
end)

setreadonly(mt, true)

-- 5️⃣ Проверка целостности функции
spawn(function()
    while true do
        if tostring(SafeShutdown) ~= ShutdownHash then
            -- Кто-то пытался хукнуть или изменить функцию
            print("Tamper detected! Kicking player...")
            local player = game.Players.LocalPlayer
            if player then
                player:Kick("Tamper detected! Shutdown hook attempt!")
            end
            break
        end
        wait(1) -- проверяем каждую секунду
    end
end)

-- ====== Пример использования ======
-- Любые вызовы через game.Shutdown() будут использовать защищённую версию
print("Вызов безопасного Shutdown:")
game.Shutdown() -- вызовет SafeShutdown

-- ====== Пример попытки хука (демонстрация защиты) ======
print("Попытка хука Shutdown:")
local success, err = pcall(function()
    hookfunction(game.Shutdown, function()
        print("Я перехватил Shutdown!") -- это не должно выполниться
    end)
end)
if not success then
    print("Попытка хука провалена:", err)
end
