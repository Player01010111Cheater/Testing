
for _, obj in ipairs(gethui():GetChildren()) do
    if obj.ClassName == "ScreenGui" then
        print(obj.Name)
    else
        print("not: " .. obj.Name)
    end
end
