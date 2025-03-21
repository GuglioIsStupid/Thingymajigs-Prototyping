local reelIn = BaseMicrogame:extend("reelIn")

function reelIn:start()
    self.ok = false
end

function reelIn:preload()
    self.reel = {}
    self.directions = "Reel it In!"
end

function reelIn:onLoad()
    self.reel = {
        x = 200,
        y = 200,
        size = 75,
        angle = 0,
        previousAngle = 0,
        isHeld = false
    }
end

function reelIn:mousepressed(x,y,button)
    print(button)

    if button == 1 then
        self.reel.isHeld = true
        print("COCKCOCK")
    end
end

function reelIn:mousereleased(x,y,button)
    print(button)
    if button == 1 then
        self.reel.isHeld = false
    end
end

function reelIn:update(dt)
    if self.reel.isHeld then
        local angleBetweenReelAndMouse = math.atan2(Mouse.y - self.reel.y, Mouse.x - self.reel.x)  -- these fucking variable names dude
        local differenceInNewAndOldAngles = angleBetweenReelAndMouse - self.reel.previousAngle
        self.reel.angle = self.reel.angle + differenceInNewAndOldAngles
        self.reel.previousAngle = angleBetweenReelAndMouse
    end
end

function reelIn:checkForCompletion()
    return self.ok
end

function reelIn:draw()
   -- love.graphics.print("isHeld? " .. (self.reel.isHeld or "PENISCOCK"), 100, 100)
    love.graphics.print("Press any key to complete", 100, 120)
    love.graphics.push()
    love.graphics.translate(self.reel.x, self.reel.y)
    love.graphics.rotate(self.reel.angle)

    -- Draw self.reel (circle with a line to show rotation)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", 0, 0, self.reel.size)
    love.graphics.line(0, 0, self.reel.size, 0)

    love.graphics.pop()
end

function reelIn:keypressed(key) 
    print("are")
    self.ok = true
end


function reelIn:fail()
    return nil
end

return reelIn