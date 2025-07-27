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


for v, t in pairs(eggPets) do
        print(v, t)
end
