local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()


local window = WindUI:CreateWindow({
    Title = "Remote scanner (only remote event)",
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

local tab_scanner = window:Tab({Title = "Remote scanner", Icon = "scan-line"})
tab_scanner:Section({Title = "Remote scanner", Icon = "scan-line", TextSize = 26})
-- окно

local function getByPath(path)
    local parts = string.split(path, "/")
    local obj = game.ReplicatedStorage
    for _, part in ipairs(parts) do
        obj = obj:FindFirstChild(part)
        if not obj then
            warn("Object not found: " .. part)
            return nil
        end
    end
    return obj
end

local function scanner(name)
    name = getByPath(name)
    if not name or not name:IsA("RemoteEvent") then
        warn("Invalid or non-RemoteEvent object.")
        return
    end

    local conn = getconnections(name.OnClientEvent)
    if not conn or not conn[1] then
        warn("No connections found on this RemoteEvent.")
        return
    end

   local function scanner(name)
    name = getByPath(name)
    if not name or not name:IsA("RemoteEvent") then
        warn("Invalid or non-RemoteEvent object.")
        return
    end

    local conn = getconnections(name.OnClientEvent)
    if not conn or not conn[1] then
        warn("No connections found on this RemoteEvent.")
        return
    end

    local function analyzeFunction(func)
        local info = debug.getinfo(func)
        print("\n========Info=========")
        print("Function name: ", info.name or "unknown")
        print("Source: ", info.source or "unknown")
        print("Line defined: ", info.linedefined or "unknown")
        print("Last line: ", info.lastlinedefined or "unknown")
        print("Current line: ", info.currentline or "unknown")
        print("Upvalues count: ", info.nups or "unknown")
        print("Params count: ", info.nparams or "unknown")
        print("Active lines: ", info.activelines or "unknown")

        print("======Upvalues======")
        if info.nups > 0 then
            for i = 1, info.nups do
                local name, value = debug.getupvalue(func, i)
                if typeof(value) == "table" then
                    print("[" .. tostring(name) .. "] (table):")
                    for k, v in pairs(value) do
                        print("   ", k, v)
                    end
                elseif typeof(value) == "function" then
                    print("[" .. tostring(name) .. "] (function): Re-analyzing nested function...")
                    analyzeFunction(value) -- 🔁 рекурсивный вызов
                else
                    print("[" .. tostring(name) .. "]:", value)
                end
            end
        else
            print("No upvalues found.")
        end
    end

    print("Remote name: " .. name.Name)
    analyzeFunction(conn[1].Function)
end


local path = tab_scanner:Input({
    Title = "Name of remote (if this folder use Yourfolder/Name)",
    InputIcon = "search",
    Placeholder = "Enter name of remote here...",
    Callback = function () return end
})
local start_scan = tab_scanner:Button({
    Title = "Start scan",
    Callback = function ()
        scanner(path.Value)
    end
})
