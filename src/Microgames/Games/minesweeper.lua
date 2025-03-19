local minesweeperGame = BaseMicrogame:extend("minesweeperGame")

function minesweeperGame:preload()
    self.directions = "Mark the mines!"
    self.gridSize = 10
    self.tileSize = 50
    self.mineCount = 10
    self.revealedTiles = {}
    self.flags = {}
    self.isBossMicrogame = true
end

function minesweeperGame:onLoad()
    self.grid = {}

    for x = 1, self.gridSize do
        self.grid[x] = {}
        for y = 1, self.gridSize do
            self.grid[x][y] = {
                revealed = false,
                flagged = false,
                mine = false,
                surroundingMines = 0
            }
        end
    end

    local minesPlaced = 0
    while minesPlaced < self.mineCount do
        local x = love.math.random(1, self.gridSize)
        local y = love.math.random(1, self.gridSize)

        if not self.grid[x][y].mine then
            self.grid[x][y].mine = true
            minesPlaced = minesPlaced + 1
        end
    end

    for x = 1, self.gridSize do
        for y = 1, self.gridSize do
            if not self.grid[x][y].mine then
                self.grid[x][y].surroundingMines = self:getSurroundingMines(x, y)
            end
        end
    end
end

function minesweeperGame:start()
    self.going = true
end

function minesweeperGame:update(dt)
end

function minesweeperGame:getSurroundingMines(x, y)
    local surroundingMines = 0
    for i = -1, 1 do
        for j = -1, 1 do
            if i == 0 and j == 0 then
                goto continue
            end

            local nx, ny = x + i, y + j
            if nx >= 1 and nx <= self.gridSize and ny >= 1 and ny <= self.gridSize then
                if self.grid[nx][ny].mine then
                    surroundingMines = surroundingMines + 1
                end
            end

            ::continue::
        end
    end
    return surroundingMines
end

function minesweeperGame:mousepressed(x, y, button)
    if self.going and not self.gameOver then
        x = x - Resolution.Width / 2 + (self.gridSize * self.tileSize) / 2
        y = y - Resolution.Height / 2 + (self.gridSize * self.tileSize) / 2
        local gridX = math.floor(x / self.tileSize) + 1
        local gridY = math.floor(y / self.tileSize) + 1

        if button == 1 then
            if not self.grid[gridX] or not self.grid[gridX][gridY] then
                return
            end
            if not self.grid[gridX][gridY].flagged then
                self:revealTile(gridX, gridY)
            end
        elseif button == 2 then
            self:toggleFlag(gridX, gridY)
        end
    end
end

function minesweeperGame:revealTile(x, y)
    if self.grid[x][y].revealed or self.grid[x][y].flagged then
        return
    end

    self.grid[x][y].revealed = true

    if self.grid[x][y].mine then
        self.fail = true
        self.ok = false
    elseif self.grid[x][y].surroundingMines == 0 then
        for i = -1, 1 do
            for j = -1, 1 do
                if i == 0 and j == 0 then
                    goto continue
                end

                local nx, ny = x + i, y + j
                if nx >= 1 and nx <= self.gridSize and ny >= 1 and ny <= self.gridSize then
                    self:revealTile(nx, ny)
                end

                ::continue::
            end
        end
    end

    self:checkWin()
end

function minesweeperGame:toggleFlag(x, y)
    if not self.grid[x][y].revealed then
        self.grid[x][y].flagged = not self.grid[x][y].flagged
    end
end

function minesweeperGame:checkWin()
    local safeTilesRevealed = 0
    local totalSafeTiles = (self.gridSize * self.gridSize) - self.mineCount

    for x = 1, self.gridSize do
        for y = 1, self.gridSize do
            if self.grid[x][y].revealed and not self.grid[x][y].mine then
                safeTilesRevealed = safeTilesRevealed + 1
            end
        end
    end

    if safeTilesRevealed == totalSafeTiles then
        self.ok = true
    end
end

-- blue, green, red, purple, orange, yellow, cyan, pink
local bombColourOrder = {
    {0, 0, 1},
    {0, 1, 0},
    {1, 0, 0},
    {1, 0, 1},
    {1, 0.5, 0},
    {1, 1, 0},
    {0, 1, 1},
    {1, 0.5, 1}
}
function minesweeperGame:draw()
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
    love.graphics.setColor(1, 1, 1)
    love.graphics.push()
    love.graphics.translate(Resolution.Width / 2 - (self.gridSize * self.tileSize) / 2, Resolution.Height / 2 - (self.gridSize * self.tileSize) / 2)
    
    for x = 1, self.gridSize do
        for y = 1, self.gridSize do
            local tile = self.grid[x][y]
            local xPos = (x - 1) * self.tileSize
            local yPos = (y - 1) * self.tileSize

            if tile.revealed then
                love.graphics.setColor(0.8, 0.8, 0.8)
                love.graphics.rectangle("fill", xPos, yPos, self.tileSize, self.tileSize)
                if tile.surroundingMines > 0 then
                    love.graphics.setColor(bombColourOrder[tile.surroundingMines])
                    love.graphics.print(tile.surroundingMines, xPos + 18, yPos + 18)
                end

                if tile.mine then
                    love.graphics.setColor(1, 0, 0)
                    love.graphics.circle("fill", xPos + 25, yPos + 25, 10)
                end
            else
                love.graphics.setColor(0.5, 0.5, 0.5)
                love.graphics.rectangle("fill", xPos, yPos, self.tileSize, self.tileSize)
                if tile.flagged then
                    love.graphics.setColor(1, 0, 0)
                    love.graphics.print("F", xPos + 18, yPos + 18)
                end
            end

            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("line", xPos, yPos, self.tileSize, self.tileSize)
        end
    end

    love.graphics.setColor(1, 1, 1)

    love.graphics.pop()

    love.graphics.printf("Mines: " .. self.mineCount, 0, 75, Resolution.Width, "center")
end

return minesweeperGame
