local v_u_1 = game:GetService("ReplicatedStorage")
local v8 = v_u_1.GameEvents.EggReadyToHatch_RE
local connections = getconnections(v8.OnClientEvent) -- Предполагается, что getconnections доступен

for _, v in pairs(connections) do
    local upvalueName, upvalueValue = debug.getupvalue(v.Function, 1)
    if upvalueName then
        print("Upvalue name:", upvalueName, "Value:", upvalueValue)
        if type(upvalueValue) == "table" then
            for uuid, petData in pairs(upvalueValue) do
                print("Egg UUID:", uuid)
                print("Pet Data:", petData)
                if type(petData) == "table" then
                    for key, value in pairs(petData) do
                        print("Key:", key, "Value:", value)
                    end
                elseif type(petData) == "string" then
                    print("Pet Name:", petData)
                else
                    print("Pet Data Type:", type(petData))
                end
            end
        end
    else
        print("No upvalue found")
    end
end
