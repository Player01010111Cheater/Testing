local HttpService = game:GetService("HttpService")

-- список целевых функций (только KRNL)
local targets = {
    ["request"] = request,
    ["http_request"] = http_request,
    ["krnl.request"] = krnl and krnl.request,
    ["game.HttpGet"] = game.HttpGet,
    ["game.HttpPost"] = game.HttpPost
}

-- универсальный хук
local function hookHttp(name, func)
    if typeof(func) == "function" then
        local old
        old = hookfunction(func, newcclosure(function(self, urlOrReq, ...)
            local url = typeof(urlOrReq) == "table" and (urlOrReq.Url or urlOrReq.url) or urlOrReq
            url = tostring(url):lower()

            print(("[KRNL DEBUG][%s] Hooked: %s"):format(name, url))

            -- фильтр по work.ink/tokenValid
            if string.find(url, "work.ink") and string.find(url, "tokenvalid") then
                return {
                    Success = true,
                    StatusCode = 200,
                    Body = HttpService:JSONEncode({ valid = true })
                }
            end

            return old(self, urlOrReq, ...)
        end)))
    end
end

-- применяем хуки
for name, func in pairs(targets) do
    hookHttp(name, func)
end

