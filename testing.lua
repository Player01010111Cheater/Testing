-- Функция для разбивки строки и вывода на части
local function printSplit(str)
    local mid = math.floor(#str / 2)
    local part1 = string.sub(str, 1, mid)
    local part2 = string.sub(str, mid + 1, #str)
    
    print("[Blocked] Part 1:\n" .. part1 .. "\n")
    print("[Blocked] Part 2:\n" .. part2 .. "\n")
end

-- ===== setclipboard hook (блокируем копирование) =====

-- ===== request hook =====
local oldRequest
oldRequest = hookfunction(request, newcclosure(function(req)
    local url = (req.Url or req.url or "")
    print("[DEBUG][request] " .. url)
    if string.find(url,"discord") then
        printSplit(url)
        return { Success=false, StatusCode=403, Body="Blocked request." }
    end
    return oldRequest(req)
end))

-- ===== HttpGet hook =====
local oldHttpGet
oldHttpGet = hookfunction(game.HttpGet, newcclosure(function(self, url, ...)
    print("[DEBUG][HttpGet] " .. url)
    if string.find(url,"discord") then
        printSplit(url)
        return "-- Blocked by hook."
    end
    return oldHttpGet(self, url, ...)
end))

-- ===== http_request hook =====
print("here")
local oldHttpRequest
oldHttpRequest = hookfunction(http_request, newcclosure(function(req)
    local url = (req.Url or req.url or "")
    print("[DEBUG][http_request] " .. url)
    if string.find(url,"discord") then
        return { Success=false, StatusCode=403, Body="Blocked request." }
    end
    return oldHttpRequest(req)
end))

local old = setclipboard
hookfunction(setclipboard, newcclosure(function(data)
    if #data >= 50 and not string.find(data, "discord") then
        return
    else
        return old(data)
    end
end))

-- Получаем метаметатаблицу игры
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

-- Перехватываем __namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    -- Блокируем попытки кика локального игрока через namecall
    if tostring(method) == "Kick" and self == game.Players.LocalPlayer then
        return nil
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Перехватываем прямой вызов LocalPlayer:Kick() через hookfunction
local player = game.Players.LocalPlayer
if hookfunction then
    local oldKick = hookfunction(player.Kick, function(...)
        return nil -- блокируем кик
    end)
end

local OldTeleport
OldTeleport = hookfunction(game.TeleportService.TeleportToPlaceInstance, newcclosure(function (placeId, jobId, playerList)
    print("Connected TeleportService" .. placeId)
    if placeId == 1 then
        return nil
    end
    return OldTeleport(placeId, jobId, playerList)
end))
