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
local function scanner(name)
    name = game.ReplicatedStorage[name]
    if not name or not name:IsA("RemoteEvent") then
        warn("Invalid or non-RemoteEvent object.")
        return
    end
    local conn = getconnections(name.OnClientEvent)
    local con_function = conn[1].Function
    local info = debug.getinfo(con_function)
    print("========Info=========")
    print("Remote name: " .. name)
    print("Function name: ", info.name or "unknown")
    print("Source: ", info.source, "unknown")
    print("String number: ", info.linedefined or "unknown")
    print("last string: ", info.lastlinedefined or "unknown")
    print("current line: ", info.currentline or "unknown")
    print("upvalues count: ", info.nups or "unknown")
    print("params count: ", info.nparams or "unknown")
    print("active lines: ", info.activelines or "unknown")
    print("======Upvalues======")
    if info.nups > 0 then
        local upvalues = getupvalue(con_function, 1)
        if typeof(upvalues) == "table" and info.nparams then
            for i,v in pairs(upvalues) do
                if info.nparams == 2 then
                    print(i, v )
                elseif info.nparams == 1 then
                    print(v)
                else
                    print("Not supported params count.")
                    return
                end
            end
        else
            print("In function finded function.")
            return
        end
    else
        print("No upvalues finded.")
    end
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
