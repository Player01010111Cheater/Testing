print("Protecting setclipboard...")

-- Берём рабочую версию из окружения
local ExecutorSetClipboard = setclipboard

-- Делаем защищённую обёртку
local SafeSetClipboard = newcclosure(function(text)
    print("Clipboard set:", text)
    return ExecutorSetClipboard(text)
end)

-- Подменяем глобал (единожды)
getgenv().setclipboard = SafeSetClipboard

-- Сторож
task.spawn(function()
    while task.wait(1) do
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



