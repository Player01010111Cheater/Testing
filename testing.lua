print("Protecting setclipboard...")

-- Сохраняем оригинальную функцию ДО любых манипуляций
local OriginalSetClipboard = setclipboard

-- Делаем защищённую версию
local SafeSetClipboard = newcclosure(function(text)
    print("Clipboard set:", text)
    return OriginalSetClipboard(text)
end)

-- Подменяем глобал
rawset(getgenv(), "setclipboard", SafeSetClipboard)

-- Сторож - проверяем через оригинальную ссылку
task.spawn(function()
    while task.wait(1) do
        -- Правильная проверка: сравниваем с ожидаемой защищённой функцией
        if getgenv().setclipboard ~= SafeSetClipboard then
            warn("Tamper detected on setclipboard!")
            local player = game.Players.LocalPlayer
            if player then
                player:Kick("Tamper detected! Clipboard hook attempt!")
            end
            break
        end
    end
end)

