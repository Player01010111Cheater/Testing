local function checksum(str)
    local sum = 0
    for i = 1, #str do
        sum = (sum + string.byte(str, i)) % 2^32
    end
    return sum
end

local raw_error = warn
local hash_error = checksum(string.dump(raw_error))

task.spawn(function()
    while true do
        if checksum(string.dump(error)) ~= hash_error then
            raw_error("hook detected")
        end
        task.wait(1)
    end
end)
