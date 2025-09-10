local originalError = error
local safeError = newcclosure(function(message, level)
    local env = getfenv(1)
    if env.error ~= safeError or getrawmetatable(_G).__index.error ~= safeError then
        warn("Обнаружена подмена функции error!")
        return
    end
    originalError(message, level)
end)

setmetatable(_G, {
    __newindex = function(t, k, v)
        if k == "error" then
            warn("Попытка изменить error в _G!")
            return
        end
        rawset(t, k, v)
    end,
    __index = function(t, k)
        if k == "error" then
            return safeError
        end
        return rawget(t, k)
    end
})

_G.error = safeError
