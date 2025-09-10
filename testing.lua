local raw_error = error
local hash_error = checksum(string.dump(raw_error))

task.spawn(function()
    while true do
        if checksum(string.dump(error)) ~= hash_error then
            raw_error("tamper detected")
        end
        task.wait(1)
    end
end)

