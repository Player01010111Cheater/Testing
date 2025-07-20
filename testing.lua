local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimerAndFPSGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
MainFrame.Position = UDim2.new(0, 10, 1, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
TimerLabel.Position = UDim2.new(0.1, 0, 0, 5)
TimerLabel.BackgroundTransparency = 1
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.TextScaled = true
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.Text = "00:00"
TimerLabel.Parent = MainFrame

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
FPSLabel.Position = UDim2.new(0.6, 0, 0, 5)
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSLabel.TextScaled = true
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.Text = "FPS: 60"
FPSLabel.Parent = MainFrame

local TimerIcon = Instance.new("ImageLabel")
TimerIcon.Size = UDim2.new(0.1, 0, 0.5, 0)
TimerIcon.Position = UDim2.new(0, 5, 0, 5)
TimerIcon.BackgroundTransparency = 1
TimerIcon.Image = "rbxassetid://10709752630" -- Замените на ваш rbxassetid для иконки таймера
TimerIcon.Parent = MainFrame

local FPSIcon = Instance.new("ImageLabel")
FPSIcon.Size = UDim2.new(0.1, 0, 0.5, 0)
FPSIcon.Position = UDim2.new(0.5, 0, 0, 5)
FPSIcon.BackgroundTransparency = 1
FPSIcon.Image = "rbxassetid://10747382504" -- Замените на ваш rbxassetid для иконки FPS
FPSIcon.Parent = MainFrame

local function getTime()
    -- Здесь ваша функция получения времени
    -- Пример: возвращает время в формате MM:SS
    local totalSeconds = math.floor(tick() % 3600)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    TimerLabel.Text = getTime()
    FPSLabel.Text = "FPS: " .. math.floor(1 / deltaTime)
end)
