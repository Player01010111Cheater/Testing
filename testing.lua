local blockedSites = {"httpbin", "ipinfo", "ipify"}
local library = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local function notify(text)
    library:Notify({
        Title = "Http Blocker",
        Content = text,
        Icon = "info",
        Duration = 3,
    }) 
end

local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()

    for _, site in pairs(blockedSites) do
        if string.find(url, site:lower(), 1, true) then
            warn("[BLOCKED REQUEST] " .. url)
            notify("[BLOCKED REQUEST] " .. url)
            return { Success = false, StatusCode = 403, Body = "Access denied" }
        end
    end

    return oldRequestGet(req)
end))


local oldHttpGet
oldHttpGet = hookfunction(game.HttpGet, newcclosure(function(self, url, ...)
    local prefixes = {"https://", "http://"}
    for _, prefix in pairs(prefixes) do
        for _, site in pairs(blockedSites) do
            -- Проверяем, начинается ли url с prefix и содержит ли site после prefix
            if url:lower():sub(1, #prefix) == prefix and string.match(url:lower(), "^" .. prefix .. site:lower()) then
                warn("[BLOCKED HTTPGET] " .. url)
                notify("[BLOCKED HTTPGET] " .. url)
                return "Access denied"
            end
        end
    end
    return oldHttpGet(self, url, ...)
end))
