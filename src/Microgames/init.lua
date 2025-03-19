local path = (... .. "."):gsub("init.", "")

BaseMicrogame = require(path .. "Base.baseMicrogame")

--[[ testMicrogame = require(path .. "testMicrogame")
blendingIn = require(path .. "blendingIn")
findHim = require(path .. "findHim")
catchMicrogame = require(path .. "catchGame")
harmoni = require(path .. "harmoni")
rpgBattle = require(path .. "rpgBattle")
minesweeper = require(path .. "minesweeper") ]]

local fixedPath = path:gsub("%.", "/")
local files = love.filesystem.getDirectoryItems("Microgames/Games")
MICROGAMES = {}
BOSSGAMES = {}
for i, file in ipairs(files) do
    if file:sub(-4) == ".lua" then
        local data = love.filesystem.load("Microgames/Games/" .. file)()
        --[[ table.insert(MICROGAMES, chunk()) ]]
        data:preload()
        if data.isBossMicrogame then
            table.insert(BOSSGAMES, data)
        else
            table.insert(MICROGAMES, data)
        end
    end
end
