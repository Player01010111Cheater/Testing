debug.setmetatable(setclipboard, {
    __newindex = function() 
        error("Cannot modify protected function") 
    end,
    __metatable = "locked"
})
