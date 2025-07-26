-- ⚠️ Эмуляция поведения читера (для защиты и тестов)

-- 1. Подменяем warn, чтобы защита молчала
local realWarn = warn
warn = function(...) end

-- 2. Подменяем Kick, но скрытно (через metatable)
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local oldKick = lp.Kick

-- Храним поддельную функцию
local fakeKick = function(self, ...)
    realWarn("[CRACK] Защита попыталась кикнуть, но мы перехватили вызов.")
    -- ничего не делаем — обход
end

-- 3. Устанавливаем metatable на игрока
local mt = getrawmetatable(lp)
setreadonly(mt, false)

local __namecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == lp and method == "Kick" then
        return fakeKick(self, ...)
    end
    return __namecall(self, ...)
end)

-- 4. Подменяем прямой вызов Kick (lp.Kick())
lp.Kick = fakeKick

-- 5. Подменяем debug.getinfo
local oldDebug = debug.getinfo
debug.getinfo = function(func)
    local info = oldDebug(func)
    if typeof(info) == "table" then
        info.source = "=[C]" -- маскируем даже подделку
    end
    return info
end

-- 6. Удаляем любые функции, содержащие слово "__bait"
for k, v in pairs(getfenv()) do
    if typeof(v) == "function" and debug.getinfo(v).source:find("__bait") then
        getfenv()[k] = nil
    end
end

-- 7. Запускаем основной скрипт
loadstring(game:HttpGet("https://raw.githubusercontent.com/Player01010111Cheater/anticracker_LUA/refs/heads/main/anticrack.lua"))()

