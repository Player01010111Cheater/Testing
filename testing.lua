print("Protecting setclipboard from hookfunction...")

-- Сохраняем оригинал в нескольких местах
local OriginalSetClipboard = setclipboard
local _BACKUP_REF = setclipboard

-- Создаем нашу защищенную функцию
local function ProtectedSetClipboard(text)
    print("Clipboard set (protected):", text)
    return OriginalSetClipboard(text)
end

-- Применяем защиту через hookfunction ПЕРВЫМ
if hookfunction then
    -- Мы сами хукаем функцию чтобы защитить ее
    local SecureHook = hookfunction(OriginalSetClipboard, function(...)
        print("Clipboard call intercepted:", ...)
        return OriginalSetClipboard(...)
    end)
    
    getgenv().setclipboard = SecureHook
else
    getgenv().setclipboard = ProtectedSetClipboard
end

-- Система обнаружения хуков через детектор изменений
task.spawn(function()
    local lastHash = tostring(OriginalSetClipboard):sub(1, 50)
    
    while task.wait(0.3) do
        -- Проверяем не был ли hookfunction применен к оригиналу
        local currentHash = tostring(OriginalSetClipboard):sub(1, 50)
        
        if currentHash ~= lastHash then
            warn("HOOKFUNCTION DETECTED! Hash changed")
            local player = game.Players.LocalPlayer
            if player then
                player:Kick("Memory tampering detected!")
            end
            break
        end
        
        -- Дополнительная проверка через тестовый вызов
        local success, result = pcall(function()
            return debug.info(OriginalSetClipboard, "s")
        end)
        
        if not success then
            warn("Function integrity compromised")
            break
        end
    end
end)

print("Advanced protection active!")
