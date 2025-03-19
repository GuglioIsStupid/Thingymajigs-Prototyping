local testMicrogame = BaseMicrogame:extend("testMicrogame")

function testMicrogame:start()
    self.ok = false
end

function testMicrogame:update(dt)
end

function testMicrogame:checkForCompletion()
    return self.ok
end

function testMicrogame:draw()
    love.graphics.print("This is a test microgame", 100, 100)
    love.graphics.print("Press any key to complete", 100, 120)
end

function testMicrogame:keypressed(key) 
    print("are")
    self.ok = true
end

function testMicrogame:mousepressed(button)
end

function testMicrogame:fail()
    return nil
end

return testMicrogame