local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()


local window = WindUI:CreateWindow({
    Title = "Remote scanner",
    Icon = "scan-line",
    Folder = "RemoteScanner",
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

local tab_scanner = window:Tab({Title = "Get remote function info", Icon = "scan-line"})
local tab_upvalue_scanner = window:Tab({Title = "Get remote upvalues info", Icon = "eye"})
tab_upvalue_scanner:Section({Title = "Get remote upvalues info", Icon = "eye", TextSize = 26})
tab_scanner:Section({Title = "Get remote function info", Icon = "scan-line", TextSize = 26})
-- окно
local function notify(title, text, icon, time)
    WindUI:Notify({
        Title = title,
        Content = text,
        Icon = icon or "triangle-alert",
        Duration = time or 3,
    })
end
window:SelectTab(1)
local function getByPath(path)
    -- Если путь начинается с "game.", парсим его как полный
    if string.sub(path, 1, 5) == "game." then
        local obj = game
        -- Разделяем по точкам и убираем "game"
        local parts = string.split(path, ".")
        table.remove(parts, 1)
        for _, part in ipairs(parts) do
            obj = obj:FindFirstChild(part)
            if not obj then
                notify("RemoteScanner", "Path Not Found: " .. part, "triangle-alert", 3)
                return nil
            end
        end
        return obj
    else
        -- Старый вариант — ищем только в ReplicatedStorage
        local parts = string.split(path, "/")
        local obj = game.ReplicatedStorage
        for _, part in ipairs(parts) do
            obj = obj:FindFirstChild(part)
            if not obj then
                notify("RemoteScanner", "Path Not Found: " .. part, "triangle-alert", 3)
                return nil
            end
        end
        return obj
    end
end


local function function_info(path)
    -- Парсинг пути (теперь понимает и game.ReplicatedStorage.Folder.Remote)
    local remote = getByPath(path)

    if not remote then
        warn("Path not found.")
        return
    end

    -- Проверка типа объекта
    if not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
        warn("Invalid object. Expected RemoteEvent or RemoteFunction.")
        return
    end

    -- Получение соединений (для RemoteFunction можно искать OnClientInvoke)
    local conn
    if remote:IsA("RemoteEvent") then
        conn = getconnections(remote.OnClientEvent)
    elseif remote:IsA("RemoteFunction") then
        conn = getconnections(remote.OnClientInvoke)
    end

    if not conn or not conn[1] then
        notify("Remote Info", "No connection found on remote.", "info", 3)
        return
    end

    local con_function = conn[1].Function
    local info = debug.getinfo(con_function)

    print("======== Remote Info ========")
    print("Remote name: " .. remote.Name)
    print("Function name:", info.name or "unknown")
    print("Source:", info.source or "unknown")
    print("Line defined:", info.linedefined or "unknown")
    print("Last line:", info.lastlinedefined or "unknown")
    print("Current line:", info.currentline or "unknown")
    print("Upvalues count:", info.nups or "unknown")
    print("Params count:", info.nparams or "unknown")
    print("Active lines:", info.activelines or "unknown")

    WindUI:Popup({
        Title = "Remote Info",
        Icon = "info",
        Content = string.format(
            "Remote name: %s\nFunction name: %s\nSource: %s\nLine defined: %s\nLast line: %s\nParams count: %s\nCurrent Line: %s\nUpvalues count: %s",
            remote.Name,
            info.name or "unknown",
            info.source or "unknown",
            info.linedefined or "unknown",
            info.lastlinedefined or "unknown",
            info.nparams or "unknown",
            info.currentline or "unknown",
            info.nups or "unknown"
        ),
        Buttons = {
            {
                Title = "Copy Path",
                Icon = "copy",
                Callback = function()
                    if setclipboard then
                        setclipboard("game." .. remote:GetFullName())
                        notify("RemoteScanner", "Path copied to clipboard!", "check", 3)
                    else
                        notify("RemoteScanner", "Clipboard not supported in this exploit.", "triangle-alert", 3)
                    end
                end,
                Variant = "Secondary",
            },
            {
                Title = "Fire Remote",
                Icon = "zap",
                Callback = function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer()
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer()
                    end
                end,
                Variant = "Tertiary",
            },
            {
                Title = "Close",
                Callback = function() end,
                Variant = "Primary",
            }
        }
    })
    return {
        Name = remote.Name,
        Path = remote
    }
end



local path = tab_scanner:Input({
    Title = "Name of remote (if this folder use Yourfolder/Name or full path game.ReplicatedStorage... more)",
    InputIcon = "search",
    Placeholder = "Enter name of remote here...",
    Callback = function () return end
})
tab_scanner:Button({
    Title = "Start scan",
    Callback = function ()
        local tabl = function_info(path.Value)
        if tabl and tabl.Name then
            local tab = window:Tab({Title = tabl.Name, Icon = "bot"})
            tab:Button({
                Title = "Fire Remote",
                Callback = function ()
                    tabl.Path:FireServer()
                end
            })
        end
    end
})



tab_scanner:Divider()
-- Функция для просмотра содержимого папки
local function scanFolder(path)
    local folder = getByPath(path)
    if not folder or not folder:IsA("Folder") then
        notify("RemoteScanner", "Path is not a folder or not found.", "triangle-alert", 3)
        return
    end

    local tab = window:Tab({Title = "Folder: " .. folder.Name, Icon = "folder"})
    for _, obj in ipairs(folder:GetChildren()) do
        tab:Button({
            Title = obj.Name .. " (" .. obj.ClassName .. ")",
            Callback = function()
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    function_info(path .. "/" .. obj.Name)
                else
                    notify("RemoteScanner", obj.Name .. " is not a RemoteEvent/RemoteFunction", "info", 3)
                end
            end
        })
    end
end

-- UI для ввода пути к папке
local folderPath = tab_scanner:Input({
    Title = "Folder path (example: MyFolder or game.ReplicatedStorage.MyFolder)",
    InputIcon = "folder",
    Placeholder = "Enter folder path...",
    Callback = function () return end
})

tab_scanner:Button({
    Title = "Scan Folder",
    Callback = function ()
        scanFolder(folderPath.Value)
    end
})




-- Функция для красивого преобразования значения в строку
local function valueToString(val)
    local t = typeof(val)
    if t == "string" then
        return '"' .. val .. '"'
    elseif t == "table" then
        local ok, str = pcall(function()
            return game:GetService("HttpService"):JSONEncode(val)
        end)
        return ok and str or tostring(val)
    else
        return tostring(val)
    end
end

local function scanUpvalues(path)
    local remote = getByPath(path)
    if not remote then
        notify("RemoteScanner", "Path not found", "triangle-alert", 3)
        return
    end
    if not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
        notify("RemoteScanner", "Not a RemoteEvent/RemoteFunction", "triangle-alert", 3)
        return
    end

    local conn
    if remote:IsA("RemoteEvent") then
        conn = getconnections(remote.OnClientEvent)
    elseif remote:IsA("RemoteFunction") then
        conn = getconnections(remote.OnClientInvoke)
    end
    if not conn or not conn[1] then
        notify("RemoteScanner", "No connections found", "triangle-alert", 3)
        return
    end

    local func = conn[1].Function
    local upvalues = {}
    for i = 1, debug.getinfo(func).nups do
        local returns = {debug.getupvalue(func, i)}
        local name, value
        if #returns == 2 then
            name, value = returns[1], returns[2]
        else
            name = "unknown"  -- Фиксированное имя для Roblox/exploit-ов
            value = returns[1]
        end
        table.insert(upvalues, {
            Index = i,
            Name = name or "nil",  -- Гарантируем строку
            Value = value,
            Type = typeof(value)
        })
    end
    if #upvalues == 0 then
        notify("RemoteScanner", "No upvalues found", "info", 3)
        return
    end

    local tab = window:Tab({Title = "Upvalues: " .. remote.Name, Icon = "eye"})

    for _, uv in ipairs(upvalues) do
        local title = string.format("[%d] %s (%s): %s",
            uv.Index, tostring(uv.Name), uv.Type, valueToString(uv.Value))

        tab:Button({
            Title = title,
            Callback = function()
                if uv.Type == "function" then
                    local info = debug.getinfo(uv.Value)
                    WindUI:Popup({
                        Title = "Upvalue Function Info",
                        Icon = "info",
                        Content = string.format(
                            "Name: %s\nSource: %s\nLine defined: %s\nLast line: %s\nParams: %s\nUpvalues: %s",
                            info.name or "unknown",
                            info.source or "unknown",
                            info.linedefined or "unknown",
                            info.lastlinedefined or "unknown",
                            info.nparams or "unknown",
                            info.nups or "unknown"
                        ),
                        Buttons = {
                            {
                                Title = "Close",
                                Callback = function() end,
                                Variant = "Tertiary",
                            }
                        }
                    })
                else
                    notify("RemoteScanner", "Value: " .. valueToString(uv.Value), "info", 5)
                end
            end
        })
    end
end

-- Поле ввода и кнопка для tab_upvalue_scanner
local upvaluePath = tab_upvalue_scanner:Input({
    Title = "Remote path for upvalue scan",
    InputIcon = "search",
    Placeholder = "Enter remote path...",
    Callback = function () return end
})

tab_upvalue_scanner:Button({
    Title = "Scan Upvalues",
    Callback = function ()
        scanUpvalues(upvaluePath.Value)
    end
})
