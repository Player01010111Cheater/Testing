local blockedSites = {"httpbin", "ipinfo", "ip", "webhooks"}
print("Loaded Block Http.")
local reqfunc = (syn or http).request
local hook = hookfunction(reqfunc, function(req)
	print(req)
    local url = req.Url or req.url or ""
    url = url:lower()
    for _, site in ipairs(blockedSites) do
		print(url)
        if string.find(url, site:lower()) then
			print("founded....")
            return { Success = false, StatusCode = 403, Body = "Access denied" }
        end
    end
    return hook(req)
end)
