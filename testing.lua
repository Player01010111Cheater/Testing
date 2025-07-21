local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local url = "https://raw.githubusercontent.com/Player01010111Cheater/crystalclient_keys/main/keys.json"
local api_url = "https://api.github.com/repos/Player01010111Cheater/crystalclient_keys/contents/keys.json"
local user_id = tostring(Players.LocalPlayer.UserId)
local token = "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"

-- Получение и парсинг JSON
local keys_data = {}
local success, err = pcall(function()
    local response = request({
        Url = url,
        Method = "GET",
        Headers = {
            ["Authorization"] = "token " .. token,
            ["User-Agent"] = "CrystalClient"
        }
    })
    keys_data = HttpService:JSONDecode(response.Body)
end)

if not success then
    warn("Error: " .. tostring(err))
    keys_data = {} -- Создаем пустую таблицу если не удалось загрузить
end

-- Функция для обновления файла на GitHub
local function updateGitHubFile(new_data)
    local json_data = HttpService:JSONEncode(new_data)
    local base64_data = game:GetService("HttpService"):JSONEncode({
        message = "Update user data",
        content = game:GetService("HttpService"):Base64Encode(json_data),
        sha = keys_data._sha or nil -- Нужно сохранять sha при первом чтении
    })
    
    local success, response = pcall(function()
        return request({
            Url = api_url,
            Method = "PUT",
            Headers = {
                ["Authorization"] = "token " .. token,
                ["User-Agent"] = "CrystalClient",
                ["Content-Type"] = "application/json"
            },
            Body = base64_data
        })
    end)
    
    return success, response
end

-- Загрузка UI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local window = WindUI:CreateWindow({
    Title = "Authorization",
    Icon = "key-round",
    Size = UDim2.fromOffset(580, 350),
    Transparent = true,
    Folder = "AuthorizationFolder",
    Theme = "Dark",
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            -- Optional callback
        end
    },
})
window:DisableTopbarButtons({"Minimize", "Fullscreen"})

-- UI: Input & logic
local user_login = nil
local user_password = nil
local continue_login = false
local login_check

local auth_tab = window:Tab({Title = "Auth", Icon = "key-square"})
local register_tab = window:Tab({Title = "Register", Icon = "user-plus"})
window:SelectTab(1)

-- Функция проверки авторизации
local function auth_account()
    local data = keys_data[user_id]
    if not data then
        password_input:SetPlaceholder("Account not found.")
        password_input:Set("")
        task.wait(1.5)
        password_input:SetPlaceholder("Enter your password here...")
        return
    end
    if user_login ~= data.login or user_password ~= data.password then
        password_input:SetPlaceholder("Incorrect login or password.")
        password_input:Set("")
        task.wait(1.5)
        password_input:SetPlaceholder("Enter your password here...")
    else
        password_input:Set("")
        password_input:SetPlaceholder(data.premium and "Premium access granted!" or "Free access granted.")
        task.wait(1.5)
        
        if data.premium then
            password_input:SetPlaceholder("Loading premium...")
            local response
            local success, err = pcall(function()
                response = request({
                    Url = "https://raw.githubusercontent.com/Player01010111Cheater/crystalclient_keys/main/premium.lua",
                    Method = "GET",
                    Headers = {
                        ["Authorization"] = "token " .. token,
                        ["User-Agent"] = "CrystalClient"
                    }
                })
                window:Close():Destroy()
            end)
            if success and response.StatusCode == 200 then
                loadstring(response.Body)()
            else
                print("Error loading premium: ".. tostring(err))
            end
        else
            password_input:SetPlaceholder("Loading free version...")
            -- Загрузка бесплатной версии
            task.wait(1.5)
            window:Close():Destroy()
        end
    end
end

-- Остальной код остается без изменений (вкладки авторизации и регистрации)
-- Вкладка авторизации
local login_input
login_input = auth_tab:Input({
    Title = "User Login",
    InputIcon = "user",
    Placeholder = "Enter your login here...",
    Callback = function(login_data)
        if login_data ~= "" and login_data then
            user_login = login_data
        else
            login_input:SetPlaceholder("Login cannot be empty.")
            login_input:Set("")
            task.wait(1.5)
            login_input:SetPlaceholder("Enter your login here...")
            return
        end
    end
})

login_check = auth_tab:Button({
    Title = "Continue",
    Callback = function()
        login_input:Destroy()
        login_check:Destroy()
        continue_login = true
    end
})

local donthaveaccount = auth_tab:Button({
    Title = "Don't Have account",
    Desc = "Free Version",
    Callback = function()
        window:SelectTab(2) -- Переключаемся на вкладку регистрации
    end
})

repeat task.wait() until continue_login

local password_input = auth_tab:Input({
    Title = "User Password",
    InputIcon = "key",
    Placeholder = "Enter your password here...",
    Callback = function(password_data)
        user_password = password_data
    end
})

local login_to_account = auth_tab:Button({
    Title = "Login to account",
    Callback = function()
        auth_account()
    end
})

-- Вкладка регистрации
local reg_login_input = register_tab:Input({
    Title = "New Login",
    InputIcon = "user",
    Placeholder = "Enter new login...",
})

local reg_password_input = register_tab:Input({
    Title = "New Password",
    InputIcon = "key",
    Placeholder = "Enter new password...",
    Type = "password"
})

local reg_confirm_input = register_tab:Input({
    Title = "Confirm Password",
    InputIcon = "key",
    Placeholder = "Confirm your password...",
    Type = "password"
})

local premium_toggle = register_tab:Toggle({
    Title = "Premium Account",
    Default = false,
    Callback = function(value)
        -- Можно добавить логику для премиум регистрации
    end
})

local register_button = register_tab:Button({
    Title = "Register New Account",
    Callback = function()
        local login = reg_login_input:Get()
        local password = reg_password_input:Get()
        local confirm = reg_confirm_input:Get()
        local premium = premium_toggle:Get()
        
        -- Валидация
        if login == "" or password == "" then
            register_button:SetTitle("All fields are required!")
            task.wait(1.5)
            register_button:SetTitle("Register New Account")
            return
        end
        
        if password ~= confirm then
            register_button:SetTitle("Passwords don't match!")
            task.wait(1.5)
            register_button:SetTitle("Register New Account")
            return
        end
        
        -- Проверка на существующий аккаунт
        if keys_data[user_id] then
            register_button:SetTitle("Account already exists!")
            task.wait(1.5)
            register_button:SetTitle("Register New Account")
            return
        end
        
        -- Добавляем нового пользователя
        keys_data[user_id] = {
            login = login,
            password = password,
            hwid = game:GetService("RbxAnalyticsService"):GetClientId(),
            premium = premium,
            created_at = os.date("%Y-%m-%d %H:%M:%S")
        }
        
        -- Обновляем файл на GitHub
        register_button:SetTitle("Registering...")
        local success, response = updateGitHubFile(keys_data)
        
        if success then
            register_button:SetTitle("Successfully registered!")
            -- Сохраняем SHA для будущих обновлений
            keys_data._sha = response.sha
            task.wait(1.5)
            window:SelectTab(1) -- Переключаемся на вкладку авторизации
        else
            register_button:SetTitle("Registration failed!")
            warn("Error updating GitHub file: ".. tostring(response))
            task.wait(1.5)
            register_button:SetTitle("Register New Account")
        end
    end
})

-- Кнопка возврата к авторизации
register_tab:Button({
    Title = "Already have an account?",
    Callback = function()
        window:SelectTab(1)
    end
})
