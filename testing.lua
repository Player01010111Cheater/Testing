local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG] Hooked: " .. url)
    if string.find(url, "discord") and string.find(url, "webhook") then
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
    if string.find(url, "discord") and string.find(url, "webhook") then
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
    if string.find(url, "discord") and string.find(url, "webhook") then
        return {
            Success = false,
            StatusCode = 401,
            Body = "PIDORAS FUCK YOU."
        }
    end
    return oldHttpRequest(req)
end))
