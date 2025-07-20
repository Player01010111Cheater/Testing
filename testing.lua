local v_u_1 = game:GetService("ReplicatedStorage")
local v8 = v_u_1.GameEvents.EggReadyToHatch_RE

-- Функция для проверки питомца
local function getPetByUUID(uuid)
    local connections = getconnections(v8.OnClientEvent)
    for i, v in pairs(connections) do
        local upvalueName, upvalueValue = debug.getupvalue(v.Function, 1)
        if type(upvalueValue) == "table" then
            local petData = upvalueValue[uuid]
            if petData then
                print("Pet Data for egg", uuid, ":", petData)
                if type(petData) == "table" then
                    for key, value in pairs(petData) do
                        print("Key:", key, "Value:", value)
                    end
                elseif type(petData) == "string" then
                    print("Pet Name:", petData)
                else
                    print("Pet Data Type:", type(petData))
                end
            else
                print("No pet data for egg", uuid)
            end
            return
        end
    end
    print("Could not access v_u_11 for egg", uuid)
end

-- Проверка всех яиц
for _, egg in pairs(game:GetService("CollectionService"):GetTagged("PetEggServer")) do
    local uuid = egg:GetAttribute("OBJECT_UUID")
    local ready = egg:GetAttribute("READY")
    local eggName = egg:GetAttribute("EggName")
    print("Egg:", egg.Name, "UUID:", uuid, "READY:", ready, "EggName:", eggName)
    if ready then
        getPetByUUID(uuid)
    else
        print("Egg", uuid, "is not ready yet.")
    end
end
