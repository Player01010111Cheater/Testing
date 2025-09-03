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
local originalHttpGet = game.HttpGet  -- сохраняем оригинальную функцию

local HttpGetHook
HttpGetHook = hookfunction(originalHttpGet, function(self, url, ...)
    local lowerUrl = tostring(url):lower()

    -- Блокировка по подстроке
    for _, site in ipairs(blockedSites) do
        if string.find(lowerUrl, site:lower()) then
            print("Blocked url: " .. url)
            return "Access denied"  -- возвращаем строку, чтобы скрипт не падал
        end
    end

    -- Логирование (можно убрать)
    print("HttpGet called:", url)
    local args = {...}
    for i, v in ipairs(args) do
        print("Arg", i, v)
    end

    -- Вызов оригинальной функции с безопасной обработкой любых аргументов
    if select("#", ...) > 0 then
        return originalHttpGet(self, url, unpack(args))
    else
        return originalHttpGet(self, ...)
    end
end)
