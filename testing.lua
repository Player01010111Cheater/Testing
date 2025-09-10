local functions = {
    {
        Object = game,
        Key = "Shutdown",
        Original = game.Shutdown
    }
}

for _, v in pairs(functions) do
    v.SafeVersion = newcclosure(function (...)
        return v.Original(...)        
    end)
end

-- ====== Переопределяем доступ через метатаблицы ======
for _, func in ipairs(functions) do
    local mt = getrawmetatable(func.Object)
    if mt then
        local oldIndex = mt.__index
        setreadonly(mt, false)
        
        mt.__index = newcclosure(function(t, k)
            if k == func.Key then
                return func.SafeVersion
            end
            return oldIndex(t, k)
        end)
        
        setreadonly(mt, true)
    end
end

-- ====== Проверка целостности всех функций ======
spawn(function()
    while true do
        for _, func in ipairs(functions) do
            -- Проверяем, не изменили ли оригинальную функцию
            if func.Object[func.Key] ~= func.SafeVersion then
                local player = game.Players.LocalPlayer
                if player then
                    player:Kick("Tamper detected! " .. func.Key .. " hook attempt!")
                end
                return
            end
        end
        wait(1)
    end
end)


print("Попытка хука Shutdown:")
local success, err = pcall(function()
    local old
    old = hookfunction(game.Shutdown, function()
        return nil
    end)
end)

if not success then
    print("Попытка хука провалена:", err)
end
