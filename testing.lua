print("🔒 Loading ultimate setclipboard protection...")

-- 1. СОХРАНИТЬ ОРИГИНАЛЫ ДО ВСЕГО
local _RealSetClipboard = setclipboard
local _RealHookFunction = hookfunction

-- 2. ПОЛНОЕ ОТКЛЮЧЕНИЕ HOOKFUNCTION
if _RealHookFunction then
    hookfunction = function(target, hook)
        warn("⛔ hookfunction DISABLED by security system")
        return target -- Всегда возвращаем оригинал
    end
    
    -- Делаем защиту неизменяемой
    debug.setmetatable(hookfunction, {
        __newindex = function() 
            error("hookfunction protection is locked") 
        end,
        __metatable = "locked"
    })
end

-- 3. ПЕРЕХВАТЫВАЕМ ФУНКЦИЮ ПЕРВЫМИ
if _RealHookFunction then
    local secureHook = _RealHookFunction(_RealSetClipboard, function(text)
        print("🔒 Secure clipboard:", text)
        return _RealSetClipboard(text)
    end)
    
    getgenv().setclipboard = secureHook
else
    getgenv().setclipboard = function(text)
        print("🔒 Secure clipboard:", text)
        return _RealSetClipboard(text)
    end
end

-- 4. ЗАЩИТА ОТ ИЗМЕНЕНИЙ
debug.setmetatable(getgenv(), {
    __newindex = function(t, k, v)
        if k == "setclipboard" then
            warn("🚫 Attempt to modify setclipboard blocked!")
            return
        end
        rawset(t, k, v)
    end
})

-- 5. ДЕТЕКТОР ЦЕЛОСТНОСТИ ПАМЯТИ
task.spawn(function()
    local originalHash = tostring(_RealSetClipboard):sub(1, 60)
    
    while true do
        task.wait(0.3)
        
        -- Проверяем не изменился ли оригинал в памяти
        if tostring(_RealSetClipboard):sub(1, 60) ~= originalHash then
            warn("🚨 MEMORY TAMPERING DETECTED!")
            game.Players.LocalPlayer:Kick("Security violation: memory tampering")
            break
        end
    end
end)

print("✅ Ultimate protection activated - hookfunction IMPOSSIBLE")
