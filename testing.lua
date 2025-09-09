local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if k == "Shutdown" then
        local player = game.Players.LocalPlayer
        if player then player:Kick("Tamper detected!") end
    end
    return oldIndex(t, k)
end)

setreadonly(mt, true)


-- ====== Защита error() ======

-- 1️⃣ Сохраняем оригинальную функцию error
local OriginalError = error

-- 2️⃣ Создаём защищённую версию через newcclosure
local SafeError = newcclosure(function(msg, level)
    print("Protected error called with message:", msg)
    OriginalError(msg, level) -- вызываем оригинал
end)

-- 3️⃣ Сохраняем хэш для проверки вмешательства
local ErrorHash = tostring(SafeError)

-- 4️⃣ Переопределяем глобальный доступ через _G или getfenv
-- Здесь мы просто заменяем глобальную функцию
_G.error = SafeError

-- 5️⃣ Проверка целостности функции
spawn(function()
    while true do
        if tostring(_G.error) ~= ErrorHash then
            print("Tamper detected! Kicking player...")
            local player = game.Players.LocalPlayer
            if player then
                player:Kick("Tamper detected! Error hook attempt!")
            end
            break
        end
        wait(1)
    end
end)

-- ====== Пример безопасного вызова ======
print("Вызов безопасного error():")
pcall(function()
    error("Тест безопасного error")
end)

-- ====== Пример попытки хука (демонстрация) ======
print("Попытка Lua-хука error():")
local success, err = pcall(function()
    hookfunction(_G.error, function(msg, level)
        print("Я перехватил error!") -- не должно выполниться
    end)
end)
if not success then
    print("Попытка хука провалена:", err)
end
