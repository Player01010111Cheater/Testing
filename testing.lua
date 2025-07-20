local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimerAndFPSGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.21, 0, 0.12, 0)
MainFrame.Position = UDim2.new(0, 7, 1, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainFrame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
TimerLabel.Position = UDim2.new(0.14, 0, 0, 5)
TimerLabel.BackgroundTransparency = 1
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.TextSize = 17
TimerLabel.TextScaled = false
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.Text = "00:00"
TimerLabel.Parent = MainFrame

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
FPSLabel.Position = UDim2.new(0.64, 0, 0, 5)
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSLabel.TextSize = 17
FPSLabel.TextScaled = false
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.Text = "60"
FPSLabel.Parent = MainFrame

local TimerIcon = Instance.new("ImageLabel")
TimerIcon.Size = UDim2.new(0.1, 0, 0.5, 0)
TimerIcon.Position = UDim2.new(0.08, 0, 0, 5)
TimerIcon.BackgroundTransparency = 1
TimerIcon.Image = "rbxassetid://10709752630"
TimerIcon.Parent = MainFrame

local TimerIconAspect = Instance.new("UIAspectRatioConstraint")
TimerIconAspect.AspectRatio = 1
TimerIconAspect.Parent = TimerIcon

local FPSIcon = Instance.new("ImageLabel")
FPSIcon.Size = UDim2.new(0.1, 0, 0, 10)
FPSIcon.Position = UDim2.new(0.57, 0, 0, 10)
FPSIcon.BackgroundTransparency = 1
FPSIcon.Image = "rbxassetid://15269177520" -- Обновленный ID
FPSIcon.Parent = MainFrame

local FPSIconAspect = Instance.new("UIAspectRatioConstraint")
FPSIconAspect.AspectRatio = 1
FPSIconAspect.Parent = FPSIcon

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0.01, 0, 0.7, 0)
Divider.Position = UDim2.new(0.5, 0, 0.15, 0)
Divider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

local function getTime()
    -- Здесь ваша функция получения времени
    local totalSeconds = math.floor(tick() % 3600)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

local frameTimes = {}
local maxFrames = 20

game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    TimerLabel.Text = getTime()
    
    -- Усреднение FPS
    table.insert(frameTimes, deltaTime)
    if #frameTimes > maxFrames then
        table.remove(frameTimes, 1)
    end
    local averageDelta = 0
    for _, dt in ipairs(frameTypes) do
        averageDelta = averageDelta + dt
    end
    averageDelta = averageDelta / #frameTimes
    FPSLabel.Text = tostring(math.floor(1 / averageDelta))
end)
