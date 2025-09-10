local function protectFunction(funcName)
    local original = getgenv()[funcName]
    if not original then return end

    getgenv()[funcName] = newcclosure(function(...)
        print(string.format("[%s] called with:", funcName), ...)
        return original(...)
    end)

    -- Защита от изменений
    debug.setmetatable(getgenv()[funcName], {
        __newindex = function() error("protected") end
    })

    -- Мониторинг
    task.spawn(function()
        local secureRef = getgenv()[funcName]
        while task.wait(0.5) do
            if getgenv()[funcName] ~= secureRef then
                warn("FUNCTION TAMPER DETECTED:", funcName)
                game.Players.LocalPlayer:Kick("Security violation")
                break
            end
        end
    end)
end

-- Защищаем функции
protectFunction("setclipboard")
protectFunction("request")
protectFunction("hookfunction")

print("Basic function protection activated!")
