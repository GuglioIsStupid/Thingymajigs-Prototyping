local BaseMicrogame = MiniClass:extend("BaseMicrogame")

function BaseMicrogame:preload()
    self.isBossMicrogame = false
    self.directions = "RESET ME!"
    self.ok = false
end

function BaseMicrogame:start()
    self.ok = false
end

function BaseMicrogame:onLoad()
end

function BaseMicrogame:update(dt)
end

function BaseMicrogame:checkForCompletion()
    return self.ok
end

function BaseMicrogame:draw()
    
end

function BaseMicrogame:keypressed(key)
end

function BaseMicrogame:mousepressed(button)
end

function BaseMicrogame:fail()
    return nil
end

return BaseMicrogame