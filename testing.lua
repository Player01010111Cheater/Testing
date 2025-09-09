-- ====== Защита game:Shutdown() ======

-- 1️⃣ Сохраняем оригинальный метод
local OriginalShutdown = game.Shutdown

-- 2️⃣ Создаём защищённый метод через newcclosure
local SafeShutdown = newcclosure(function(self, ...)
    print("Protected Shutdown called")
    OriginalShutdown(self, ...) -- вызываем оригинальный метод
end)

-- 3️⃣ Сохраняем хэш для проверки вмешательства
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

-- ====== Пример безопасного вызова ======
print("Вызов безопасного Shutdown:")
game:Shutdown() -- вызовет SafeShutdown

-- ====== Пример попытки хука (демонстрация) ======
print("Попытка хука Shutdown:")
local success, err = pcall(function()
    hookfunction(game.Shutdown, function(self, ...)
        print("Я перехватил Shutdown!") -- это не должно выполниться
    end)
end)
if not success then
    print("Попытка хука провалена:", err)
end

