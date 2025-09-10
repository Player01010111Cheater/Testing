local OldShutdown = game.Shutdown
local shutdownHash = tostring(OldShutdown)

print("я сын шлюхи")

task.spawn(function ()
    while wait(0.5) do
        if tostring(game.Shutdown) ~= shutdownHash then
            print("Подмена найдена")
        end
    end
end)
