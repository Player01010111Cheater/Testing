print("Protecting setclipboard...")

print("Protecting setclipboard...")

-- Берём то, что реально есть у экзекутора (даже если уже обёрнуто)
local CurrentClipboard = setclipboard

-- Делаем защищённую версию
local SafeSetClipboard = newcclosure(function(text)
    print("Clipboard set:", text)
    return CurrentClipboard(text)
end)

-- Подменяем глобал
rawset(getgenv(), "setclipboard", SafeSetClipboard)

-- Сторож
task.spawn(function()
    while task.wait(1) do
        -- Проверяем только на нашу обёртку
        if setclipboard ~= SafeSetClipboard then
            warn("Tamper detected on setclipboard!")
            local player = game.Players.LocalPlayer
            if player then
                player:Kick("Tamper detected! Clipboard hook attempt!")
            end
            break
        end
    end
end)

