local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if k == "Shutdown" then
        local player = game.Players.LocalPlayer
        if player then player:Kick("Tamper detected!") end
    end
    return oldIndex(t, k)
end)

setreadonly(mt, true)


