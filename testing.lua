print("ada")
local blockedSites = {"httpbin", "ipinfo", "ip"}
print("Loaded Block Http.")
local reqfunc = (syn or http).request
print("Connected: request")
local hook = hookfunction(reqfunc, function(req)
    local url = req.Url or req.url or ""
    url = url:lower()
    for _, site in ipairs(blockedSites) do
		print(url)
        if string.find(url, site:lower()) then
			print("Blocked Url: " .. url)
            return { Success = false, StatusCode = 403, Body = "Access denied" }
		elseif string.find(url, "discord.com/api/webhooks") then
			print("Blocker Url: " .. url)
			print("Url Body: ".. req.Body) 
			print("Headers:", req.Headers or "nil")
			return { Success = false, StatusCode = 403, Body = "Access denied" }
        end
    end
-- ra
    return hook(req)
end)

print("Connected: game.HttpGet")
local originalHttpGet = game.HttpGet
-- dakjdakldakDHAHDAJD
local HttpGetHook
HttpGetHook = hookfunction(originalHttpGet, function(self, url, ...)
    if url == nil then return "" end  -- безопасный возврат для nil
    local lowerUrl = tostring(url):lower()

    -- Логирование
    print("HttpGet called:", url)
    local args = {...}
    for i, v in ipairs(args) do
        print("Arg", i, v)
    end

    -- Вызов оригинальной функции с URL и всеми дополнительными аргументами
    return originalHttpGet(self, url, ...)
end)
