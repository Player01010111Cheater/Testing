-- ⚠️ Безопасная эмуляция обхода Kick() через __namecall
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- Подмена warn (для тишины)
local realWarn = warn
warn = function(...) end

-- Хук на namecall для перехвата :Kick()
local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if tostring(self) == tostring(lp) and method == "Kick" then
        realWarn("[Кряк] Попытка кика была перехвачена (через :Kick).")
        return -- ничего не делаем
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Загружаем античит (если нужно)
-- loadstring(game:HttpGet("URL_ТВОЕГО_АНТИЧИТА"))()
print("Loading anticrack")
-- 4. Загружаем твой основной античит
loadstring(game:HttpGet("https://raw.githubusercontent.com/Player01010111Cheater/anticracker_LUA/refs/heads/main/anticrack.lua"))()


