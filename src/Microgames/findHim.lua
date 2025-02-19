local findHim = {}

function findHim:preload()
    self.directions = "Find Him."
    self.assetsFolder = "Assets/Microgames/findHim/"
    self.chests = {}
end

function findHim:onLoad()
    self.dudePosition = love.math.random(1, 5)
    self.chests = {}
    for i = 1, 5 do
        self.chests[i] = {}
        self.chests[i].width = love.math.random(50, 150)
        self.chests[i].height = love.math.random(50, 150)
        self.chests[i].x = love.math.random(0, 1280 - self.chests[i].width)
        self.chests[i].y = love.math.random(0, 720 - self.chests[i].height)
    end

    -- dont allow overlapping chests
    for i = 1, 5 do
        for j = 1, 5 do
            if i ~= j then
                while self.chests[i].x + self.chests[i].width > self.chests[j].x and self.chests[i].x < self.chests[j].x + self.chests[j].width and self.chests[i].y + self.chests[i].height > self.chests[j].y and self.chests[i].y < self.chests[j].y + self.chests[j].height do
                    self.chests[i].x = love.math.random(0, 1280 - self.chests[i].width)
                    self.chests[i].y = love.math.random(0, 720 - self.chests[i].height)
                end
            end
        end
    end
    self.ok = false
end

function findHim:start()
    self.ok = false
    self.failed = false
end

function findHim:close()
end

function findHim:update(dt)
end

function findHim:checkForCompletion()
    return self.ok and not self.failed
end

function findHim:draw()
    for i, chest in ipairs(self.chests) do
        love.graphics.setColor(1, 0.647, 0)
        love.graphics.rectangle("fill", chest.x, chest.y, chest.width, chest.height)
        if chest.open then
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", chest.x, chest.y, chest.width, chest.height)
        end
    end
    
    if self.ok then
        love.graphics.setColor(0, 1, 0)
        -- get the smallest dimension of the chest
        local r = math.min(self.chests[self.dudePosition].width, self.chests[self.dudePosition].height) / 2.75
        love.graphics.circle("fill", self.chests[self.dudePosition].x + self.chests[self.dudePosition].width / 2, self.chests[self.dudePosition].y + self.chests[self.dudePosition].height / 2, r)
    end

    love.graphics.setColor(1, 1, 1)
end

function findHim:mousepressed(x, y, button)
    if button == 1 then
        for i, chest in ipairs(self.chests) do
            if x >= chest.x and x <= chest.x + chest.width and y >= chest.y and y <= chest.y + chest.height then
                chest.open = true
                if i == self.dudePosition then
                    self.ok = true
                end
            end
        end
    end
end

function findHim:fail()
    return nil
end

return findHim
