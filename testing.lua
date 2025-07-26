local function CheckForCrackModules()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer or nil

    local function kick(reason)
        if player and player.Kick then
            player:Kick("АнтиКряк: найден модуль \"" .. reason .. "\"")
        else
            error("АнтиКряк: найден модуль \"" .. reason .. "\"")
        end
    end

    local dangerousDebugFuncs = {
        "getinfo", "getupvalue", "getlocal", "getregistry",
        "sethook", "gethook", "traceback",
        "getmetatable", "setmetatable", "setupvalue",
        "upvalueid", "upvaluejoin",
    }

    local globalFuncs = {
        "getgc", "getreg", "getupvalues", "getconstants",
        "getnilinstances", "islclosure", "is_synapse_function",
        "hookfunction", "setreadonly", "getconnections"
    }

    -- Проверка debug-модуля
    for _, funcName in ipairs(dangerousDebugFuncs) do
        local func = rawget(debug, funcName)
        if typeof(func) == "function" then
            local info = debug.getinfo(func)
            if info and info.source ~= "=[C]" then
                kick("debug." .. funcName)
            end
        end
    end

    -- Проверка глобальных функций executors
    for _, funcName in ipairs(globalFuncs) do
        local func = getfenv()[funcName]
        if typeof(func) == "function" then
            local ok, isLuaClosure = pcall(function() return islclosure(func) end)
            if ok and isLuaClosure then
                -- Это Lua-функция, вероятно вставлена executor'ом
                kick(funcName)
            else
                -- Дополнительная проверка через debug.getinfo
                local info = debug.getinfo(func)
                if info and info.source and info.source ~= "=[C]" then
                    kick(funcName)
                end
            end
        end
    end
end

CheckForCrackModules()
