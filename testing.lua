local function advancedHookDetector()
    local original = setclipboard
    local originalSource = debug.info(original, "s") or ""
    local originalLines = debug.info(original, "L") or 0

    task.spawn(function()
        while task.wait(0.3) do
            local current = setclipboard
            
            -- Проверка source изменения
            local currentSource = debug.info(current, "s") or ""
            local currentLines = debug.info(current, "L") or 0
            
            if currentSource ~= originalSource or currentLines ~= originalLines then
                game.Players.LocalPlayer:Kick("Advanced hook detection triggered!")
                break
            end
            
            -- Проверка через pcall (если функция сломана)
            local success, result = pcall(function()
                return debug.info(current, "n")
            end)
            
            if not success then
                game.Players.LocalPlayer:Kick("Function integrity compromised!")
                break
            end
        end
    end)
end

advancedHookDetector()
