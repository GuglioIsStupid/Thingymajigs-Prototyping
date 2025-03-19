local catchGame = BaseMicrogame:extend("catchGame")

function catchGame:preload()
    self.directions = "Catch!"

    self.catchZone = {
        y = 720 - 350,
        height = 200
    }
    self.curBeat = 0
end

function catchGame:onLoad()
    self.randBeatDrop = love.math.random(1, 3)
    self.curTime = 0
    self.ok = false
    self.object = {
        y = 0,
        speedUp = 300,
        velY = 600,
        caught = false
    }
    self.curBeat = 0
end

function catchGame:start()
    self.going = false
end

function catchGame:update(dt)
    if self.going and not self.object.caught then
        self.object.y = self.object.y + self.object.velY * dt
        self.object.velY = self.object.velY + self.object.speedUp * dt
    end
end

function catchGame:onBeat()
    self.curBeat = self.curBeat + 1
    if self.curBeat == self.randBeatDrop then
        self.going = true
    end
end

function catchGame:mousepressed(_, _, button)
    if button == 1 then
        if self.object.y > self.catchZone.y and self.object.y < self.catchZone.y + self.catchZone.height then
            self.ok = true
            self.object.caught = true
        else
            self.ok = false
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