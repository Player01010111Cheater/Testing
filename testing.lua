-- Скрипт для эксплойта: извлечение upvalues из EggService

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Функция для вывода upvalues
local function printUpvalues(func, maxIndex)
    print("=== Анализ upvalues для функции ===")
    local info = debug.getinfo(func)
    print("Имя функции: " .. (info.name or "неизвестно"))
    print("Количество upvalues: " .. info.nups)
    
    for i = 1, maxIndex do
        local value = getupvalue(func, i)
        if value ~= nil then
            print("Upvalue #" .. i .. ":")
            if type(value) == "table" then
                for key, val in pairs(value) do
                    print("  Ключ: " .. tostring(key) .. " | Значение: " .. tostring(val))
                end
            else
                print("  Значение: " .. tostring(value))
            end
        else
            print("Upvalue #" .. i .. ": nil")
        end
    end
    print("=================================")
end

-- Анализ RemoteEvent
local function analyzeRemoteEvent(eventName)
    local remoteEvent = ReplicatedStorage:FindFirstChild(eventName)
    if not remoteEvent or not remoteEvent:IsA("RemoteEvent") then
        warn("RemoteEvent '" .. eventName .. "' не найден или не является RemoteEvent")
        return
    end

    print("Найден RemoteEvent: " .. eventName)
    local connections = getconnections(remoteEvent.OnClientEvent)
    if #connections == 0 then
        warn("Нет подключённых функций для " .. eventName)
        return
    end

    for i, connection in ipairs(connections) do
        print("Анализ подключения #" .. i)
        local func = connection.Function
        if func then
            printUpvalues(func, 5) -- Проверяем до 5 upvalues
        else
            warn("Функция для подключения #" .. i .. " не найдена")
        end
    end
end

-- Ждём 1 секунду
wait(1)

-- Анализируем наш RemoteEvent
analyzeRemoteEvent("EggService")
