local originalError = error
local safeError = function(message, level)
    if _G.error ~= originalError then
        warn("Обнаружена подмена функции error!")
        return
    end
    originalError(message, level)
end
_G.error = safeError

setmetatable(_G, {
    __newindex = function(t, k, v)
        if k == "error" then
            warn("Попытка изменить функцию error!")
        end
        rawset(t, k, v)
    end
})
