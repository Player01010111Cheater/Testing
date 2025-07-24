local Neverlose_Main = loadstring(game:HttpGet"https://github.com/Mana42138/Neverlose-UI/blob/main/Source.lua")()

local Win = Neverlose_Main:Window({
    Title = "NEVERLOSE",
    CFG = "Neverlose",
    Key = Enum.KeyCode.H,
    External = {
        KeySystem = true,
        Key = {
            "Test",
            "Beta"
        }
    }
})

local TabSection1 = Win:TSection("Misc")
local Main = TabSection1:Tab("Main")
local MainSection = Main:Section("Main Section")
local ConfigSection = Main:Section("Config")


local ToggleVar = MainSection:Toggle("Toggle", function(t)
    ValueToggle = t
end)
ToggleVar:Set(true) -- can be true or false

local SmallTable = {"Mana64", "Lmao", "HVH"}
local SelectConfigVar = Config:Dropdown("Select Config", SmallTable, function(t)
    ValueDropdown = t
    print(ValueDropdown)
end)
SelectConfigVar:Set("Mana64") -- any existing name in the table, e.g., "Mana64"
SelectConfigVar:Refresh({"New Mana64", "Legit"}) -- Refresh the dropdown with new table values
