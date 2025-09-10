print("Protecting setclipboard...")

-- Оригинал
local OriginalSetClipboard = setclipboard

-- Защищённая функция
local SafeSetClipboard = newcclosure(function(text)
    print("Clipboard set:", text)
    return OriginalSetClipboard(text)
end)

-- Подменяем глобал
getgenv().setclipboard = SafeSetClipboard

-- Мониторинг (сторож)
spawn(function()
    while true do
        if setclipboard ~= SafeSetClipboard then
            warn("Tamper detected on setclipboard!")
            local player = game.Players.LocalPlayer
            if player then
                player:Kick("Tamper detected! Clipboard hook attempt!")
            end
            break
        end
        wait(1)
    end
end)


