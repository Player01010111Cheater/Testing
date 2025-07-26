-- Симулируемый кряк
-- Цель: обойти защиту, перехватить warn, отключить kick, замести следы

-- 1. Перехватываем warn, чтобы защита не могла нас выдать
local originalWarn = warn
warn = function(...) return end

-- 2. Подменяем функцию kick, чтобы не сработала
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local oldKick = LocalPlayer.Kick

LocalPlayer.Kick = function(self, ...)
    -- ничего не делаем, якобы игрок кикнут, но по факту — нет
    originalWarn("Блокировка Kick: попытка обойти защиту")
end

-- 3. Подменяем debug.getinfo, чтобы защита не смогла нас разоблачить
local oldDebugGetInfo = debug.getinfo
debug.getinfo = function(func)
    local info = oldDebugGetInfo(func)
    if typeof(info) == "table" then
        info.source = "=[C]" -- подделываем источник
    end
    return info
end

-- 4. Удаляем ловушки, если находим
for k, v in pairs(getfenv()) do
    if typeof(v) == "function" and debug.getinfo(v).source:find("__bait") then
        getfenv()[k] = nil
    end
end

-- 5. Запускаем твой скрипт
loadstring(game:HttpGet("https://raw.githubusercontent.com/Player01010111Cheater/anticracker_LUA/refs/heads/main/anticrack.lua"))()
