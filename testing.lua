local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    print(req.Body)
    if string.find(url, "platoboost") and string.find(url, "key=") then
        return {
            Success = true,
            StatusCode = 200,
            Body = game:GetService("HttpService"):JSONEncode({
                success = true,
                data = {
                    valid = true,
                    hash = "82dha72jda72"
                }
            })
        }
    end
    return oldRequestGet(req)
end))
