local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index
mt.__index = newcclosure(function(self, key)
    if key == "request" then
        return function(req)
            print("Intercepted request via metatable!")
            return oldRequest(req)
        end
    end
    return oldIndex(self, key)
end)
setreadonly(mt, true)


