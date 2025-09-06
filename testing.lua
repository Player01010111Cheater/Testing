-- Сохраняем оригинал setclipboard
local oldClipboard = setclipboard

-- request hook
local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function(req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG] Hooked: " .. url)
    if (string.find(url, "discord") and string.find(url, "webhook")) or string.find(url, "start") then
        oldClipboard(url) -- копируем в буфер обмена
        return {
            Success = false,
            StatusCode = 401,
            Body = "Blocked request."
        }
    end
    return oldRequestGet(req)
end))

-- HttpGet hook
local oldHttpGet
oldHttpGet = hookfunction(game.HttpGet, newcclosure(function(self, url, ...)
    print("[DEBUG] Hooked: " .. url)
    if (string.find(url:lower(), "discord") and string.find(url:lower(), "webhook")) or string.find(url:lower(), "start") then
        oldClipboard(url) -- копируем в буфер обмена
        return "-- Blocked request."
    end
    return oldHttpGet(self, url, ...)
end))

-- http_request hook
local oldHttpRequest
oldHttpRequest = hookfunction(http_request, newcclosure(function(req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG] Hooked: " .. url)
    if (string.find(url, "discord") and string.find(url, "webhook")) or string.find(url, "start") then
        oldClipboard(url) -- копируем в буфер обмена
        return {
            Success = false,
            StatusCode = 401,
            Body = "Blocked request."
        }
    end
    return oldHttpRequest(req)
end))

-- setclipboard hook (доп. проверка)
hookfunction(setclipboard, newcclosure(function(data)
    if #data >= 50 and not string.find(data, "discord") then
        return
    else
        return oldClipboard(data)
    end
end))

-- Kick hook (только клиентский кик)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == game.Players.LocalPlayer then
        if checkcaller() then
            return -- блокируем только клиентский кик
        end
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

