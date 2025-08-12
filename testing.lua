-- GUI to Lua
-- Version: 0.0.3

-- Instances:
local CrystalHubAuth = Instance.new("ScreenGui")
local MainFrame_1 = Instance.new("Frame")
local UICorner_1 = Instance.new("UICorner")
local UIStroke_1 = Instance.new("UIStroke")
local TextLabel_1 = Instance.new("TextLabel")
local UITextSizeConstraint_1 = Instance.new("UITextSizeConstraint")
local UIAspectRatioConstraint_1 = Instance.new("UIAspectRatioConstraint")
local TextBox_1 = Instance.new("TextBox")
local TextLabel_2 = Instance.new("TextLabel")
local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local UICorner_2 = Instance.new("UICorner")
local UIStroke_2 = Instance.new("UIStroke")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")
local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")
local TextBox_2 = Instance.new("TextBox")
local TextLabel_3 = Instance.new("TextLabel")
local UIAspectRatioConstraint_4 = Instance.new("UIAspectRatioConstraint")
local UITextSizeConstraint_4 = Instance.new("UITextSizeConstraint")
local UICorner_3 = Instance.new("UICorner")
local UIStroke_3 = Instance.new("UIStroke")
local UITextSizeConstraint_5 = Instance.new("UITextSizeConstraint")
local UIAspectRatioConstraint_5 = Instance.new("UIAspectRatioConstraint")
local TextButton_1 = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local UIAspectRatioConstraint_6 = Instance.new("UIAspectRatioConstraint")
local UIAspectRatioConstraint_7 = Instance.new("UIAspectRatioConstraint")

-- Properties:
CrystalHubAuth.Name = "CrystalHubAuth"
CrystalHubAuth.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

MainFrame_1.Name = "MainFrame"
MainFrame_1.Parent = CrystalHubAuth
MainFrame_1.AnchorPoint = Vector2.new(0.5, 0.5) -- Центр
MainFrame_1.Position = UDim2.new(0.5, 0, 0.5, 0) -- Всегда в центре
MainFrame_1.Size = UDim2.new(0, 350, 0, 300) -- Фиксированный размер
MainFrame_1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame_1.BorderSizePixel = 0

-- Если хочешь, чтобы на очень маленьких экранах уменьшалось:
local UISizeConstraint = Instance.new("UISizeConstraint")
UISizeConstraint.MinSize = Vector2.new(300, 250)
UISizeConstraint.MaxSize = Vector2.new(350, 300)
UISizeConstraint.Parent = MainFrame_1

UICorner_1.Parent = MainFrame_1

UIStroke_1.Parent = MainFrame_1
UIStroke_1.Color = Color3.fromRGB(132, 0, 198)
UIStroke_1.Thickness = 1


TextLabel_1.Parent = MainFrame_1
TextLabel_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_1.BackgroundTransparency = 1
TextLabel_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_1.BorderSizePixel = 0
TextLabel_1.Position = UDim2.new(0.028, 0, 0, 0)
TextLabel_1.Size = UDim2.new(0.942736506, 0, 0.256178379, 0)
TextLabel_1.Font = Enum.Font.FredokaOne
TextLabel_1.Text = "CrystalHub - Auth"
TextLabel_1.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_1.TextScaled = true
TextLabel_1.TextSize = 20
TextLabel_1.TextStrokeTransparency = 0
TextLabel_1.TextWrapped = true

UITextSizeConstraint_1.Parent = TextLabel_1
UITextSizeConstraint_1.MaxTextSize = 30

UIAspectRatioConstraint_1.Parent = TextLabel_1
UIAspectRatioConstraint_1.AspectRatio = 4.000000476837158

TextBox_1.Parent = MainFrame_1
TextBox_1.Active = true
TextBox_1.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
TextBox_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox_1.BorderSizePixel = 0
TextBox_1.CursorPosition = -1
TextBox_1.Position = UDim2.new(0.1, 0, 0.249450147, 0)
TextBox_1.Size = UDim2.new(0.800000072, 0, 0.14782609, 0)
TextBox_1.Font = Enum.Font.FredokaOne
TextBox_1.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
TextBox_1.PlaceholderText = "Enter login here"
TextBox_1.Text = ""
TextBox_1.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox_1.TextScaled = true
TextBox_1.TextSize = 14
TextBox_1.TextWrapped = true

TextLabel_2.Parent = TextBox_1
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.82, 0, 0.970588207, 0)
TextLabel_2.Size = UDim2.new(0.176763088, 0, 0.693188548, 0)
TextLabel_2.Font = Enum.Font.FredokaOne
TextLabel_2.Text = "0/24"
TextLabel_2.TextColor3 = Color3.fromRGB(178, 178, 178)
TextLabel_2.TextScaled = true
TextLabel_2.TextSize = 12
TextLabel_2.TextWrapped = true

UIAspectRatioConstraint_2.Parent = TextLabel_2
UIAspectRatioConstraint_2.AspectRatio = 1.5

UITextSizeConstraint_2.Parent = TextLabel_2
UITextSizeConstraint_2.MaxTextSize = 12

UICorner_2.Parent = TextBox_1
UICorner_2.CornerRadius = UDim.new(0, 7)

UIStroke_2.Parent = TextBox_1
UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_2.Color = Color3.fromRGB(62, 62, 62)
UIStroke_2.Thickness = 1

UITextSizeConstraint_3.Parent = TextBox_1
UITextSizeConstraint_3.MaxTextSize = 14

UIAspectRatioConstraint_3.Parent = TextBox_1
UIAspectRatioConstraint_3.AspectRatio = 5.882352828979492

TextBox_1:GetPropertyChangedSignal("Text"):Connect(function()
	if #TextBox_1.Text > 24 then
		TextBox_1.Text = TextBox_1.Text:sub(1, 24)
	end
	TextLabel_2.Text = #TextBox_1.Text .. "/24"
end)

TextBox_2.Parent = MainFrame_1
TextBox_2.Active = true
TextBox_2.AutomaticSize = Enum.AutomaticSize.X
TextBox_2.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
TextBox_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox_2.BorderSizePixel = 0
TextBox_2.CursorPosition = -1
TextBox_2.Position = UDim2.new(0.1, 0, 0.477239996, 0)
TextBox_2.Size = UDim2.new(0.800000072, 0, 0.14782609, 0)
TextBox_2.Font = Enum.Font.FredokaOne
TextBox_2.PlaceholderText = "Enter password here"
TextBox_2.Text = ""
TextBox_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox_2.TextScaled = true
TextBox_2.TextSize = 14
TextBox_2.TextWrapped = true

TextLabel_3.Parent = TextBox_2
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.BackgroundTransparency = 1
TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.BorderSizePixel = 0
TextLabel_3.Position = UDim2.new(0.82, 0, 1, 0)
TextLabel_3.Size = UDim2.new(0.176763088, 0, 0.693188548, 0)
TextLabel_3.Font = Enum.Font.FredokaOne
TextLabel_3.Text = "0/24"
TextLabel_3.TextColor3 = Color3.fromRGB(178, 178, 178)
TextLabel_3.TextScaled = true
TextLabel_3.TextSize = 12
TextLabel_3.TextWrapped = true

UIAspectRatioConstraint_4.Parent = TextLabel_3
UIAspectRatioConstraint_4.AspectRatio = 1.5

UITextSizeConstraint_4.Parent = TextLabel_3
UITextSizeConstraint_4.MaxTextSize = 12

UICorner_3.Parent = TextBox_2
UICorner_3.CornerRadius = UDim.new(0, 7)

UIStroke_3.Parent = TextBox_2
UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_3.Color = Color3.fromRGB(62, 62, 62)
UIStroke_3.Thickness = 1

UITextSizeConstraint_5.Parent = TextBox_2
UITextSizeConstraint_5.MaxTextSize = 14

UIAspectRatioConstraint_5.Parent = TextBox_2
UIAspectRatioConstraint_5.AspectRatio = 5.882352828979492

TextBox_2:GetPropertyChangedSignal("Text"):Connect(function()
	if #TextBox_2.Text > 24 then
		TextBox_2.Text = TextBox_2.Text:sub(1, 24)
	end
	TextLabel_3.Text = #TextBox_2.Text .. "/24"
end)

TextButton_1.Parent = MainFrame_1
TextButton_1.Active = true
TextButton_1.BackgroundColor3 = Color3.fromRGB(88, 177, 131)
TextButton_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_1.BorderSizePixel = 0
TextButton_1.Position = UDim2.new(0.1, 0, 0.708000124, 0)
TextButton_1.Size = UDim2.new(0.800000072, 0, 0.152173921, 0)
TextButton_1.Font = Enum.Font.FredokaOne
TextButton_1.Text = "Login"
TextButton_1.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton_1.TextSize = 21

UICorner_4.Parent = TextButton_1
UICorner_4.CornerRadius = UDim.new(0, 7)

UIAspectRatioConstraint_6.Parent = TextButton_1
UIAspectRatioConstraint_6.AspectRatio = 5.714285850524902

UIAspectRatioConstraint_7.Parent = MainFrame_1
UIAspectRatioConstraint_7.AspectRatio = 1.08695650100708
