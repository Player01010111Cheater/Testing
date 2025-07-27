local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

local localPlayer = players.LocalPlayer
local currentCamera = workspace.CurrentCamera

-- Ждём загрузки игрока и камеры
repeat task.wait() until game:IsLoaded() and localPlayer and currentCamera

-- Получаем функцию из ивента (не трогаем C-функции напрямую)
local hatchFunction = getupvalue(getupvalue(getconnections(replicatedStorage.GameEvents.PetEggService.OnClientEvent)[1].Function, 1), 2)
local eggModels = getupvalue(hatchFunction, 1)
local eggPets = getupvalue(hatchFunction, 2)

local espCache = {}
local activeEggs = {}

-- Получить объект яйца по UUID
local function getObjectFromId(objectId)
    for _, eggModel in pairs(eggModels) do
        if eggModel:GetAttribute("OBJECT_UUID") == objectId then
            return eggModel
        end
    end
end

-- Обновить текст ESP (например, когда появился питомец)
local function UpdateEsp(objectId, petName)
    local object = getObjectFromId(objectId)
    if not object or not espCache[objectId] then return end

    local eggName = object:GetAttribute("EggName")
    espCache[objectId].Text = {eggName} | {petName}
end

-- Создать ESP над яйцом
local function AddEsp(object)
    -- Можно отключить фильтр по владельцу, если нужно видеть все яйца:
    -- if object:GetAttribute("OWNER") ~= localPlayer.Name then return end

    local eggName = object:GetAttribute("EggName") or "?"
    local objectId = object:GetAttribute("OBJECT_UUID")
    if not objectId then return end

    local petName = eggPets[objectId] or "?"

    local label = Drawing.new("Text")
    label.Text = {eggName} | {petName}
    label.Size = 18
    label.Color = Color3.new(1, 1, 1)
    label.Outline = true
    label.OutlineColor = Color3.new(0, 0, 0)
    label.Center = true
    label.Visible = false

    espCache[objectId] = label
    activeEggs[objectId] = object
end

-- Удалить ESP при удалении яйца
local function RemoveEsp(object)
    local objectId = object:GetAttribute("OBJECT_UUID")
    if espCache[objectId] then
        espCache[objectId]:Remove()
        espCache[objectId] = nil
    end

    activeEggs[objectId] = nil
end

-- Обновление позиции всех ESP
local function UpdateAllEsp()
    for objectId, object in pairs(activeEggs) do
        if not object or not object:IsDescendantOf(workspace) then
            activeEggs[objectId] = nil
            if espCache[objectId] then
                espCache[objectId].Visible = false
            end
            continue
        end

        local label = espCache[objectId]
        if label then
            local pos, onScreen = currentCamera:WorldToViewportPoint(object:GetPivot().Position)
            if onScreen then
                label.Position = Vector2.new(pos.X, pos.Y)
                label.Visible = true
            else
                label.Visible = false
            end
        end
    end
end

-- Ждём появления первых яиц
task.wait(1)

-- Добавить все уже существующие яйца
for _, object in pairs(collectionService:GetTagged("PetEggServer")) do
    task.spawn(AddEsp, object)
end

-- Подключение появления новых яиц
collectionService:GetInstanceAddedSignal("PetEggServer"):Connect(AddEsp)
collectionService:GetInstanceRemovedSignal("PetEggServer"):Connect(RemoveEsp)

-- Обработка события "яйцо готово к вылуплению" — обновляем имя питомца
replicatedStorage.GameEvents.EggReadyToHatch_RE.OnClientEvent:Connect(function(objectId, petName)
    print(objectId, petName)
end)

-- Постоянно обновляем ESP
runService.PreRender:Connect(UpdateAllEsp)
