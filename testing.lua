local FunctionProtector = {}
FunctionProtector.__index = FunctionProtector

-- Создаем защищенную среду
local SecureEnvironment = {}
debug.setmetatable(SecureEnvironment, {
    __newindex = function(_, key, value)
        if key == "setclipboard" or key == "request" or key == "hookfunction" then
            warn("BLOCKED: Attempt to modify " .. key)
            return -- Блокируем изменение
        end
        rawset(SecureEnvironment, key, value)
    end
})

function FunctionProtector.new(targetFunction, functionName)
    local self = setmetatable({}, FunctionProtector)
    
    self.original = targetFunction
    self.name = functionName or "unknown"
    self.callCount = 0
    self.lastCall = 0
    
    -- Создаем защищенную функцию
    self.secureFunction = function(...)
        self.callCount += 1
        self.lastCall = tick()
        
        -- Логирование вызовов
        print(string.format("[%s] Call #%d: %s", 
            self.name, self.callCount, tostring(...)))
        
        return self.original(...)
    end
    
    -- Делаем функцию неизменяемой
    debug.setmetatable(self.secureFunction, {
        __newindex = function() error("Function is protected") end,
        __metatable = "locked"
    })
    
    return self
end

function FunctionProtector:protect()
    -- Заменяем глобальную функцию
    rawset(getgenv(), self.name, self.secureFunction)
    self:startGuard()
end

function FunctionProtector:startGuard()
    task.spawn(function()
        local originalHash = tostring(self.original):sub(1, 30)
        local secureHash = tostring(self.secureFunction):sub(1, 30)
        
        while task.wait(0.3) do
            -- Проверка 1: Сравнение ссылок
            if getgenv()[self.name] ~= self.secureFunction then
                self:detectTamper("Reference mismatch")
            end
            
            -- Проверка 2: Целостность оригинальной функции
            if tostring(self.original):sub(1, 30) ~= originalHash then
                self:detectTamper("Original function modified")
            end
            
            -- Проверка 3: Детектор hookfunction
            local success, info = pcall(function()
                return debug.info(self.original, "n")
            end)
            
            if not success then
                self:detectTamper("Function integrity compromised")
            end
        end
    end)
end

function FunctionProtector:detectTamper(reason)
    warn(string.format("TAMPER DETECTED [%s]: %s", self.name, reason))
    
    local player = game.Players.LocalPlayer
    if player then
        player:Kick(string.format("Security violation: %s tampered", self.name))
    end
    
    error("Security violation", 2)
end

-- Защита от hookfunction
if hookfunction then
    local originalHook = hookfunction
    hookfunction = function(target, hook)
        if target == setclipboard or target == request then
            warn("BLOCKED: hookfunction attempt on protected function")
            return target
        end
        return originalHook(target, hook)
    end
end

-- Использование:
local clipboardProtector = FunctionProtector.new(setclipboard, "setclipboard")
clipboardProtector:protect()

local requestProtector = FunctionProtector.new(request, "request") 
requestProtector:protect()

print("Function protection system activated!")
