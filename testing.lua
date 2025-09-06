local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    if string.find(url, "platoboost") and string.find(url, "key=") then
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
