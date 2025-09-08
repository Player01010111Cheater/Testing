local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
--// create window
local window = Rayfield:CreateWindow({
   Name = "Nikoleto Hub • TrenchWar",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "TrenchWar",
   LoadingSubtitle = "by NikoletoHub",
   ShowText = "Nikoleto", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default",

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
})

local hitbox_size = Vector3.new(2, 2, 1)
local hitbox_transparent = true
local hitbox_connects = {}


local function setHitbox(plr, enable)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = plr.Character.HumanoidRootPart
        if enable then
            hrp.Size = hitbox_size
            hrp.Color = Color3.fromRGB(0, 0, 0)
            hrp.Transparency = hitbox_transparent and 0.5 or 0
            hrp.CanCollide = false
        else
            hrp.Size = Vector3.new(2, 2, 1)
            hrp.Transparency = 1
        end
    end
end

--// Tabs
local tab_hitbox = window:CreateTab("Hitbox", 4483362458)
local tab_localplayer = window:CreateTab("LocalPlayer", 4483362458)
local tab_teleport = window:CreateTab("Teleport", 4483362458)
local tab_theme = window:CreateTab("Themes", 4483362458)

--// Hitbox Settings
tab_hitbox:CreateSlider({
    Name = "HitBox Size XYZ",
    Range = {2, 150},
    Increment = 1,
    CurrentValue = 2,
    Flag = "HitboxSize",
    Callback = function(v)
        hitbox_size = Vector3.new(v, v, v)
    end,
})

tab_hitbox:CreateToggle({
    Name = "HitBox Transparent",
    CurrentValue = true,
    Flag = "HitboxTransparency",
    Callback = function(v)
        hitbox_transparent = v
    end,
})

local function update(plr)
    setHitbox(plr, plr.TeamColor ~= player.TeamColor and not plr.Neutral)
end

local function track(plr)
    if plr == player then return end
    hitbox_connects[plr] = {}

    local function hookChar(char)
        task.wait(0.5)
        update(plr)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function() setHitbox(plr,false) end)
        end
    end

    table.insert(hitbox_connects[plr], plr.CharacterAdded:Connect(hookChar))
    table.insert(hitbox_connects[plr], plr:GetPropertyChangedSignal("TeamColor"):Connect(function() update(plr) end))
    table.insert(hitbox_connects[plr], plr:GetPropertyChangedSignal("Neutral"):Connect(function() update(plr) end))

    if plr.Character then hookChar(plr.Character) end
end

local function clear(plr)
    if hitbox_connects[plr] then
        for _,c in pairs(hitbox_connects[plr]) do c:Disconnect() end
        hitbox_connects[plr] = nil
    end
    setHitbox(plr,false)
end

tab_hitbox:CreateToggle({
    Name = "Enable Hitbox",
    CurrentValue = false,
    Flag = "HitboxToggle",
    Callback = function(state)
        if state then
            for _, plr in pairs(Players:GetPlayers()) do 
                track(plr) 
            end
            hitbox_connects["_add"] = Players.PlayerAdded:Connect(function (plr)
                track(plr)
            end)
            hitbox_connects["_rem"] = Players.PlayerRemoving:Connect(function (plr)
                clear(plr)
            end)
        else
            for _,plr in pairs(Players:GetChildren()) do 
                setHitbox(plr,false) 
            end
            for _, v in pairs(hitbox_connects) do
                if typeof(v)=="table" then
                    for _,c in pairs(v) do c:Disconnect() end
                else
                    v:Disconnect()
                end
            end
            hitbox_connects = {}
        end
    end,
})

--// LocalPlayer
local selected_walkspeed = 16

tab_localplayer:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 256},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(slider)
        selected_walkspeed = slider
    end,
})

tab_localplayer:CreateButton({
    Name = "Apply WalkSpeed",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = selected_walkspeed
        end
    end,
})

tab_localplayer:CreateButton({
    Name = "Load Fly Gui v3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Player01010111Cheater/CrystHub/refs/heads/main/fly.lua"))()       
    end,
})

--// Teleports
local trench_number = "BaseUK"
local cframes = {
    ["BaseGermany"] = CFrame.new(1.75373697, 103.19902, -768.264832),
    ["A"] = CFrame.new(131, 92.9989929, -500.000031),
    ["B"] = CFrame.new(116, 92.9989929, -250),
    ["C"] = CFrame.new(-67, 92.9989929, 0),
    ["D"] = CFrame.new(-56.3044777, 92.9989929, 251.159302),
    ["E"] = CFrame.new(122.999992, 92.9989929, 500),
    ["BaseUK"] = CFrame.new(1.2450645, 103.19902, 767.675537),
}

tab_teleport:CreateDropdown({
    Name = "Trench",
    Options = {"BaseGermany","A", "B", "C", "D", "E", "BaseUK"},
    CurrentOption = "BaseUK",
    Flag = "TrenchOption",
    Callback = function(option)
        trench_number = option
    end,
})

tab_teleport:CreateButton({
    Name = "Teleport to selected trench",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = cframes[trench_number]
        end
    end,
})

--// Theme
tab_theme:CreateDropdown({
   Name = "Current Theme",
   Options = {"Default","AmberGlow","Amethyst","Bloom","DarkBlue","Green","Light","Ocean","Serenity"},
   CurrentOption = "Default",
   Flag = "Theme",
   Callback = function(option)
      window.ModifyTheme(option[1])
   end,
})

