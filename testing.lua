local blockedSites = {
	"httpbin", "ipinfo"
}

local originalRequest = request

request = function(req)
    local url = req.Url or req.url or ""
    
    for _, site in ipairs(blockedSites) do
        if string.find(url, site) then
            return {
                Success = false,
                StatusCode = 403,
                Body = "Access denied"
            }
        end
    end
    
    return originalRequest(req)
end
