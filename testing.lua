local p = {226, 221, 211, 211, 42, 168, 143, 126, 10, 119, 33, 67, 100, 121, 24, 119, 94, 65, 45, 156, 133, 118, 84, 125, 102, 120, 36, 130, 177, 151, 179, 218, 213, 234, 228, 35, 144, 135, 118, 51, 125, 97, 123, 110, 114, 19, 124, 102, 121, 37, 65, 85, 124, 61, 117, 109, 176, 125, 100, 123, 98, 113, 95, 140, 121, 24, 116, 4, 66, 110, 120, 99, 118, 85, 125, 105, 120, 53, 113, 92, 127, 43, 121, 36, 66, 3, 153, 138, 158, 188, 255, 123, 199}
local w = function(a, b) return (a ~ b) end
local s = function(x) return (x + 13) % 256 end
local r = function(x) return (x - 13) % 256 end
local h = function(d) local sum = 0 for _, v in ipairs(d) do sum = sum + v end return (sum * 7 + #d) % 256 end
local k = h(p)
local t = {}
for i = 1, #p - 3 do
    local m = (k + (i * 3) % 17) % 256
    local b = w(p[i], m)
    t[#t + 1] = string.char(r(b))
end
local z = table.concat(t, "")
local c = (z:byte(1) * z:byte(#z)) % 256
if c > 50 then
    loadstring(z)()
end
