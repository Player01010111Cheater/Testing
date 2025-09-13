local M = {}
local _rawget = rawget
local _type = type
local _pairs = pairs
local _pcall = pcall
local _tostring = tostring

local function add(reasons, s) reasons[#reasons+1]=s end

function M.check(fnName)
    local reasons = {}
    if _type(fnName) ~= "string" or fnName == "" then return true, {"bad_arg"} end

    local raw = _rawget(_G, fnName)
    local global = _G[fnName]

    if _type(global) ~= "function" then
        add(reasons, "not_function")
        return true, reasons
    end

    if raw ~= global then
        add(reasons, "global_proxied_via_metatable")
    end

    local ok, threw = _pcall(function() return pcall(global, "__ANTI_DEBUG_CHECK__") end)
    if ok then
        if type(threw) ~= "boolean" then
            add(reasons, "unexpected_pcall_result")
        else
            if threw == true then
                add(reasons, "no_throw_behavior")
            else
                local inner_ok, inner_ret = pcall(global, "__ANTI_DEBUG_CHECK__")
                if inner_ok == true then
                    add(reasons, "error_did_not_throw")
                else
                    if tostring(inner_ret):match("__ANTI_DEBUG_CHECK__") == nil then
                        add(reasons, "error_message_mismatch")
                    end
                end
            end
        end
    else
        add(reasons, "pcall_failed")
    end

    if _type(_rawget(_G, "hookfunction")) == "function" or _type(_rawget(_G, "hookmetamethod")) == "function" then
        local s = _tostring(global)
        if not s or s:match("%f[%w]function%f[%W]") == nil then
            add(reasons, "tostring_anomaly_under_hooked_executor")
        end
    end

    local mt = nil
    local ok_mt
    ok_mt = _pcall(function() mt = getmetatable(_G) end)
    if ok_mt and _type(mt) == "table" then
        if _type(mt.__index) == "function" or _type(mt.__newindex) == "function" then
            add(reasons, "globals_metatable_hooks")
        end
    end

    if _type(debug) == "table" and _type(debug.getinfo) == "function" then
        local ok2, info = _pcall(function() return debug.getinfo(global) end)
        if ok2 and _type(info) == "table" then
            if info.what == "Lua" then add(reasons, "function_is_lua") end
            if info.what == "C" then -- builtins usually C; leave as info
            else
                -- nothing
            end
        else
            add(reasons, "debug_getinfo_unavailable")
        end
    end

    if #reasons > 0 then return true, reasons end
    return false, {}
end

local bad, reasons = M.check("error")
if bad then
    warn("Function 'error' is suspicious:", table.concat(reasons, "; "))
end

