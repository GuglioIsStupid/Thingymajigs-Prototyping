local BaseMicrogame = MiniClass:extend("BaseMicrogame")

function testMicrogame:start()
    self.ok = false
end

function testMicrogame:update(dt)
end

function testMicrogame:checkForCompletion()
    return self.ok
end

function testMicrogame:draw()
    
end

function testMicrogame:keypressed(key)
end

function testMicrogame:mousepressed(button)
end

function testMicrogame:fail()
    return nil
end

return BaseMicrogame