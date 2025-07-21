local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local api_url = "https://api.github.com/repos/Player01010111Cheater/crystalclient_keys/contents/keys.json"
local premium_url = "https://api.github.com/repos/Player01010111Cheater/crystalclient_keys/contents/premium.lua"
local user_id = tostring(Players.LocalPlayer.UserId)
local token = "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" -- Замените на новый PAT

-- Получение JSON и SHA
local keys_data = {}
local current_sha = nil

local function fetchGitHubFile()
    print("Попытка загрузки keys.json с GitHub...")
    local success, response = pcall(function()
        return request({
            Url = api_url .. "?ref=main", -- Явно указываем ветку
            Method = "GET",
            Headers = {
                ["Authorization"] = "token " .. token,
                ["User-Agent"] = "CrystalClient",
                ["Accept"] = "application/vnd.github.v3+json"
            }
        })
    end)

    if success and response then
        print("GET-запрос завершен. Код статуса:", response.StatusCode or "N/A")
        print("Сообщение статуса:", response.StatusMessage or "N/A")
        print("Тело ответа:", response.Body or "N/A")

        if response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.content and data.sha then
                if crypt and crypt.base64decode then
                    local decoded_content = crypt.base64decode(data.content:gsub("\n", ""))
                    keys_data = HttpService:JSONDecode(decoded_content)
                    current_sha = data.sha
                    print("Файл keys.json загружен, SHA:", current_sha)
                    print("Данные keys_data:", HttpService:JSONEncode(keys_data))
                else
                    warn("Ошибка: crypt.base64decode недоступен")
                    keys_data = {}
                end
            else
                warn("Ошибка: Ответ GitHub не содержит content или sha")
                keys_data = {}
            end
        elseif response.StatusCode == 404 then
            warn("Файл keys.json не найден, будет создан новый")
            -- Создаем пустой файл keys.json
            local empty_data = {}
            local json_data = HttpService:JSONEncode(empty_data)
            local base64_content = crypt and crypt.base64encode and crypt.base64encode(json_data) or nil
            if not base64_content then
                warn("Ошибка: crypt.base64encode недоступен")
                return
            end
            local payload = {
                message = "Create keys.json",
                content = base64_content,
                branch = "main"
            }
            local encoded_payload = HttpService:JSONEncode(payload)
            print("Payload для создания файла:", encoded_payload)

            local create_success, create_response = pcall(function()
                return request({
                    Url = api_url,
                    Method = "PUT",
                    Headers = {
                        ["Authorization"] = "token " .. token,
                        ["User-Agent"] = "CrystalClient",
                        ["Content-Type"] = "application/json",
                        ["Accept"] = "application/vnd.github.v3+json"
                    },
                    Body = encoded_payload
                })
            end)

            if create_success and create_response and create_response.StatusCode == 201 then
                local create_data = HttpService:JSONDecode(create_response.Body)
                current_sha = create_data.content.sha
                keys_data = empty_data
                print("Файл keys.json создан, SHA:", current_sha)
            else
                warn("Ошибка создания файла: Код", create_response and create_response.StatusCode or "N/A", "Сообщение:", create_response and create_response.StatusMessage or tostring(create_response))
                print("Тело ответа при создании:", create_response and create_response.Body or "N/A")
            end
        else
            warn("Ошибка загрузки keys.json: Код", response.StatusCode or "N/A", "Сообщение:", response.StatusMessage or tostring(response))
            print("Тело ответа:", response.Body or "N/A")
            keys_data = {}
        end
    else
        warn("Ошибка pcall в fetchGitHubFile:", tostring(response))
        keys_data = {}
    end
end

fetchGitHubFile()

-- Функция для обновления файла на GitHub
local function updateGitHubFile(new_data)
    if not new_data or type(new_data) ~= "table" then
        warn("Ошибка: Неверные входные данные")
        return false, "Invalid input data"
    end

    if not HttpService then
        warn("Ошибка: HttpService недоступен")
        return false, "HttpService not available"
    end

    if not api_url or not token then
        warn("Ошибка: api_url или token не определены")
        return false, "api_url or token not defined"
    end

    if not current_sha then
        warn("Ошибка: SHA не получен, невозможно обновить файл")
        return false, "SHA not available"
    end

    -- Клонирование данных
    local data_to_save = table.clone(new_data)
    data_to_save._sha = nil

    -- Кодирование в JSON
    local json_data = HttpService:JSONEncode(data_to_save)
    print("JSON данные:", json_data)

    -- Кодирование в base64
    if not crypt or not crypt.base64encode then
        warn("Ошибка: Библиотека crypt или crypt.base64encode недоступна")
        return false, "Base64 encoding unavailable"
    end
    local base64_content = crypt.base64encode(json_data)
    print("Base64 закодировано:", base64_content)

    -- Формирование payload
    local payload = {
        message = "Update user data",
        content = base64_content,
        sha = current_sha,
        branch = "main"
    }
    local encoded_payload = HttpService:JSONEncode(payload)
    print("Payload:", encoded_payload)

    -- Выполнение PUT-запроса
    local success, response = pcall(function()
        return request({
            Url = api_url,
            Method = "PUT",
            Headers = {
                ["Authorization"] = "token " .. token,
                ["User-Agent"] = "CrystalClient",
                ["Content-Type"] = "application/json",
                ["Accept"] = "application/vnd.github.v3+json"
            },
            Body = encoded_payload
        })
    end)

    -- Обработка ответа
    if success and response and response.StatusCode == 200 then
        local response_data = HttpService:JSONDecode(response.Body)
        if response_data and response_data.content and response_data.content.sha then
            current_sha = response_data.content.sha -- Обновляем SHA
            print("Файл успешно обновлен, новый SHA:", current_sha)
            return true, response
        else
            warn("Ошибка: Неверная структура ответа GitHub")
            return false, "Invalid response data structure"
        end
    else
        local error_message = response and response.StatusMessage or tostring(response)
        warn("Ошибка GitHub API: Код", response and response.StatusCode or "N/A", "Сообщение:", error_message)
        print("Тело ответа:", response and response.Body or "N/A")
        return false, error_message
    end
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
        Callback = function() end
    }
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

-- Вкладка авторизации
local login_input
login_input = auth_tab:Input({
    Title = "User Login",
    InputIcon = "user",
    Placeholder = "Enter your login here...",
    Callback = function(login_data)
        if login_data and login_data ~= "" then
            user_login = login_data
        else
            login_input:SetPlaceholder("Login cannot be empty.")
            login_input:Set("")
            task.wait(1.5)
            login_input:SetPlaceholder("Enter your login here...")
        end
    end
})

login_check = auth_tab:Button({
    Title = "Continue",
    Callback = function()
        if user_login then
            login_input:Destroy()
            login_check:Destroy()
            continue_login = true
        else
            login_input:SetPlaceholder("Please enter a login first.")
            task.wait(1.5)
            login_input:SetPlaceholder("Enter your login here...")
        end
    end
})

auth_tab:Button({
    Title = "Don't Have account",
    Desc = "Free Version",
    Callback = function()
        window:SelectTab(2)
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
        task.wait(1.5)
        
        if data.premium then
            password_input:SetPlaceholder("Loading premium...")
            local success, response = pcall(function()
                return request({
                    Url = premium_url,
                    Method = "GET",
                    Headers = {
                        ["Authorization"] = "token " .. token,
                        ["User-Agent"] = "CrystalClient",
                        ["Accept"] = "application/vnd.github.v3+json"
                    }
                })
            end)
            if success and response and response.StatusCode == 200 then
                local data = HttpService:JSONDecode(response.Body)
                if data.content then
                    local script = crypt.base64decode(data.content)
                    window:Close():Destroy()
                    loadstring(script)()
                else
                    print("Ошибка: Нет содержимого в premium.lua")
                end
            else
                print("Ошибка загрузки premium.lua: Код", response and response.StatusCode or "N/A", "Сообщение:", response and response.StatusMessage or tostring(response))
                print("Тело ответа:", response and response.Body or "N/A")
            end
        else
            password_input:SetPlaceholder("Loading free version...")
            task.wait(1.5)
            window:Close():Destroy()
        end
    end
end

auth_tab:Button({
    Title = "Login to account",
    Callback = function()
        auth_account()
    end
})

-- Вкладка регистрации
local newlogin = nil
local newpassword = nil
local confirmpassword = nil
local reg_login_input = register_tab:Input({
    Title = "New Login",
    InputIcon = "user",
    Placeholder = "Enter new login...",
    Callback = function(input)
        newlogin = input
    end
})

local reg_password_input = register_tab:Input({
    Title = "New Password",
    InputIcon = "key",
    Placeholder = "Enter new password...",
    Callback = function(input)
        newpassword = input
    end
})

local reg_confirm_input = register_tab:Input({
    Title = "Confirm Password",
    InputIcon = "key",
    Placeholder = "Confirm your password...",
    Callback = function(input)
        confirmpassword = input
    end
})

register_tab:Button({
    Title = "Register New Account",
    Callback = function()
        if not newlogin or not newpassword or not confirmpassword then
            reg_confirm_input:SetPlaceholder("All fields must be filled.")
            task.wait(1.5)
            reg_confirm_input:SetPlaceholder("Confirm your password...")
            return
        end
        if newpassword ~= confirmpassword then
            reg_confirm_input:SetPlaceholder("Passwords do not match.")
            reg_confirm_input:Set("")
            task.wait(1.5)
            reg_confirm_input:SetPlaceholder("Confirm your password...")
            return
        end

        keys_data[user_id] = {
            login = newlogin,
            password = newpassword,
            hwid = game:GetService("RbxAnalyticsService"):GetClientId(),
            premium = false,
            created_at = os.date("%Y-%m-%d %H:%M:%S")
        }

        local success, response = updateGitHubFile(keys_data)
        if success then
            print("Регистрация успешна, данные сохранены на GitHub")
            reg_confirm_input:SetPlaceholder("Registration successful!")
            task.wait(1.5)
            window:SelectTab(1)
        else
            warn("Ошибка регистрации:", response)
            reg_confirm_input:SetPlaceholder("Registration failed: " .. tostring(response))
            task.wait(1.5)
            reg_confirm_input:SetPlaceholder("Confirm your password...")
        end
    end
})

register_tab:Button({
    Title = "Already have an account?",
    Callback = function()
        window:SelectTab(1)
    end
})
