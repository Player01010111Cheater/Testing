local blockedSites = {"httpbin", "ipinfo", "ip"}

local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()

    for _, site in pairs(blockedSites) do
        if string.find(url, site:lower(), 1, true) then
            warn("[BLOCKED REQUEST] " .. url)
            return { Success = false, StatusCode = 403, Body = "Access denied" }
        end
    end

    return oldRequestGet(req)
end))


local oldHttpGet
oldHttpGet = hookfunction(game.HttpGet, newcclosure(function (self, url, ...)
    for _, site in pairs(blockedSites) do
        if string.find(url, site:lower(), 1 , true) then
            warn("[BLOCKED HTTPGET] " .. url)
            return "Access denied"
        end
    end
    return oldHttpGet(self, url , ...)
end))
