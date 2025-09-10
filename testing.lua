-- Сохраняем оригинальный warn
local raw_warn = warn

-- Таблица для хранения локальных ссылок на "чистые" функции
local safe_funcs = {
    warn = raw_warn,
    print = print,
    error = error,
}

-- Обёртка для warn
local function safe_warn(msg)
    -- Проверка, что глобальный warn не был заменён
    if warn ~= safe_funcs.warn then
        -- Ловушка: сразу аварийно выводим сообщение и прекращаем работу
        safe_funcs.warn("Hook detected on warn! Exiting...")
        return
    end

    -- Вызов оригинального warn через локальную ссылку
    safe_funcs.warn(msg)
end

-- Переназначаем глобальный warn в своём скрипте
warn = safe_warn

-- Периодическая проверка глобальных функций
task.spawn(function()
    while true do
        for k, v in pairs(safe_funcs) do
            if _G[k] ~= v then
                v("Hook detected on "..k.."!")
            end
        end
        task.wait(0.5)
    end
end)

-- Пример использования
warn("Это сообщение через безопасный warn")
