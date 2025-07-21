local function updateGitHubFile(new_data)
    -- Validate input
    if not new_data or type(new_data) ~= "table" then
        return false, "Invalid input data"
    end

    -- Ensure HttpService is available
    local HttpService = game:GetService "HttpService"
    if not HttpService then
        return false, "HttpService not available"
    end

    -- Clone data and remove _sha field
    local data_to_save = table.clone(new_data)
    data_to_save._sha = nil

    -- Encode JSON data
    local json_data = HttpService:JSONEncode(data_to_save)
    
    -- Base64 encode content
    local base64_content
    if crypt and crypt.base64encode then
        base64_content = crypt.base64encode(json_data)
    else
        warn("No base64 encoding available, attempting to use raw JSON")
        base64_content = json_data -- Fallback to raw JSON if base64 unavailable
    end

    -- Create API payload
    local payload = {
        message = "Update user data",
        content = base64_content,
        sha = new_data._sha or nil -- Use stored SHA if available, otherwise nil
    }

    -- Encode payload to JSON
    local encoded_payload = HttpService:JSONEncode(payload)

    -- Make HTTP request
    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = api_url, -- Ensure api_url is defined elsewhere
            Method = "PUT",
            Headers = {
                ["Authorization"] = "Bearer " .. (token or ""), -- Ensure token is defined
                ["User-Agent"] = "CrystalClient",
                ["Content-Type"] = "application/json",
                ["Accept"] = "application/vnd.github.v3+json" -- Added GitHub API version
            },
            Body = encoded_payload
        })
    end)

    -- Handle response
    if success and response and response.Success and response.StatusCode == 200 then
        local response_data = HttpService:JSONDecode(response.Body)
        if response_data and response_data.content and response_data.content.sha then
            new_data._sha = response_data.content.sha -- Update SHA
            return true, response
        else
            return false, "Invalid response data structure"
        end
    else
        local error_message = response and response.StatusMessage or "Request failed"
        warn("GitHub API request failed: " .. error_message)
        return false, error_message
    end
end
