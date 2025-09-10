-- Сохраняем оригинальную функцию
local oldshut = game.Shutdown

-- Создаём обёртку для отслеживания вызова функции
local function checkShutdown()
    print("game.Shutdown был вызван!")
    -- Здесь можно добавить свои действия при вызове Shutdown
    oldshut() -- Вызываем оригинальную функцию
end

-- Заменяем game.Shutdown на нашу обёртку
game.Shutdown = checkShutdown

-- Функция для проверки, была ли функция изменена
local function isShutdownHooked()
    if game.Shutdown ~= checkShutdown then
        print("game.Shutdown был изменён или захукан!")
        -- Здесь можно добавить свои действия, например, откат или уведомление
        game.Shutdown = checkShutdown -- Восстанавливаем нашу обёртку
    else
        print("game.Shutdown не был изменён.")
    end
end

-- Периодическая проверка (например, каждые 5 секунд)
while true do
    isShutdownHooked()
    wait(5) -- Проверяем каждые 5 секунд
end
