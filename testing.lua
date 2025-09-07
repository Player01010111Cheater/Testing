-- Сохраняем оригинальные функции
local Original = {
    Kick = Players.LocalPlayer.Kick,
    Shutdown = game.Shutdown,
    SetClipboard = setclipboard
}

-- Переопределяем в глобальном окружении
getgenv().Kick = function(...)
    return Original.Kick(...)
end

getgenv().Shutdown = function(...)
    return Original.Shutdown(...)
end

getgenv().setclipboard = function(...)
    return Original.SetClipboard(...)
end

-- Защита от переопределения
make_writeable_protected(nil) -- Если такая функция есть в вашем экзекьюторе




hookfunction(game.Shutdown, function(...)
    print(...)
    return ...
end)

