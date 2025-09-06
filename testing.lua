local HttpService = game:GetService("HttpService")
local targets = {}

if request then targets.request = request end
if http_request then targets.http_request = http_request end
if krnl and krnl.request then targets.krnl_request = krnl.request end
if game.HttpGet then targets.HttpGet = game.HttpGet end
if game.HttpPost then targets.HttpPost = game.HttpPost end
print("na errors")
local function hookHttp(name, func)
    local old = hookfunction(func, newcclosure(function(self, urlOrReq, ...)
        local url = typeof(urlOrReq) == "table" and (urlOrReq.Url or urlOrReq.url) or urlOrReq
        url = tostring(url):lower()
        print("[KRNL DEBUG]["..name.."] Hooked: "..url)

        if string.find(url, "work.ink") and string.find(url, "tokenvalid") then
            return { Success = true, StatusCode = 200, Body = HttpService:JSONEncode({ valid = true }) }
        end

        return old(self, urlOrReq, ...)
    end))
end

for name, func in pairs(targets) do
    if typeof(func) == "function" then
        hookHttp(name, func)
    end
end


