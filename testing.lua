local blockedSites = {"httpbin", "ipinfo", "ip"}
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
        local pattern = "%f[%a]" .. site:lower()
        if string.find(url, pattern, 1, true) then
            warn("[BLOCKED REQUEST] " .. url)
            notify("[BLOCKED REQUEST] " .. url)
            return { Success = false, StatusCode = 403, Body = "Access denied" }
        end
    end

    return oldRequestGet(req)
end))


local oldHttpGet
oldHttpGet = hookfunction(game.HttpGet, newcclosure(function (self, url, ...)
    for _, site in pairs(blockedSites) do
        local pattern = "([^%w])" .. site:lower()
        if string.find(site:lower(), pattern) or string.sub(site:lower(), 1, #site) == site then
            warn("[BLOCKED HTTPGET] " .. url)
            notify("[BLOCKED HTTPGET] " .. url)
            return "Access denied"
        end
    end
    return oldHttpGet(self, url , ...)
end))


