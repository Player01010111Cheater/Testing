local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- Сохраняем оригинальный namecall
local mt = getrawmetatable(game)
setreadonly(mt, false)

local __namecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == lp and method == "Kick" then
        warn("[Кряк] Попытка кика была перехвачена.")
        return -- ничего не делаем
    end
    return __namecall(self, ...)
end)

setreadonly(mt, true)

-- 4. Загружаем твой основной античит
loadstring(game:HttpGet("https://raw.githubusercontent.com/Player01010111Cheater/anticracker_LUA/refs/heads/main/anticrack.lua"))()


