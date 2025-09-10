print("Advanced clipboard protection...")

local _ORIGINAL = setclipboard
local _CALLS = 0

-- Полный контроль над всеми вызовами
getgenv().setclipboard = newcclosure(function(text)
    _CALLS += 1
    
    -- Логируем все вызовы
    print(string.format("Clipboard call #%d: %s", _CALLS, text))
    
    -- Можно добавить фильтрацию
    if text:find("malicious") then
        warn("Blocked malicious clipboard content!")
        return
    end
    
    -- Вызываем оригинал
    return _ORIGINAL(text)
end)

-- Защита от удаления/замены
local SECURE_ENV = getgenv()
debug.setmetatable(SECURE_ENV, {
    __newindex = function(t, k, v)
        if k == "setclipboard" then
            warn("Clipboard protection: Modification blocked!")
            return
        end
        rawset(t, k, v)
    end
})

print("Clipboard protection active!")
