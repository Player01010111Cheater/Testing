local blockedSites = {"httpbin", "ipinfo", "ip"}


local function getHost(url)
    return string.match(url:lower(), "^https?://([^/]+)") or url:lower()
end

local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    local host = getHost(url)

    for _, site in pairs(blockedSites) do
        if string.find(host, site:lower(), 1, true) then
            warn("[BLOCKED REQUEST] " .. url)
            return { Success = false, StatusCode = 403, Body = "Access denied" }
        end
    end

    return oldRequestGet(req)
end))


local oldHttpGet
oldHttpGet = hookfunction(game.HttpGet, newcclosure(function (self, url, ...)
    local host = getHost(url)

    for _, site in pairs(blockedSites) do
        if string.find(host, site:lower(), 1, true) then
            warn("[BLOCKED HTTPGET] " .. url)
            return "Access denied"
        end
    end

    return oldHttpGet(self, url, ...)
end))

