
for _, obj in ipairs(gethui():GetChildren()) do
    if obj.ClassName == "ScreenGui" then
        print(obj.Name)
    else
        print("not: " .. obj.Name)
    end
end


local screen = Instance.new("ScreenGui", game.CoreGui)
screen.Name = "WindUI"
local textlabel = Instance.new("TextLabel", screen)
textlabel.Text = "http"
textlabel.Size = Vector2.new(30, 0, 30, 0)
