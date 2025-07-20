local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimerAndFPSGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.25, 0, 0.12, 0)
MainFrame.Position = UDim2.new(0, 7, 1, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainFrame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Name = "TimerLabel"
TimerLabel.Size = UDim2.new(0.27, 0, 0.5, 0)
TimerLabel.Position = UDim2.new(0.2, 0, 0, 8)
TimerLabel.BackgroundTransparency = 1
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.TextSize = 17
TimerLabel.TextScaled = false
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.Text = "00:00"
TimerLabel.Parent = MainFrame

local FpsLabel = Instance.new("TextLabel")
FpsLabel.Name = "FpsLabel"
FpsLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
FpsLabel.Position = UDim2.new(0.66, 0, 0, 9)
FpsLabel.BackgroundTransparency = 1
FpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsLabel.TextSize = 17
FpsLabel.TextScaled = false
FpsLabel.Font = Enum.Font.GothamBold
FpsLabel.Text = "60"
FpsLabel.Parent = MainFrame

local TimerIcon = Instance.new("ImageLabel")
TimerIcon.Size = UDim2.new(0.1, 0, 0.5, 0)
TimerIcon.Position = UDim2.new(0.071, 0, 0, 10)
TimerIcon.BackgroundTransparency = 1
TimerIcon.Image = "rbxassetid://10709752630"
TimerIcon.Parent = MainFrame

local TimerIconAspect = Instance.new("UIAspectRatioConstraint")
TimerIconAspect.AspectRatio = 1
TimerIconAspect.Parent = TimerIcon

local FPSIcon = Instance.new("ImageLabel")
FPSIcon.Size = UDim2.new(0.1, 0, 0, 10)
FPSIcon.Position = UDim2.new(0.57, 0, 0, 13)
FPSIcon.BackgroundTransparency = 1
FPSIcon.Image = "rbxassetid://15269177520"
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
    local totalSeconds = math.floor(tick() % 3600)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

-- Исправленный FPS-счетчик
local lastUpdate = tick()
local frameCount = 0
local fps = 60

game:GetService("RunService").Heartbeat:Connect(function()
    -- Обновление таймера
    TimerLabel.Text = getTime()
    
    -- Подсчет FPS
    frameCount = frameCount + 1
    local now = tick()
    local elapsed = now - lastUpdate
    
    if elapsed >= 0.5 then -- Обновляем FPS каждые 0.5 секунды
        fps = math.floor(frameCount / elapsed + 0.5)
        frameCount = 0
        lastUpdate = now
        FpsLabel.Text = tostring(fps)
    end
end)
