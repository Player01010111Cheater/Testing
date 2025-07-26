-- 🔧 Обход защиты Kick и маскировка для теста античита

-- 1. Подменяем warn
local realWarn = warn
warn = function(...) end

-- 2. Подменяем Kick напрямую
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

lp.Kick = function(self, ...)
    realWarn("[Кряк] Попытка кика была перехвачена.")
end

-- 3. Подменяем debug.getinfo (чтобы защита не узнала про подмену)
local oldDebug = debug.getinfo
debug.getinfo = function(func)
    local info = oldDebug(func)
    if typeof(info) == "table" then
        info.source = "=[C]" -- делаем вид, что это C-функция
    end
    return info
end

-- 4. Загружаем твой основной античит
loadstring(game:HttpGet("https://raw.githubusercontent.com/Player01010111Cheater/anticracker_LUA/refs/heads/main/anticrack.lua"))()


