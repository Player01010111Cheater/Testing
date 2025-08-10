local library = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local window = library:CreateWindow({
    Title = "Crystal DLC",
    Icon = "gem",
    Author = "Crystal Client [versions]",
    Folder = "CrystalClient",
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
library:SetFont("rbxassetid://12187365364")
window:EditOpenButton({
    Title = "Crystal DLC",
    Icon = "gem",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("1E4F59"), -- морской синий
        Color3.fromHex("FFFFFF")  -- белый
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})
window:DisableTopbarButtons({
    "Fullscreen",
})
local ConfigManager = window.ConfigManager
-- Попытка найти существующий конфиг
local existingConfig = nil
for _, cfg in pairs(ConfigManager:AllConfigs()) do
    if cfg.Name == "total_executes" then
        existingConfig = cfg
        break
    end
end

if existingConfig then
    local data = existingConfig:Load()
    total_ex = data.total_ex or 0
else
    local newConfig = ConfigManager:CreateConfig("total_executes")
    newConfig:Register("total_ex", total_ex + 1)
    newConfig:Save()
end

