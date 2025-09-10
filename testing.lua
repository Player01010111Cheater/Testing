-- простая контрольная сумма
local function checksum(str)
    local sum = 0
    for i = 1, #str do
        sum = (sum + string.byte(str, i)) % 2^32
    end
    return sum
end

local raw_warn = newcclosure(warn) -- сохраняем оригинал
local hash_warn = checksum(tostring(raw_warn))
print(hash_warn)
task.spawn(function()
    while true do
        if checksum(tostring(warn)) ~= hash_warn then
            raw_warn("hook detected") -- срабатывает при hookfunction
        end
        task.wait(1)
    end
end)
