for _, v in pairs(getgc(true)) do
    if typeof(v) == "function" then
        print(debug.getinfo(v, "n"))
    end
end
