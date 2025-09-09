local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if k == "Shutdown" or k == "Kick" or k == "Destroy" then
        print("Попытка вмешательства в "..k.."!")
        local player = game.Players.LocalPlayer
        if player then
            player:Kick("Tamper detected on "..k.."!")
        end
    end
    return oldIndex(t, k)
end)

setreadonly(mt, true)

-- ====== Пример попытки хука (демонстрация) ======
print("Попытка хука Shutdown:")
local success, err = pcall(function()
    hookfunction(game.Shutdown, function(self, ...)
        print("Я перехватил Shutdown!") -- это не должно выполниться
        return nil
    end)
end)
if not success then
    print("Попытка хука провалена:", err)
end

