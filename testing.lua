local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Cub",
    Icon = "gem",
    Size = UDim2.fromOffset(580, 350),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            -- Тут логика
        end,
    },

})


local searchbar = Window.Searchbar 
--                        | Special name     | Icon     | Callback                         | Order
Window:CreateTopbarButton("MyCustomButton1", "bird",    function() searchbar:Open() end,  990)
