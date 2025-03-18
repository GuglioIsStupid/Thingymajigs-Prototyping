local catchGame = BaseMicrogame:extend("catchGame")

function catchGame:preload()
    self.directions = "Catch!"

    self.catchZone = {
        y = 720 - 350,
        height = 200
    }
end

function catchGame:onLoad()
    self.randDropTime = love.math.random(0.5, microgameHandler.microgameTime * 0.7)
    self.curTime = 0
    self.ok = false
    self.object = {
        y = 0,
        speedUp = 300,
        velY = 600,
        caught = false
    }
end

function catchGame:start()
    self.going = true
end

function catchGame:update(dt)
    if self.going then
        self.curTime = self.curTime + dt

        if self.curTime >= self.randDropTime and not self.object.caught then
            self.object.y = self.object.y + self.object.velY * dt
            self.object.velY = self.object.velY + self.object.speedUp * dt
        end
    end
end

function catchGame:mousepressed(_, _, button)
    if self.going then
        if (self.object.y + 100) >= self.catchZone.y and self.object.y <= (self.catchZone.y + self.catchZone.height) and not self.failed then
            self.object.caught = true
            self.ok = true
        else
            self.failed = true
        end
    end
end

function catchGame:draw()
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 1280/2-50, self.object.y, 100, 100)
    love.graphics.setColor(1, 1, 1)

    -- render catchZone (Temporary until assets!)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("line", 0, self.catchZone.y, 1280, self.catchZone.height)
    love.graphics.setColor(1, 1, 1)
end

return catchGame