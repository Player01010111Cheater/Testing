local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    if string.find(url, "https://neoxsoftworks.eu") then
        print("[DEBUG] KeySystem Hooked")
        return {
            Success = true, -- исправлено
            StatusCode = 200,
            Body = game:GetService("HttpService"):JSONEncode({
                valid = true,
            })
        }
    end
    return oldRequestGet(req)
end))

