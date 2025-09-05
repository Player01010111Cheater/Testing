local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    if string.find(url, "luarmor.net") and string.find(url, "check_key") then
        return {
            Success = true,
            StatusCode = 200,
            Body = game:GetService("HttpService"):JSONEncode({
                code = "KEY_VALID",
            })
        }
    end
    return oldRequestGet(req)
end))
