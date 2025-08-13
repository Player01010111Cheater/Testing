-- GUI to Lua
-- Version: 0.0.3

-- Instances:
local CrystalHubHUD = Instance.new("ScreenGui")
local Hud_1 = Instance.new("Frame")
local UICorner_1 = Instance.new("UICorner")
local UIGradient_1 = Instance.new("UIGradient")
local UIStroke_1 = Instance.new("UIStroke")
local FPSDivider_1 = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local LoginName_1 = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")
local ScriptName_1 = Instance.new("TextLabel")
local UICorner_4 = Instance.new("UICorner")

-- Properties:
CrystalHubHUD.Name = "CrystalHubHUD"
CrystalHubHUD.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
CrystalHubHUD.IgnoreGuiInset = true -- игнорируем Roblox GUI inset
CrystalHubHUD.ResetOnSpawn = false

Hud_1.Name = "Hud"
Hud_1.Parent = CrystalHubHUD
Hud_1.AnchorPoint = Vector2.new(1, 0) -- привязка к правому верхнему углу
Hud_1.Position = UDim2.new(1, -math.floor(workspace.CurrentCamera.ViewportSize.X * 0.02), 0, math.floor(workspace.CurrentCamera.ViewportSize.Y * 0.02))
Hud_1.Size = UDim2.new(0, math.floor(workspace.CurrentCamera.ViewportSize.X * 0.2), 0, math.floor(workspace.CurrentCamera.ViewportSize.Y * 0.05))
Hud_1.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
Hud_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
Hud_1.BorderSizePixel = 0

UICorner_1.Parent = Hud_1
UIGradient_1.Parent = Hud_1

UIStroke_1.Parent = Hud_1
UIStroke_1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_1.Color = Color3.fromRGB(173, 173, 173)
UIStroke_1.Thickness = 1.1

FPSDivider_1.Name = "FPSDivider"
FPSDivider_1.Parent = Hud_1
FPSDivider_1.BackgroundColor3 = Color3.fromRGB(175, 175, 175)
FPSDivider_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
FPSDivider_1.BorderSizePixel = 0
FPSDivider_1.Position = UDim2.new(0.432989687, 0, 0, 0)
FPSDivider_1.Size = UDim2.new(0, 1, 1, 0)

UICorner_2.Parent = FPSDivider_1

LoginName_1.Name = "LoginName"
LoginName_1.Parent = Hud_1
LoginName_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LoginName_1.BackgroundTransparency = 1
LoginName_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
LoginName_1.BorderSizePixel = 0
LoginName_1.Position = UDim2.new(0.436560929, 0, 0.15, 0)
LoginName_1.Size = UDim2.new(0.5, 0, 0.7, 0)
LoginName_1.Font = Enum.Font.FredokaOne
LoginName_1.Text = "?????????"
LoginName_1.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginName_1.TextScaled = true
LoginName_1.TextWrapped = true

UICorner_3.Parent = LoginName_1

ScriptName_1.Name = "ScriptName"
ScriptName_1.Parent = Hud_1
ScriptName_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScriptName_1.BackgroundTransparency = 1
ScriptName_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScriptName_1.BorderSizePixel = 0
ScriptName_1.Size = UDim2.new(0.43, 0, 1, 0)
ScriptName_1.Font = Enum.Font.FredokaOne
ScriptName_1.Text = "CrystalHub"
ScriptName_1.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptName_1.TextScaled = true
ScriptName_1.TextWrapped = true

UICorner_4.Parent = ScriptName_1

-- Адаптация при смене размера окна:
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	local vp = workspace.CurrentCamera.ViewportSize
	Hud_1.Position = UDim2.new(1, -math.floor(vp.X * 0.02), 0, math.floor(vp.Y * 0.02))
	Hud_1.Size = UDim2.new(0, math.floor(vp.X * 0.2), 0, math.floor(vp.Y * 0.05))
end)
