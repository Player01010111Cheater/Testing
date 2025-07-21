local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local api_url = "https://api.github.com/repos/Player01010111Cheater/crystalclient_keys/contents/keys.json"
local premium_url = "https://api.github.com/repos/Player01010111Cheater/crystalclient_keys/contents/premium.lua"
local user_id = tostring(Players.LocalPlayer.UserId)
local token = "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" -- Замените на новый PAT с правами repo

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
                ["Authorization"] = "Bearer " .. token, -- Используем Bearer
                ["User-Agent"] = "CrystalClient",
                ["Accept"] = "application/vnd.github.v3+json",
                ["X-GitHub-Api-Version"] = "2022-11-28" -- Добавляем версию API
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
                        ["Authorization"] = "Bearer " .. token, -- Используем Bearer
                        ["User-Agent"] = "CrystalClient",
                        ["Content-Type"] = "application/json",
                        ["Accept"] = "application/vnd.github.v3+json",
                        ["X-GitHub-Api-Version"] = "2022-11-28"
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
                ["Authorization"] = "Bearer " .. token, -- Используем Bearer
                ["User-Agent"] = "CrystalClient",
                ["Content-Type"] = "application/json",
                ["Accept"] = "application/vnd.github.v3+json",
                ["X-GitHub-Api-Version"] = "2022-11-28"
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

-- Ваш остальной код (UI, авторизация, регистрация) остается без изменений
-- Вставьте сюда остальную часть вашего кода (от WindUI до конца)
