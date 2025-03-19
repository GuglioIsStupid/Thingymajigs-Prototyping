local countRunners = BaseMicrogame:extend("countRunners")

function countRunners:start()
end

function countRunners:onLoad()
    self.ok = false
    self.runners = {}
    self.count = 0
    for i = 1,love.math.random(6,12) do
        table.insert(self.runners, {x = -200, y = love.graphics.getHeight/2-100, speed = love.math.random(0.7,1.3)})
    end

    self.button = {x = 100, y = 400, width = 75, height = 75, down = false, text = "Press Me"}

end

function countRunners:update(dt)
end

function countRunners:pressButton()
    local button = self.button
    button.down = true
    Timer.after(0.15, function()
        button.down = false
    end)
    
end

function countRunners:checkForCompletion()
    return self.count == #self.runners
end

function countRunners:draw()
    local button = self.button
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
    love.graphics.setColor(0.7,0,0)
    love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
    love.graphics.setColor(1,1,1)
end

function countRunners:keypressed(key) 
    print("are")
    self.ok = true
end

function countRunners:mousepressed(x, y, button)
    if button == 1 then
        if x > self.button.x and x < self.button.x+self.button.width then
            if y > self.button and y < self.button.y+self.button.height then
                self.button.down = true
                self.count = self.count + 1
            end
        end
    end
end

function countRunners:fail()
    return nil
end

return countRunners