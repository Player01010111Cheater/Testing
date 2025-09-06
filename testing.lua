local old = setclipboard

local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG] Hooked: " .. url)
    if string.find(url, "discord") and string.find(url, "webhook") or string.find(url, "start") then
        old(url)
        return {
            Success = false,
            StatusCode = 401,
            Body = "PIDORAS FUCK YOU."
        }
    end
    return oldRequestGet(req)
end))

local oldHttpGet
oldHttpGet = hookfunction(game.HttpGet, newcclosure(function (self, url, ...)
    print("[DEBUG] Hooked: " .. url)
    if string.find(url, "discord") and string.find(url, "webhook") or string.find(url, "start") then
        old(url)
        return {
            Success = false,
            StatusCode = 401,
            Body = "PIDORAS FUCK YOU."
        }
    end
    return oldHttpGet(self, url, ...)
end))

local oldHttpRequest
oldHttpRequest = hookfunction(http_request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG] Hooked: " .. url)
    if string.find(url, "discord") and string.find(url, "webhook") or string.find(url, "start") then
        old(url)
        return {
            Success = false,
            StatusCode = 401,
            Body = "PIDORAS FUCK YOU."
        }
    end
    return oldHttpRequest(req)
end))


hookfunction(setclipboard, newcclosure(function(data)
    if #data >= 50 and not string.find(data, "discord") then
        return
    else
        return old(data)
    end
end))

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == game.Players.LocalPlayer then
        -- проверка: если вызвано с клиента, блокируем
        if checkcaller() then
            return -- отменяем кик
        end
    end
    return old(self, ...)
end)

setreadonly(mt, true)
