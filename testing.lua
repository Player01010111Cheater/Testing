-- Сохраняем оригинальную функцию
local original_error = error

-- Создаем защищенную обертку
error = newcclosure(function(...)
    return original_error(...)
end)

-- Пример использования
error("Защищенная ошибка!")
