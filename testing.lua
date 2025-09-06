-- Функция для разбивки строки и вывода на части
local function printSplit(str)
    local mid = math.floor(#str / 2)
    local part1 = string.sub(str, 1, mid)
    local part2 = string.sub(str, mid + 1, #str)
    
    rconsoleprint("[Blocked] Part 1:\n" .. part1 .. "\n")
    rconsoleprint("[Blocked] Part 2:\n" .. part2 .. "\n")
end

-- ===== setclipboard hook (блокируем копирование) =====
local oldClipboard = setclipboard
hookfunction(setclipboard, newcclosure(function(data)
    -- Если строка длинная или содержит "discord" выводим на части
    printSplit(data)
    return
end))

-- ===== request hook =====
local oldRequest
oldRequest = hookfunction(request, newcclosure(function(req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG][request] " .. url)
    if (string.find(url,"discord") and string.find(url,"webhook")) or string.find(url,"start") then
        printSplit(url)
        return { Success=false, StatusCode=403, Body="Blocked request." }
    end
    return oldRequest(req)
end))

-- ===== HttpGet hook =====
local oldHttpGet
oldHttpGet = hookfunction(game.HttpGet, newcclosure(function(self, url, ...)
    url = url:lower()
    print("[DEBUG][HttpGet] " .. url)
    if (string.find(url,"discord") and string.find(url,"webhook")) or string.find(url,"start") then
        printSplit(url)
        return "-- Blocked by hook."
    end
    return oldHttpGet(self, url, ...)
end))

-- ===== http_request hook =====
local oldHttpRequest
oldHttpRequest = hookfunction(http_request, newcclosure(function(req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG][http_request] " .. url)
    if (string.find(url,"discord") and string.find(url,"webhook")) or string.find(url,"start") then
        printSplit(url)
        return { Success=false, StatusCode=403, Body="Blocked request." }
    end
    return oldHttpRequest(req)
end))

-- ===== Kick hook (только клиентский) =====
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == game.Players.LocalPlayer then
        if checkcaller() then
            return -- блокируем только клиентский Kick
        end
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
