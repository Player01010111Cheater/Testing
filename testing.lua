local ListGame = {
	["3808223175"] = "4fe2dfc202115670b1813277df916ab2", -- Jujutsu Infinite
	["994732206"]  = "e2718ddebf562c5c4080dfce26b09398", -- Blox Fruits
	["1650291138"] = "9b64d07193c7c2aef970d57aeb286e70", -- Demon Fall
	["5750914919"] = "8bbc8a7c4e023bc0c80799fec3233162", -- Fisch
	["66654135"]   = "9c916252a9f79bbf5a108f97c531e807", -- Murder Mystery 2
	["3317771874"] = "e95ef6f27596e636a7d706375c040de4", -- Pet Simulator 99
	["1511883870"] = "fefdf5088c44beb34ef52ed6b520507c", -- Shindo Life
	["6035872082"] = "3bb7969a9ecb9e317b0a24681327c2e2", -- Rivals
	["245662005"]  = "21ad7f491e4658e9dc9529a60c887c6e", -- Jailbreak
	["7018190066"] = "98f5c64a0a9ecca29517078597bbcbdb", -- Dead Rails
	["7074860883"] = "0c8fdf9bb25a6a7071731b72a90e3c69", -- Anime Crossover
	["7436755782"] = "e4ea33e9eaf0ae943d59ea98f2444ebe", -- Grow a Garden
	["210851291"]  = "b3400f5a4e28cad1e1110b45004c3837", -- Build a Boat
	["6931042565"] = "036786acbfa6e6e030dce074faa1173f", -- Volleyball Legends
	["7326934954"] = "00e140acb477c5ecde501c1d448df6f9", -- 99 Nights in the Forest
	["7822444776"] = "ba4595cfb82d2434a478b9003f3674b4", -- Build a Plane
	["4871329703"] = "646e60921195f2b2d59015703b0b100a", -- TypeSoul
	["5578556129"] = "ba96a23ddff0c5b40e67eb1c0f2997c4", -- Anime Vanguards
	["1000233041"] = "c08f7269fc31f6a60ec57ecfacfdb34e", -- 3008
	["7750955984"] = "283d81b313c32e170c4545392802a347", -- Hunty Zombie
}

-- функция из твоего кода
local v1 = {}
local v_u_3 = buffer and buffer.tostring or function(b) return tostring(b) end
local v_u_4 = buffer and buffer.fromstring or function(s) return s end
function v1.revert(p6) return v_u_4(p6) end
function v1.convert(p51) return v_u_3(p51) end

-- вывод всех декодированных значений построчно
for gameId, code in pairs(ListGame) do
	local ok, decoded = pcall(function()
		return v1.revert(code)
	end)
	if ok then
		print("GameId:", gameId, "| Decoded:", decoded)
	else
		print("GameId:", gameId, "| Ошибка при декоде")
	end
end
