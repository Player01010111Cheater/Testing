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
    return hook(req)
end)
local originalHttpGet = game.HttpGet
print("Connected: game.HttpGet")
-- Перехватываем вызов
hookfunction(originalHttpGet, function(self, url, ...)
    local lowerUrl = tostring(url):lower()
    
    for _, site in ipairs(blockedSites) do
        if string.find(lowerUrl, site:lower()) and not string.find(lowerUrl, "https://raw.github") and not not string.find(lowerUrl, "https://pastefy.app") then
			print("Blocked url: " .. url)
			print("Url Body: ".. req.Body or "nil") 
			print("Headers:", req.Headers or "nil")
            return 'print("hello world")'
        end
    end
	if select("#", ...) > 0 then
	    return originalHttpGet(self, url, ...)
	else
	    return originalHttpGet(self, url)
	end

end)
