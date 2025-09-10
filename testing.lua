-- Сохраняем оригинальные функции
local raw_warn = warn
local raw_print = print
local raw_error = error

-- Таблица локальных копий
local safe_funcs = {
    warn = raw_warn,
    print = raw_print,
    error = raw_error,
}

-- Функция безопасного warn
local function safe_warn(msg)
    -- Если глобальный warn был заменён, используем локальный raw_warn
    if warn ~= safe_funcs.warn then
        safe_funcs.warn("Hook detected on warn! Using safe version.")
    end

    safe_funcs.warn(msg)
end

-- Переопределяем глобальный warn
warn = safe_warn

-- Циклическая проверка глобальных функций
task.spawn(function()
    while true do
        for name, func in pairs(safe_funcs) do
            -- Проверяем глобальную переменную и _G
            local global_func = rawget(_G, name)
            if global_func ~= func then
                func("Hook detected on "..name.."! Using safe version.")
            end
        end
        task.wait(0.5)
    end
end)

-- Пример использования
warn("Это сообщение через безопасный warn")

