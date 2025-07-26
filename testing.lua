local function CheckForCrackModules()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer or nil

    local function kick(reason)
        if player and player.Kick then
            player:Kick("Anticrack: detected module \"" .. reason .. "\"")
        else
            error("Anticrack: detected module \"" .. reason .. "\"")
        end
    end

    -- Подозрительные debug-функции
    local dangerousDebugFuncs = {
        "getinfo",
        "getupvalue",
        "getlocal",
        "getregistry",
        "sethook",
        "gethook",
        "traceback",
        "getmetatable",
        "setmetatable",
        "setupvalue",
        "upvalueid",
        "upvaluejoin",
    }

    -- Глобальные executor-функции
    local globalFuncs = {
        "getgc", "getreg", "getupvalues", "getconstants",
        "getnilinstances", "islclosure", "is_synapse_function",
        "hookfunction", "setreadonly", "getconnections"
    }

    -- Проверка debug
    for _, funcName in ipairs(dangerousDebugFuncs) do
        local func = rawget(debug, funcName)
        if typeof(func) == "function" then
            kick("debug." .. funcName)
        end
    end

    -- Проверка глобальных функций executors
    for _, funcName in ipairs(globalFuncs) do
        if typeof(getfenv()[funcName]) == "function" then
            kick(funcName)
        end
    end
end
CheckForCrackModules()
