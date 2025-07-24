local Mana = loadstring(game:HttpGet("https://pastebin.com/raw/inP2PXxe"))()
local Win = Mana:Window("NEVERLOSE", {Theme = "blue"}) -- Устанавливаем тему "blue"
local Autofarm = Win:Tab("AutoFarm")
Autofarm:Toggle("Auto Farm", false, function(t)
    print("Auto Farm is", t and "enabled" or "disabled")
end)
Autofarm:Slider("Walk Speed", 1, 500, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)
