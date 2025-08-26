
for _, obj in ipairs(gethui():GetDescendants()) do
    if obj.ClassName == "ScreenGui" then
        print(obj.Name)
    end
end
