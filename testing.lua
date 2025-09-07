local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG] Hooked: " .. url)
    if string.find(url:lower(), "work.ink") and string.find(url:lower(), "token")then
        return {
            Success = true,
            StatusCode = 200,
            Body = game:GetService("HttpService"):JSONEncode({
                valid = true,
            })
        }
    end
    return oldRequestGet(req)
end))

local oldHttpGet
oldHttpGet = hookfunction(game.HttpGet, newcclosure(function (self, url, ...)
    print("[DEBUG] Hooked: " .. url)
    if string.find(url:lower(), "work.ink") and string.find(url:lower(), "token")then
        return game:GetService("HttpService"):JSONEncode({ valid = true })
    end
    return oldHttpGet(self, url, ...)
end))

local oldHttpRequest
oldHttpRequest = hookfunction(http_request, newcclosure(function (req)
    local url = (req.Url or req.url or "")
    print("[DEBUG] Hooked: " .. url)
    if string.find(url:lower(), "work.ink") and string.find(url:lower(), "token") then
        return {
            Success = true,
            StatusCode = 200,
            Body = game:GetService("HttpService"):JSONEncode({
                valid = true,
            })
        }
    end
    return oldHttpRequest(req)
end))
