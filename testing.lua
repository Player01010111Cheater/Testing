local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    print("[DEBUG] Hooked: " .. url)
    if string.find(url, "work.ink") and string.find(url, "tokenValid") then
        return {
            Success = true,
            StatusCode = 200,
            Body = game:GetService("HttpService"):JSONEncode({
                valid = true,
            })
        }
    end
    return oldRequestGet(req)
end))
local plr = game:GetService("Players").LocalPlayer

getgenv().Anti = true

local Anti
Anti = hookmetamethod(game, "__namecall", function(self, ...)
        if self == plr and getnamecallmethod():lower() == "kick" and getgenv().Anti then
            return warn("[ANTI-KICK] Client Tried To Call Kick Function On LocalPlayer")
        end
        return Anti(self, ...)
    end)
-- Перехват setclipboard, чтобы ничего не делало
setclipboard = function(...)
    warn("Попытка вызвать setclipboard была заблокирована.")
end
