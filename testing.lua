-- Создание GUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Ptx",
    Folder = "ada",
    Size = UDim2.fromOffset(580, 350),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    -- Background = "", -- rbxassetid only
    -- BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            -- Тут логика
        end,
    },

})
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Создание кнопки
local button = Instance.new("TextButton")
button.Name = "CenterButton"
button.Size = UDim2.new(0, 150, 0, 50) -- ширина 150px, высота 50px
button.Position = UDim2.new(0.5, 80, 0.5, -25) -- немного правее центра (по X)
button.AnchorPoint = Vector2.new(0.5, 0.5) -- центрирование по центру кнопки
button.Text = "Click me for open"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSans
button.TextSize = 24
button.Parent = ScreenGui

-- Обработка нажатия
button.MouseButton1Click:Connect(function()
	Window:Open()
end)
