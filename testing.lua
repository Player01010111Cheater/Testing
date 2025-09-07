
local oldHook = hookfunction
hookfunction = function(func, new)
    if func == Players.LocalPlayer.Kick or func == game.Shutdown or func == setclipboard then
        print("[PROTECT] Someone tried to hook protected function!")
        return func
    end
    return oldHook(func, new)
end
