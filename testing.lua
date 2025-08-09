local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local player = game.Players.LocalPlayer
local function notify(title, text, icon, time)
    WindUI:Notify({
        Title = title,
        Content = text,
        Icon = icon,
        Duration = time,
    })
end
local success, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
local placeName = info.Name
if success then placeName = #placeName > 50 and string.sub(placeName, 1, 50) .. "..." or placeName end

local window = WindUI:CreateWindow({
    Title = placeName,
    Icon = "gem",
    Author = "Crystal Client v1.5.1 [Premium]",
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

WindUI:SetFont("rbxassetid://12187365364")
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
window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
end, 990)
