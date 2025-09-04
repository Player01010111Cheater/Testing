local oldRequestGet
oldRequestGet = hookfunction(request, newcclosure(function (req)
    local url = (req.Url or req.url or ""):lower()
    if string.find(url, "pandadevelopment.net") and string.find(url, "validate") then
        return {
            Success = true,
            StatusCode = 200,
            Body = game:GetService("HttpService"):JSONEncode({
                success = true
        })}
    end
    return oldRequestGet(req)
end))
