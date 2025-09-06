local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG] Hooked: " .. url)
    if string.find(url, "work.ink") and string.find(url, "tokenValid") then
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
    if string.find(url:lower(), "work.ink") and string.find(url:lower(), "tokenValid") then
        print(self)
        print(url)
        for _, v in pairs(...) do
            if typeof(v) == "function" then
                local info = debug.getupvalue(v, 1)
                print(info)
            end
        end
        return oldHttpGet(self, url, ...)
    end
    return oldHttpGet(self, url, ...)
end))

local oldHttpRequest
oldHttpRequest = hookfunction(http_request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG] Hooked: " .. url)
    if string.find(url, "work.ink") and string.find(url, "tokenValid") then
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


