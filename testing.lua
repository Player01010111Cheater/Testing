local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Создаем эффект размытия
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0
TweenService:Create(blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = 20}):Play()

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ChitaLoader"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Фоновый фрейм
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 1

local bg = Instance.new("Frame", frame)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
bg.BackgroundTransparency = 1
bg.ZIndex = 0
TweenService:Create(bg, TweenInfo.new(0.6), {BackgroundTransparency = 0.4}):Play()

-- Центральный кристальный шар
local orb = Instance.new("ImageLabel", frame)
orb.Size = UDim2.new(0, 120, 0, 120)
orb.Position = UDim2.new(0.5, 0, 0.5, 0)
orb.AnchorPoint = Vector2.new(0.5, 0.5)
orb.BackgroundTransparency = 1
orb.Image = "rbxassetid://10891594364" -- Glow circle crosshair
orb.ImageTransparency = 1
orb.ImageColor3 = Color3.fromRGB(100, 200, 255)

-- Градиент для шара
local orbGradient = Instance.new("UIGradient", orb)
orbGradient.Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 200, 255)),
 ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 200))
})
orbGradient.Rotation = 45

-- Пульсирующий эффект для шара
local function pulseOrb()
 while orb.Parent do
  local grow = TweenService:Create(orb, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
   Size = UDim2.new(0, 140, 0, 140),
   ImageTransparency = 0.2
  })
  local shrink = TweenService:Create(orb, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
   Size = UDim2.new(0, 120, 0, 120),
   ImageTransparency = 0
  })
  grow:Play()
  grow.Completed:Wait()
  shrink:Play()
  shrink.Completed:Wait()
 end
end

-- Создаем вращающиеся частицы
local particles = {}
local function createParticle()
 local particle = Instance.new("ImageLabel", frame)
 particle.Size = UDim2.new(0, 15, 0, 15)
 particle.BackgroundTransparency = 1
 particle.Image = "rbxassetid://4000131509" -- Rainbow dot crosshair
 particle.ImageColor3 = Color3.fromRGB(200, 220, 255)
 particle.ImageTransparency = 0.5
 particle.ZIndex = 2
 return particle
end

-- Анимация частиц по круговой орбите
local function animateParticle(particle, radius, speed, offset)
 local angle = offset
 while particle.Parent do
  angle = angle + speed
  local x = math.cos(angle) * radius
  local y = math.sin(angle) * radius
  particle.Position = UDim2.new(0.5, x, 0.5, y)
  wait()
 end
end

-- Создаем частицы
for i = 1, 6 do
 local particle = createParticle()
 local radius = 80
 local speed = math.random(1, 3) / 10
 local offset = math.rad(i * 60)
 table.insert(particles, particle)
 coroutine.wrap(animateParticle)(particle, radius, speed, offset)
end

-- Надпись "ЧИТА"
local word = "CRYSTAL"
local letters = {}
for i = 1, #word do
 local char = word:sub(i, i)
 local label = Instance.new("TextLabel", frame)
 label.Text = char
 label.Font = Enum.Font.GothamBold
 label.TextColor3 = Color3.fromRGB(200, 220, 255)
 label.TextTransparency = 1
 label.TextSize = 25
 label.Size = UDim2.new(0, 50, 0, 50)
 label.AnchorPoint = Vector2.new(0.5, 0.5)
 label.Position = UDim2.new(0.5, (i - (#word / 2 + 0.5)) * 55, 0.6, 30) -- Под шаром
 label.BackgroundTransparency = 1

 local gradient = Instance.new("UIGradient", label)
 gradient.Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 180, 255)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 120, 200))
 })
 gradient.Rotation = 90

 local tweenIn = TweenService:Create(label, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
  TextTransparency = 0,
  TextSize = 40
 })
 tweenIn:Play()
 table.insert(letters, label)
 wait(0.2)
end

-- Начальная анимация шара
local orbIn = TweenService:Create(orb, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
 ImageTransparency = 0,
 Size = UDim2.new(0, 120, 0, 120)
})
orbIn:Play()
coroutine.wrap(pulseOrb)()

-- Пульсирующий эффект для текста
local function pulseText()
 while frame.Parent do
  for _, label in ipairs(letters) do
   local grow = TweenService:Create(label, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
    TextSize = 45
   })
   local shrink = TweenService:Create(label, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
    TextSize = 40
   })
   grow:Play()
   grow.Completed:Wait()
   shrink:Play()
   shrink.Completed:Wait()
  end
 end
end

coroutine.wrap(pulseText)()

-- Анимация завершения
local function tweenOutAndDestroy()
 -- Исчезновение частиц
 for _, particle in ipairs(particles) do
  local fade = TweenService:Create(particle, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {ImageTransparency = 1})
  fade:Play()
 end

 -- Исчезновение текста
 for _, label in ipairs(letters) do
  local fadeOut = TweenService:Create(label, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
   TextTransparency = 1,
   TextSize = 20
  })
  fadeOut:Play()
 end

 -- Анимация исчезновения шара
 local orbOut = TweenService:Create(orb, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
  ImageTransparency = 1,
  Size = UDim2.new(0, 80, 0, 80)
 })
 orbOut:Play()

 -- Увеличение размытия
 local blurIn = TweenService:Create(blur, TweenInfo.new(0.4), {Size = 30})
 blurIn:Play()
 blurIn.Completed:Wait()

 -- Исчезновение фона и размытия
 local blurOut = TweenService:Create(blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = 0})
 local bgFade = TweenService:Create(bg, TweenInfo.new(0.6), {BackgroundTransparency = 1})
 blurOut:Play()
 bgFade:Play()
 blurOut.Completed:Wait()

 -- Очистка
 screenGui:Destroy()
 blur:Destroy()
end

-- Запуск завершения через 3 секунды
wait(3)
tweenOutAndDestroy()
